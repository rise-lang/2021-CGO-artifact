#include "time.hpp"
#include "stats.hpp"

#include "shine_camera_pipe.h"

#include "camera_pipe.h"
#include "camera_pipe_auto_schedule.h"

#include "HalideBuffer.h"
#include "halide_image_io.h"

// #include <cassert>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <vector>

using namespace Halide::Runtime;
using namespace Halide::Tools;

int main(int argc, char **argv) {
    if (argc < 8) {
        printf("Usage: ./camera_pipe raw.png color_temp gamma contrast sharpen timing_iterations output.png\n"
               "e.g. ./camera_pipe raw.png 3700 2 50 1.0 5 output.png");
        return EXIT_FAILURE;
    }

    fprintf(stderr, "input: %s\n", argv[1]);
    Buffer<uint16_t> input = load_and_convert_image(argv[1]);
    for (int i = 0; i < input.dimensions(); i++) {
        fprintf(stderr, "    %d from %d by %d\n", input.dim(i).extent(), input.dim(i).min(), input.dim(i).stride());
    }
    Buffer<uint8_t> output1(((input.width() - 32) / 32) * 32, ((input.height() - 24) / 32) * 32, 3);

    // These color matrices are for the sensor in the Nokia N900 and are
    // taken from the FCam source.
    float _matrix_3200[][4] = {{1.6697f, -0.2693f, -0.4004f, -42.4346f},
                               {-0.3576f, 1.0615f, 1.5949f, -37.1158f},
                               {-0.2175f, -1.8751f, 6.9640f, -26.6970f}};

    float _matrix_7000[][4] = {{2.2997f, -0.4478f, 0.1706f, -39.0923f},
                               {-0.3826f, 1.5906f, -0.2080f, -25.4311f},
                               {-0.0888f, -0.7344f, 2.2832f, -20.0826f}};
    Buffer<float> matrix_3200(4, 3), matrix_7000(4, 3);
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 4; j++) {
            matrix_3200(j, i) = _matrix_3200[i][j];
            matrix_7000(j, i) = _matrix_7000[i][j];
        }
    }

    float color_temp = (float)atof(argv[2]);
    float gamma = (float)atof(argv[3]);
    float contrast = (float)atof(argv[4]);
    float sharpen = (float)atof(argv[5]);
    int timing_iterations = atoi(argv[6]);
    int blackLevel = 25;
    int whiteLevel = 1023;

    std::vector<double> sample_vec;

    for (int i = 0; i < timing_iterations; i++) {
        auto start = Clock::now();
        int h_error = camera_pipe(
            input, matrix_3200, matrix_7000,
            color_temp, gamma, contrast, sharpen, blackLevel, whiteLevel,
            output1);
        output1.device_sync();
        auto stop = Clock::now();

        if (h_error) {
            fprintf(stderr, "halide returned an error: %d\n", h_error);
            exit(EXIT_FAILURE);
        }

        sample_vec.push_back(std::chrono::duration<double, std::milli>(stop - start).count());
    }

    output1.copy_to_host();
    fprintf(stderr, "output: %s\n", argv[7]);
    convert_and_save_image(output1, argv[7]);
    for (int i = 0; i < output1.dimensions(); i++) {
        fprintf(stderr, "    %d from %d by %d\n", output1.dim(i).extent(), output1.dim(i).min(), output1.dim(i).stride());
    }

    TimeStats t_stats1 = time_stats(sample_vec);
    printf("manual: %.2lf [%.2lf ; %.2lf]\n", t_stats1.median_ms, t_stats1.min_ms, t_stats1.max_ms);

    ////

    Buffer<uint8_t> output2(output1.width(), output1.height(), 3);
    sample_vec.clear();

    for (int i = 0; i < timing_iterations; i++) {
        auto start = Clock::now();
        int h_error = camera_pipe_auto_schedule(
            input, matrix_3200, matrix_7000,
            color_temp, gamma, contrast, sharpen, blackLevel, whiteLevel,
            output2);
        output2.device_sync();
        auto stop = Clock::now();

        if (h_error) {
            fprintf(stderr, "halide returned an error: %d\n", h_error);
            exit(EXIT_FAILURE);
        }

        sample_vec.push_back(std::chrono::duration<double, std::milli>(stop - start).count());
    }

    output2.copy_to_host();

    TimeStats t_stats2 = time_stats(sample_vec);
    printf("  auto: %.2lf [%.2lf ; %.2lf]\n", t_stats2.median_ms, t_stats2.min_ms, t_stats2.max_ms);

    error_stats(output1.data(), output2.data(), 3 * output1.height() * output1.width(), 0.1, 0.001);

    ////

    Buffer<uint8_t> output3(output1.width(), output1.height(), 3);
    sample_vec.clear();

    for (int i = 0; i < timing_iterations; i++) {
        auto start = Clock::now();
        camera_pipe_shine(
            output3.data(),
            (input.height()-38)/2 - 2, (input.width()-22)/2 - 2,
            3, 4,
            input.data(),
            matrix_3200.data(), matrix_7000.data(), color_temp,
            gamma, contrast, blackLevel, whiteLevel, sharpen);
        auto stop = Clock::now();

        sample_vec.push_back(std::chrono::duration<double, std::milli>(stop - start).count());
    }

    TimeStats t_stats3 = time_stats(sample_vec);
    printf(" shine: %.2lf [%.2lf ; %.2lf]\n", t_stats3.median_ms, t_stats3.min_ms, t_stats3.max_ms);
    error_stats(output1.data(), output3.data(), 3 * output1.height() * output1.width(), 0.1, 0.001);

    return EXIT_SUCCESS;
}
