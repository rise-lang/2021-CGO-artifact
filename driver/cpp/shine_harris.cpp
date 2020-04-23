const int SHINE_VERSIONS = 3;

const char* SHINE_SOURCES[SHINE_VERSIONS] = {
    //"shine-gen/harrisBVU.cl",
    //"shine-gen/harrisBVA.cl",
    //"shine-gen/harrisB3VUSP.cl",
    "shine-gen/harrisB3VUSPRW.cl",
    //"shine-gen/harrisB3VASP.cl",
    "shine-gen/harrisB3VASPRW.cl",
    //"shine-gen/harrisB3VASPRR.cl",
    "shine-gen/harrisB3VASPRRRW.cl",
    //"shine-gen/harrisB4VUSP.cl",
    //"shine-gen/harrisB4VASP.cl",
    //"shine-gen/harrisB4VASPRR.cl",
    //"shine-gen/harrisB3VUSP_tweaked.cl",
    //"shine-gen/harrisB3VUSPRW_tweaked.cl",
    //"shine-gen/harrisB3VASP_tweaked.cl",
    //"shine-gen/harrisB3VASP_tweaked2.cl",
    //"shine-gen/harrisB3VASP_tweaked3.cl",
    //"shine-gen/harrisB3VASP_tweaked4.cl",
    //"shine-gen/harrisB3VASP_tweakRed.cl",
    //"shine-gen/harrisB3VASP_tweakRed2.cl",
    //"shine-gen/harrisB3VASP_tweakedRR.cl",
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
        fprintf(stderr, "loading kernel %s\n", SHINE_SOURCES[i]);
        ocl_load_kernel("harris", SHINE_SOURCES[i], ocl, &ctx->harris[i]);
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

    size_t max_threads = ho / 32;
    size_t max_cbuf_size = 4 * (w + 8) * sizeof(float);
    ocl_create_compute_buffer(ocl, max_threads * max_cbuf_size, &ctx->cbuf1);
    ocl_create_compute_buffer(ocl, max_threads * max_cbuf_size, &ctx->cbuf2);
    ocl_create_compute_buffer(ocl, max_threads * max_cbuf_size, &ctx->cbuf3);
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

void clear_context_output(
    OCLExecutor* ocl, ShineContext* ctx, size_t h, size_t w
) {
    size_t ho = (((h - 4) + 31) / 32) * 32;
    float zero = 0.0f;
    ocl_unwrap(clEnqueueFillBuffer(ocl->queue, ctx->output, &zero, sizeof(float),
        0, ho * w * sizeof(float), 0, NULL, NULL));
}

cl_event shine_harris(
    OCLExecutor* ocl, ShineContext* ctx, int version,
    float* output, size_t h, size_t w, const float* input
) {
    // rounding up output lines to 32
    size_t ho = (((h - 4) + 31) / 32) * 32;
    size_t hi = ho + 4;

    std::vector<size_t> local_work_size = { 1 };
    std::vector<size_t> global_work_size = { 1 };
    //if (version >= 2) {
        global_work_size = { ho / 32 };
    //}

    ocl_set_kernel_args(ctx->harris[version], {
        ocl_data<cl_mem>(ctx->output), ocl_data<cl_int>(ho), ocl_data<cl_int>(w), ocl_data<cl_mem>(ctx->input),
        ocl_data<cl_mem>(ctx->cbuf3), ocl_data<cl_mem>(ctx->cbuf2), ocl_data<cl_mem>(ctx->cbuf1)
    });

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
    cl_event ev = ocl_enqueue_kernel(ocl, &ctx->harris[version], global_work_size, local_work_size);
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
    return ev;
}