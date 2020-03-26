const int SHINE_VERSIONS = 5;

const char* SHINE_SOURCES[SHINE_VERSIONS] = {
    "shine-gen/harrisBVU.cl",
    "shine-gen/harrisBVA.cl",
    "shine-gen/harrisBVUSP.cl",
    "shine-gen/harrisBVUSPRW.cl",
    "shine-gen/harrisBVASP.cl",
};

struct ShineContext {
    OCLKernel harris[SHINE_VERSIONS];

    cl_mem input;
    cl_mem output;
    cl_mem cbuf1;
    cl_mem cbuf2;
    cl_mem cbuf3;
};

void init_context(OCLExecutor* ocl, ShineContext* ctx, size_t h, size_t w) {
    for (int i = 0; i < SHINE_VERSIONS; i++) {
        ocl_load_kernel("harris", SHINE_SOURCES[i], ocl, &ctx->harris[i]);
    }

    cl_int ocl_err;
    ctx->input = clCreateBuffer(ocl->context, CL_MEM_READ_ONLY | CL_MEM_HOST_WRITE_ONLY,
        3 * h * w * sizeof(float), NULL, &ocl_err);
    ocl_unwrap(ocl_err);
    ctx->output = clCreateBuffer(ocl->context, CL_MEM_WRITE_ONLY | CL_MEM_HOST_READ_ONLY,
        (h-4) * w * sizeof(float), NULL, &ocl_err);
    ocl_unwrap(ocl_err);

    // note: allocating for worst case scenario where there is one thread per output line
    // and 3 full lines are buffered
    ocl_create_compute_buffer(ocl, h * 3 * w * sizeof(float), &ctx->cbuf1);
    ocl_create_compute_buffer(ocl, h * 3 * w * sizeof(float), &ctx->cbuf2);
    ocl_create_compute_buffer(ocl, h * 3 * w * sizeof(float), &ctx->cbuf3);
}

void destroy_context(OCLExecutor* ocl, ShineContext* ctx) {
    for (int i = 0; i < SHINE_VERSIONS; i++) {
        ocl_release_kernel(&ctx->harris[i]);
    }

    ocl_release_mem(ctx->input);
    ocl_release_mem(ctx->output);
    ocl_release_mem(ctx->cbuf1);
    ocl_release_mem(ctx->cbuf2);
    ocl_release_mem(ctx->cbuf3);
}

cl_event shine_harris(
    OCLExecutor* ocl, ShineContext* ctx, int version,
    float* output, size_t h, size_t w, const float* input
) {
    std::vector<size_t> local_work_size = { 1 };
    std::vector<size_t> global_work_size = { 1 };
    if (version >= 2) {
        global_work_size = { h / 32 }; // note: or a smaller amount of threads
    }

    ocl_set_kernel_args(ctx->harris[version], {
        ocl_data<cl_mem>(ctx->output), ocl_data<cl_int>(h - 4), ocl_data<cl_int>(w), ocl_data<cl_mem>(ctx->input),
        ocl_data<cl_mem>(ctx->cbuf3), ocl_data<cl_mem>(ctx->cbuf2), ocl_data<cl_mem>(ctx->cbuf1)
    });

    ocl_unwrap(clEnqueueWriteBuffer(ocl->queue, ctx->input, false, 0,
        3 * h * w * sizeof(float), input, 0, NULL, NULL));
    cl_event ev = ocl_enqueue_kernel(ocl, &ctx->harris[version], global_work_size, local_work_size);

    size_t buffer_origin[3] = { 0 };
    size_t host_origin[3] = { 0 };
    size_t region[3] = { (w-4) * sizeof(float), (h-4), 1 };
    size_t buffer_row_pitch = w * sizeof(float);
    size_t host_row_pitch = (w-4) * sizeof(float);
    ocl_unwrap(clEnqueueReadBufferRect(ocl->queue, ctx->output, false,
        buffer_origin, host_origin, region,
        buffer_row_pitch, 0, host_row_pitch, 0,
        output, 0, NULL, NULL));
    ocl_unwrap(clFinish(ocl->queue));

    return ev;
}