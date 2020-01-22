#include <cstdlib>
#include <cstdio>
#include <cstdint>
#include <cstring>
#include <memory>

#include <vector>

#define CL_TARGET_OPENCL_VERSION 120
#define CL_USE_DEPRECATED_OPENCL_1_2_APIS
#ifdef __APPLE__
    #include "OpenCL/opencl.h"
#else
    #include "CL/cl.h"
#endif

const char* ocl_error_to_string(cl_int error) {
    switch (error) {
#define variant(x) case x: return #x;
        variant(CL_SUCCESS)
        variant(CL_DEVICE_NOT_FOUND)
        variant(CL_DEVICE_NOT_AVAILABLE)
        variant(CL_COMPILER_NOT_AVAILABLE)
        variant(CL_MEM_OBJECT_ALLOCATION_FAILURE)
        variant(CL_OUT_OF_RESOURCES)
        variant(CL_OUT_OF_HOST_MEMORY)
        variant(CL_PROFILING_INFO_NOT_AVAILABLE)
        variant(CL_MEM_COPY_OVERLAP)
        variant(CL_IMAGE_FORMAT_MISMATCH)
        variant(CL_IMAGE_FORMAT_NOT_SUPPORTED)
        variant(CL_BUILD_PROGRAM_FAILURE)
        variant(CL_MAP_FAILURE)
        variant(CL_MISALIGNED_SUB_BUFFER_OFFSET)
        variant(CL_EXEC_STATUS_ERROR_FOR_EVENTS_IN_WAIT_LIST)
        variant(CL_COMPILE_PROGRAM_FAILURE)
        variant(CL_LINKER_NOT_AVAILABLE)
        variant(CL_LINK_PROGRAM_FAILURE)
        variant(CL_DEVICE_PARTITION_FAILED)
        variant(CL_KERNEL_ARG_INFO_NOT_AVAILABLE)
        variant(CL_INVALID_VALUE)
        variant(CL_INVALID_DEVICE_TYPE)
        variant(CL_INVALID_PLATFORM)
        variant(CL_INVALID_DEVICE)
        variant(CL_INVALID_CONTEXT)
        variant(CL_INVALID_QUEUE_PROPERTIES)
        variant(CL_INVALID_COMMAND_QUEUE)
        variant(CL_INVALID_HOST_PTR)
        variant(CL_INVALID_MEM_OBJECT)
        variant(CL_INVALID_IMAGE_DESCRIPTOR)
        variant(CL_INVALID_IMAGE_SIZE)
        variant(CL_INVALID_SAMPLER)
        variant(CL_INVALID_BINARY)
        variant(CL_INVALID_BUILD_OPTIONS)
        variant(CL_INVALID_PROGRAM)
        variant(CL_INVALID_PROGRAM_EXECUTABLE)
        variant(CL_INVALID_KERNEL_NAME)
        variant(CL_INVALID_KERNEL_DEFINITION)
        variant(CL_INVALID_KERNEL)
        variant(CL_INVALID_ARG_INDEX)
        variant(CL_INVALID_ARG_VALUE)
        variant(CL_INVALID_ARG_SIZE)
        variant(CL_INVALID_KERNEL_ARGS)
        variant(CL_INVALID_WORK_DIMENSION)
        variant(CL_INVALID_WORK_GROUP_SIZE)
        variant(CL_INVALID_WORK_ITEM_SIZE)
        variant(CL_INVALID_GLOBAL_OFFSET)
        variant(CL_INVALID_EVENT_WAIT_LIST)
        variant(CL_INVALID_EVENT)
        variant(CL_INVALID_OPERATION)
        variant(CL_INVALID_BUFFER_SIZE)
        variant(CL_INVALID_GLOBAL_WORK_SIZE)
        variant(CL_INVALID_PROPERTY)
        variant(CL_INVALID_COMPILER_OPTIONS)
        variant(CL_INVALID_LINKER_OPTIONS)
        variant(CL_INVALID_DEVICE_PARTITION_COUNT)
#undef variant
        default: return "UNKNOWN CL ERROR";
    }
}

bool ocl_error(cl_int error) {
    if (error != CL_SUCCESS) {
        fprintf(stderr, "%s\n", ocl_error_to_string(error));
        return true;
    }
    return false;
}

void ocl_unwrap(cl_int error) {
    if (ocl_error(error)) { exit(EXIT_FAILURE); }
}

struct OCLExecutor {
    cl_platform_id platform;
    cl_device_id device;
    cl_context context;
    cl_command_queue queue;
};

cl_platform_id find_platform(cl_uint platform_count, const cl_platform_id* platform_ids, const char* subname) {
    for (cl_uint i = 0; i < platform_count; i++) {
        char name_buf[512];
        size_t name_size;
        ocl_unwrap(clGetPlatformInfo(platform_ids[i], CL_PLATFORM_NAME, sizeof(name_buf), name_buf, &name_size));
        if (name_size > sizeof(name_buf)) {
            fprintf(stderr, "did not expect such a long OpenCL platform name (%zu)\n", name_size);
            name_buf[511] = '\0';
        }

        if (strstr(name_buf, subname) != NULL) {
            fprintf(stderr, "using OpenCL platform '%s'\n", name_buf);
            return platform_ids[i];
        }
    }

    fprintf(stderr, "did not find any OpenCL platform with subname '%s'\n", subname);
    exit(EXIT_FAILURE);
}

void ocl_init(OCLExecutor* ocl, const char* platform_subname, const char* device_type_str) {
    cl_device_type device_type;
    if (strcmp(device_type_str, "cpu") == 0) {
        device_type = CL_DEVICE_TYPE_CPU;
    } else if (strcmp(device_type_str, "gpu") == 0) {
        device_type = CL_DEVICE_TYPE_GPU;
    } else {
        fprintf(stderr, "unexpected device type string: %s\n", device_type_str);
        exit(EXIT_FAILURE);
    }

    const cl_uint platform_entries = 256;
    cl_platform_id platform_ids[platform_entries];
    cl_uint platform_count = 0;
    ocl_unwrap(clGetPlatformIDs(platform_entries, platform_ids, &platform_count));
    if (platform_count > platform_entries) {
        fprintf(stderr, "did not expected that many OpenCL platforms (%u)\n", platform_count);
        platform_count = platform_entries;
    }

    cl_platform_id platform_id = find_platform(platform_count, platform_ids, platform_subname);

    const cl_uint device_entries = 1;
    cl_uint device_count = 0;
    cl_device_id device_id;
    ocl_unwrap(clGetDeviceIDs(platform_id, device_type, device_entries, &device_id, &device_count));
    if (device_count == 0) {
        fprintf(stderr, "did not find any OpenCL device\n");
        exit(EXIT_FAILURE);
    }
    // fprintf(stderr, "OpenCL device: %u\n", device_index);

    const cl_context_properties ctx_props[] = {
        CL_CONTEXT_PLATFORM, (cl_context_properties)(platform_id),
        0
    };

    cl_int err;
    cl_context ctx = clCreateContext(ctx_props, 1, &device_id, NULL, NULL, &err);
    ocl_unwrap(err);

    // 2.0: clCreateCommandQueueWithProperties
    cl_command_queue queue = clCreateCommandQueue(ctx, device_id, CL_QUEUE_PROFILING_ENABLE, &err);
    ocl_unwrap(err);

    ocl->platform = platform_id;
    ocl->device = device_id;
    ocl->context = ctx;
    ocl->queue = queue;
}

void ocl_release(OCLExecutor* ocl) {
    ocl_error(clReleaseCommandQueue(ocl->queue));
    ocl_error(clReleaseContext(ocl->context));
}

struct OCLKernel {
    cl_program program;
    cl_kernel inner;
};

void ocl_load_kernel(const char* name, const char* path, OCLExecutor* ocl, OCLKernel* k) {
    FILE* f = fopen(path, "rb");
    if (!f) {
        fprintf(stderr, "could not open source\n");
        exit(EXIT_FAILURE);
    }
    fseek(f, 0, SEEK_END);
    size_t length = ftell(f);
    rewind(f);
    char* source = (char*) malloc(length * sizeof(char));
    if (fread(source, sizeof(char), length, f) != length) {
        fprintf(stderr, "could not read source\n");
        exit(EXIT_FAILURE);
    }
    fclose(f);

    cl_int err;
    const char* sources[] = { source };
    const size_t lengths[] = { length };
    cl_program program = clCreateProgramWithSource(ocl->context, 1, sources, lengths, &err);
    free(source);
    ocl_unwrap(err);

    // 2.0: -cl-uniform-work-group-size
    const char* options = "-cl-fast-relaxed-math -Werror -cl-std=CL1.2";
    if (ocl_error(clBuildProgram(program, 1, &ocl->device, options, NULL, NULL))) {
        size_t log_size;
        ocl_unwrap(clGetProgramBuildInfo(program, ocl->device, CL_PROGRAM_BUILD_LOG, 0, NULL, &log_size));
        char* log_string = (char*) malloc(log_size * sizeof(char));
        ocl_unwrap(clGetProgramBuildInfo(program, ocl->device, CL_PROGRAM_BUILD_LOG, log_size, log_string, NULL));
        fprintf(stderr, "%s\n", log_string);
        free(log_string);
        exit(EXIT_FAILURE);
    }

    cl_kernel kernel = clCreateKernel(program, name, &err);
    ocl_unwrap(err);

    k->program = program;
    k->inner = kernel;
}

void ocl_release_kernel(OCLKernel* k) {
    ocl_error(clReleaseKernel(k->inner));
    ocl_error(clReleaseProgram(k->program));
}

void ocl_create_compute_buffer(OCLExecutor* ocl, size_t byte_size, cl_mem* buffer) {
    cl_int ocl_err;
    *buffer = clCreateBuffer(ocl->context, CL_MEM_READ_WRITE | CL_MEM_HOST_NO_ACCESS,
                             byte_size, NULL, &ocl_err);
    ocl_unwrap(ocl_err);
}

void ocl_release_mem(cl_mem m) {
    ocl_error(clReleaseMemObject(m));
}

class OCLKernelArg {
    public:
        virtual cl_int setFor(cl_kernel k, cl_uint index) = 0;
};

template <typename T>
struct OCLData : OCLKernelArg {
    T value;
    OCLData(T t) { value = t; }
    cl_int setFor(cl_kernel k, cl_uint index) override {
        return clSetKernelArg(k, index, sizeof(T), &value);
    }
};

template <typename T>
std::shared_ptr<OCLKernelArg> ocl_data(T t) { return std::make_shared<OCLData<T>>(t); }

struct OCLLocalMem : OCLKernelArg {
    size_t size;
    OCLLocalMem(size_t s) { size = s; }
    cl_int setFor(cl_kernel k, cl_uint index) override {
        return clSetKernelArg(k, index, size, NULL);
    }
};

std::shared_ptr<OCLKernelArg> ocl_local_mem(size_t size) { return std::make_shared<OCLLocalMem>(size); }

// shared pointer is to allow initializer lists ...
void ocl_set_kernel_args(OCLKernel& k, std::vector<std::shared_ptr<OCLKernelArg>> args) {
    for (size_t i = 0; i < args.size(); i++) {
        ocl_unwrap(args[i]->setFor(k.inner, i));
    }
}

cl_event ocl_enqueue_kernel(OCLExecutor* ocl, OCLKernel* k,
                            std::vector<size_t> global_work_size, std::vector<size_t> local_work_size)
{
    cl_uint work_dim = global_work_size.size();
    if (global_work_size.size() != local_work_size.size()) {
        fprintf(stderr, "the number of dimensions used to specify global and local work sizes differs\n");
        exit(EXIT_FAILURE);
    }

    cl_event e;
    ocl_unwrap(clEnqueueNDRangeKernel(ocl->queue, k->inner, work_dim, NULL, global_work_size.data(), local_work_size.data(), 0, NULL, &e));
    return e;
}