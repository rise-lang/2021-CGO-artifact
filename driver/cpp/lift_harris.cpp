const size_t HARRIS_KERNELS = 6;
const char* HARRIS_KERNEL_NAMES[HARRIS_KERNELS] = {
    "gray", "sobelX", "sobelY", "mul", "sum3x3", "coarsity"
};
const char* HARRIS_KERNEL_SOURCES[HARRIS_KERNELS] = {
    "lift-gen/grayP.cl",
    "lift-gen/sobelXP.cl",
    "lift-gen/sobelYP.cl",
    "lift-gen/mulP.cl",
    "lift-gen/sum3x3P.cl",
    "lift-gen/coarsityP.cl"
};

const size_t HARRIS_BUFS = 9;
struct LiftContext {
    OCLKernel kernels[HARRIS_KERNELS];

    cl_mem input;
    cl_mem output;
    cl_mem bufs[HARRIS_BUFS];
};

void init_lift_context(OCLExecutor* ocl, LiftContext* ctx, size_t h, size_t w) {
    for (int i = 0; i < HARRIS_KERNELS; i++) {
        fprintf(stderr, "loading kernel %s\n", HARRIS_KERNEL_SOURCES[i]);
        ocl_load_kernel(HARRIS_KERNEL_NAMES[i], HARRIS_KERNEL_SOURCES[i], ocl, &ctx->kernels[i]);
    }

    // rounding up output lines to 32
    size_t ho = (((h - 4) + 31) / 32) * 32;
    size_t hi = ho + 4;

    cl_int ocl_err;
    ctx->input = clCreateBuffer(ocl->context, CL_MEM_READ_ONLY | CL_MEM_HOST_WRITE_ONLY,
        3 * hi * w * sizeof(float), NULL, &ocl_err);
    ocl_unwrap(ocl_err);
    ctx->output = clCreateBuffer(ocl->context, CL_MEM_WRITE_ONLY | CL_MEM_HOST_READ_ONLY,
        ho * w * sizeof(float), NULL, &ocl_err);
    ocl_unwrap(ocl_err);

    size_t max_buf_size = hi * w * sizeof(float);
    for (int i = 0; i < HARRIS_BUFS; i++) {
        ocl_create_compute_buffer(ocl, max_buf_size, &ctx->bufs[i]);
    }
}

void destroy_lift_context(OCLExecutor* ocl, LiftContext* ctx) {
    for (int i = 0; i < HARRIS_KERNELS; i++) {
        ocl_release_kernel(&ctx->kernels[i]);
    }

    ocl_release_mem(ctx->input);
    ocl_release_mem(ctx->output);
    for (int i = 0; i < HARRIS_BUFS; i++) {
        ocl_release_mem(ctx->bufs[i]);
    }
}

void clear_lift_context_output(
    OCLExecutor* ocl, LiftContext* ctx, size_t h, size_t w
) {
    size_t ho = (((h - 4) + 31) / 32) * 32;
    float zero = 0.0f;
    ocl_unwrap(clEnqueueFillBuffer(ocl->queue, ctx->output, &zero, sizeof(float),
        0, ho * w * sizeof(float), 0, NULL, NULL));
}

std::pair<cl_event, cl_event> lift_harris(
    OCLExecutor* ocl, LiftContext* ctx,
    float* output, size_t h, size_t w, const float* input
) {
    // rounding up output lines to 32
    size_t ho = (((h - 4) + 31) / 32) * 32;
    size_t hi = ho + 4;

    std::vector<size_t> local_work_size = { 1 };
    std::vector<size_t> global_work_size = { ho / 32 };

    size_t origin[3] = { 0 };
    {
        size_t region[3] = { w * sizeof(float), h, 3 };
        size_t buffer_slice_pitch = hi * w * sizeof(float);
        size_t host_slice_pitch = h * w * sizeof(float);
        ocl_unwrap(clEnqueueWriteBufferRect(ocl->queue, ctx->input, false,
            origin, origin, region,
            0, buffer_slice_pitch, 0, host_slice_pitch,
            input, 0, NULL, NULL));
    }

    // gray
    ocl_set_kernel_args(ctx->kernels[0], {
        ocl_data<cl_mem>(ctx->bufs[0]), ocl_data<cl_int>(ho), ocl_data<cl_int>(w), ocl_data<cl_mem>(ctx->input)
    });
    cl_event first_event = ocl_enqueue_kernel(ocl, &ctx->kernels[0], global_work_size, local_work_size);

    // sobelX
    ocl_set_kernel_args(ctx->kernels[1], {
        ocl_data<cl_mem>(ctx->bufs[1]), ocl_data<cl_int>(ho), ocl_data<cl_int>(w), ocl_data<cl_mem>(ctx->bufs[0])
    });
    ocl_enqueue_kernel(ocl, &ctx->kernels[1], global_work_size, local_work_size);

    // sobelY
    ocl_set_kernel_args(ctx->kernels[2], {
        ocl_data<cl_mem>(ctx->bufs[2]), ocl_data<cl_int>(ho), ocl_data<cl_int>(w), ocl_data<cl_mem>(ctx->bufs[0])
    });
    ocl_enqueue_kernel(ocl, &ctx->kernels[2], global_work_size, local_work_size);

    // mul
    ocl_set_kernel_args(ctx->kernels[3], {
        ocl_data<cl_mem>(ctx->bufs[3]), ocl_data<cl_int>(ho), ocl_data<cl_int>(w), ocl_data<cl_mem>(ctx->bufs[1]), ocl_data<cl_mem>(ctx->bufs[1])
    });
    ocl_enqueue_kernel(ocl, &ctx->kernels[3], global_work_size, local_work_size);

    ocl_set_kernel_args(ctx->kernels[3], {
        ocl_data<cl_mem>(ctx->bufs[4]), ocl_data<cl_int>(ho), ocl_data<cl_int>(w), ocl_data<cl_mem>(ctx->bufs[1]), ocl_data<cl_mem>(ctx->bufs[2])
    });
    ocl_enqueue_kernel(ocl, &ctx->kernels[3], global_work_size, local_work_size);

    ocl_set_kernel_args(ctx->kernels[3], {
        ocl_data<cl_mem>(ctx->bufs[5]), ocl_data<cl_int>(ho), ocl_data<cl_int>(w), ocl_data<cl_mem>(ctx->bufs[2]), ocl_data<cl_mem>(ctx->bufs[2])
    });
    ocl_enqueue_kernel(ocl, &ctx->kernels[3], global_work_size, local_work_size);

    // sum3x3
    ocl_set_kernel_args(ctx->kernels[4], {
        ocl_data<cl_mem>(ctx->bufs[6]), ocl_data<cl_int>(ho), ocl_data<cl_int>(w), ocl_data<cl_mem>(ctx->bufs[3])
    });
    ocl_enqueue_kernel(ocl, &ctx->kernels[4], global_work_size, local_work_size);

    ocl_set_kernel_args(ctx->kernels[4], {
        ocl_data<cl_mem>(ctx->bufs[7]), ocl_data<cl_int>(ho), ocl_data<cl_int>(w), ocl_data<cl_mem>(ctx->bufs[4])
    });
    ocl_enqueue_kernel(ocl, &ctx->kernels[4], global_work_size, local_work_size);

    ocl_set_kernel_args(ctx->kernels[4], {
        ocl_data<cl_mem>(ctx->bufs[8]), ocl_data<cl_int>(ho), ocl_data<cl_int>(w), ocl_data<cl_mem>(ctx->bufs[5])
    });
    ocl_enqueue_kernel(ocl, &ctx->kernels[4], global_work_size, local_work_size);

    // coarsity
    ocl_set_kernel_args(ctx->kernels[5], {
        ocl_data<cl_mem>(ctx->output), ocl_data<cl_int>(ho), ocl_data<cl_int>(w), ocl_data<cl_mem>(ctx->bufs[6]), ocl_data<cl_mem>(ctx->bufs[7]), ocl_data<cl_mem>(ctx->bufs[8])
    });
    cl_event last_event = ocl_enqueue_kernel(ocl, &ctx->kernels[5], global_work_size, local_work_size);


    {
        size_t region[3] = { (w-4) * sizeof(float), (h-4), 1 };
        size_t buffer_row_pitch = w * sizeof(float);
        size_t host_row_pitch = (w-4) * sizeof(float);
        ocl_unwrap(clEnqueueReadBufferRect(ocl->queue, ctx->output, false,
            origin, origin, region,
            buffer_row_pitch, 0, host_row_pitch, 0,
            output, 0, NULL, NULL));
    }
    ocl_unwrap(clFinish(ocl->queue));

    return std::make_pair(first_event, last_event);
}