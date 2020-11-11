#include <cstdlib>
#include <cstdio>
#include <vector>

#include "ocl.cpp"
#include "shine_harris.cpp"
#include "lift_harris.cpp"
// #include "harrisNeon.hpp"

#include "time.hpp"
#include "stats.hpp"

#include "harris.h"
#include "harris_auto_schedule.h"

#include "HalideBuffer.h"
#include "halide_image_io.h"

using namespace Halide::Runtime;
using namespace Halide::Tools;

#include <opencv2/imgproc.hpp>
#include <opencv2/core/ocl.hpp>

int main(int argc, char **argv) {
    if (argc != 6) {
        fprintf(stderr, "usage: %s rgba.png platform_subname device_type timing_iterations output.png\n", argv[0]);
        return EXIT_FAILURE;
    }

    fprintf(stderr, "input: %s\n", argv[1]);
    Buffer<float> input = load_and_convert_image(argv[1]);
    for (int i = 0; i < input.dimensions(); i++) {
        fprintf(stderr, "    %d from %d by %d\n", input.dim(i).extent(), input.dim(i).min(), input.dim(i).stride());
    }

    OCLExecutor ocl;
    ocl_init(&ocl, argv[2], argv[3]);

    int timing_iterations = atoi(argv[4]);
    const char* output_path = argv[5];

    Buffer<float> output1(input.width() - 4, input.height() - 4);
    output1.set_min(2, 2);
    std::vector<double> sample_vec;

    for (int i = 0; i < timing_iterations; i++) {
        auto start = Clock::now();
        int h_error = harris(input, output1);
        output1.device_sync();
        auto stop = Clock::now();

        if (h_error) {
            fprintf(stderr, "halide returned an error: %d\n", h_error);
            exit(EXIT_FAILURE);
        }

        sample_vec.push_back(std::chrono::duration<double, std::milli>(stop - start).count());
    }

    output1.copy_to_host();
    fprintf(stderr, "output: %s\n", output_path);
    convert_and_save_image(output1, output_path);
    for (int i = 0; i < output1.dimensions(); i++) {
        fprintf(stderr, "    %d from %d by %d\n", output1.dim(i).extent(), output1.dim(i).min(), output1.dim(i).stride());
    }

    TimeStats t_stats1 = time_stats(sample_vec);
    printf("%dx%d Halide halide %.2lf %.2lf %.2lf\n", input.dim(0).extent(), input.dim(1).extent(), t_stats1.median_ms, t_stats1.min_ms, t_stats1.max_ms);

    ////

    Buffer<float> output2(output1.width(), output1.height());
    output2.set_min(2, 2);
    sample_vec.clear();

    {
    // for (int i = 0; i < timing_iterations; i++) {
    //    auto start = Clock::now();
        int h_error = harris_auto_schedule(input, output2);
    //    output2.device_sync();
    //    auto stop = Clock::now();

        if (h_error) {
            fprintf(stderr, "halide returned an error: %d\n", h_error);
            exit(EXIT_FAILURE);
        }

    //    sample_vec.push_back(std::chrono::duration<double, std::milli>(stop - start).count());
    }

    output2.copy_to_host();

    // TimeStats t_stats2 = time_stats(sample_vec);
    // printf("%dx%d Halide auto %.2lf %.2lf %.2lf\n", input.dim(0).extent(), input.dim(1).extent(), t_stats2.median_ms, t_stats2.min_ms, t_stats2.max_ms);

    error_stats(output1.data(), output2.data(), output1.height() * output1.width(), 0.01, 100);

    ////

    ShineContext ctx;
    init_context(&ocl, &ctx, input.height(), input.width());
    std::vector<cl_ulong> ocl_sample_vec;

    for (int version = 0; version < SHINE_VERSIONS; version++) {
        ocl_sample_vec.clear();
        // wipe out any previous results for correctness check
        output2.fill(0);
        clear_context_output(&ocl, &ctx, input.height(), input.width());

        for (int i = 0; i < timing_iterations; i++) {
            cl_event event = shine_harris(&ocl, &ctx, version,
                output2.data(), input.height(), input.width(), input.data());

            cl_ulong start, stop;
            ocl_unwrap(clGetEventProfilingInfo(event, CL_PROFILING_COMMAND_START, sizeof(cl_ulong), &start, NULL));
            ocl_unwrap(clGetEventProfilingInfo(event, CL_PROFILING_COMMAND_END, sizeof(cl_ulong), &stop, NULL));
            ocl_sample_vec.push_back(stop - start);
        }

        TimeStats t_stats3 = ocl_time_stats(ocl_sample_vec);
        printf("%dx%d Rise %s %.2lf %.2lf %.2lf\n", input.dim(0).extent(), input.dim(1).extent(), SHINE_NAMES[version],
            t_stats3.median_ms, t_stats3.min_ms, t_stats3.max_ms);
        error_stats(output1.data(), output2.data(), output1.height() * output1.width(), 0.01, 100);
    }

    destroy_context(&ocl, &ctx);

    ////

    ocl_sample_vec.clear();
    // wipe out any previous results for correctness check
    output2.fill(0);

    LiftContext lift_ctx;
    init_lift_context(&ocl, &lift_ctx, input.height(), input.width());

    for (int i = 0; i < timing_iterations; i++) {
        auto events = lift_harris(&ocl, &lift_ctx,
        output2.data(), input.height(), input.width(), input.data());

        cl_ulong start, stop;
        ocl_unwrap(clGetEventProfilingInfo(events.first, CL_PROFILING_COMMAND_START, sizeof(cl_ulong), &start, NULL));
        ocl_unwrap(clGetEventProfilingInfo(events.second, CL_PROFILING_COMMAND_END, sizeof(cl_ulong), &stop, NULL));
        ocl_sample_vec.push_back(stop - start);
    }

    TimeStats t_stats3 = ocl_time_stats(ocl_sample_vec);
    printf("%dx%d Lift lift %.2lf %.2lf %.2lf\n", input.dim(0).extent(), input.dim(1).extent(),
        t_stats3.median_ms, t_stats3.min_ms, t_stats3.max_ms);
    error_stats(output1.data(), output2.data(), output1.height() * output1.width(), 0.01, 100);

    destroy_lift_context(&ocl, &lift_ctx);

    ////

    ocl_release(&ocl);

    ////
    output2.fill(0);
    sample_vec.clear();

    // rounding up output lines to 32
    size_t h = input.height();
    size_t w = input.width();
    size_t ho = (((h - 4) + 31) / 32) * 32;
    size_t hi = ho + 4;

    output2.fill(0);
    sample_vec.clear();
    cv::ocl::setUseOpenCL(false);

    cv::Mat cv_in(h, w, CV_32FC3);
    cv::Mat cv_gray(h, w, CV_32F);
    cv::Mat cv_out(h, w, CV_32F);

    for (int c = 0; c < 3; c++) {
      for (int y = 0; y < input.height(); y++) {
        for (int x = 0; x < input.width(); x++) {
          int i = ((c * input.height() + y) * input.width()) + x;
          cv_in.at<cv::Vec3f>(y, x)[c] = input.data()[i];
        }
      }
    }

    for (int i = 0; i < timing_iterations; i++) {
        auto start = Clock::now();
        cv::cvtColor(cv_in, cv_gray, cv::COLOR_RGB2GRAY);
        cv::cornerHarris(cv_gray, cv_out, 3, 3, 0.04, cv::BORDER_ISOLATED);
        auto stop = Clock::now();

        sample_vec.push_back(std::chrono::duration<double, std::milli>(stop - start).count());
    }

    for (int y = 0; y < output2.height(); y++) {
      for (int x = 0; x < output2.width(); x++) {
        int i = (y * output2.width()) + x;
        output2.data()[i] = cv_out.at<float>(y + 2, x + 2);
      }
    }

    TimeStats t_stats5 = time_stats(sample_vec);
    printf("%dx%d OpenCV opencv %.2lf %.2lf %.2lf\n", input.dim(0).extent(), input.dim(1).extent(), t_stats5.median_ms, t_stats5.min_ms, t_stats5.max_ms);

    error_stats(output1.data(), output2.data(), output1.height() * output1.width(), 0.01, 100);

    return EXIT_SUCCESS;
}
