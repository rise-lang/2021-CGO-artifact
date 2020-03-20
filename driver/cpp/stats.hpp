#include <cmath>
#include <algorithm>
#include <vector>

template <typename T>
void error_stats(T* a, T* b, int n, float tolerated_per_pixel, float tolerated_mse) {
    double square_sum = 0.f;
    double min = 1.f / 0.f;
    double max = 0.f;
    uint64_t count = 0;

    for (int i = 0; i < n; i++) {
        double delta = (double)(a[i]) - (double)(b[i]);
        double d_abs = std::abs(delta);
        if (d_abs > tolerated_per_pixel) {
            count++;
        }
        min = std::min(min, d_abs);
        max = std::max(max, d_abs);
        square_sum += d_abs * d_abs;
    }

    double mse = square_sum / n;

    fprintf(stderr, "%lu errors: [%.3lf - %.3lf] with %.2lf MSE\n", count, min, max, mse);
    if (max > tolerated_per_pixel || mse > tolerated_mse) {
        fprintf(stderr, "maximum tolerated error: %.4f per pixel and %.4f MSE\n",
            tolerated_per_pixel, tolerated_mse);
        exit(EXIT_FAILURE);
    }
}

struct TimeStats {
    double min_ms;
    double max_ms;
    double median_ms;
};

TimeStats time_stats(std::vector<double>& samples) {
    auto to_ms = [&](double ms) { return ms; };
    std::sort(samples.begin(), samples.end());
    return {
        .min_ms = to_ms(samples.front()),
        .max_ms = to_ms(samples.back()),
        .median_ms = to_ms(samples[samples.size() / 2])
    };
}

#ifdef CL_TARGET_OPENCL_VERSION
TimeStats ocl_time_stats(std::vector<cl_ulong>& samples) {
    auto to_ms = [&](cl_ulong nanoseconds) {
        double ms = (double)(nanoseconds) * 1e-6;
        return ms;
    };
    std::sort(samples.begin(), samples.end());
    return {
        .min_ms = to_ms(samples.front()),
        .max_ms = to_ms(samples.back()),
        .median_ms = to_ms(samples[samples.size() / 2])
    };
}
#endif