#include <cmath>
#include <algorithm>
#include <vector>

void error_stats(float* gold, float* other, size_t n, double tolerated_per_pixel, double required_psnr) {
    double square_sum = 0.f;
    double min = 1.f / 0.f;
    double max = 0.f;
    float min_g = 1.f / 0.f;
    float max_g = -min_g;

    for (int i = 0; i < n; i++) {
        min_g = std::min(min_g, gold[i]);
        max_g = std::max(max_g, gold[i]);
        double delta = (double)(gold[i]) - (double)(other[i]);
        double d_abs = std::abs(delta);
        min = std::min(min, d_abs);
        max = std::max(max, d_abs);
        square_sum += d_abs * d_abs;
    }

    double mse = square_sum / n;
    double range = (double)(max_g) - (double)(min_g);
    double psnr = 10.0 * log10((range * range) / mse);
    min /= range;
    max /= range;

    fprintf(stderr, "error stats: [%.3lf - %.3lf]*(%.4lf) with %.2lf PSNR\n", min, max, range, psnr);
    if (max > tolerated_per_pixel || psnr < required_psnr) {
        fprintf(stderr, "maximum tolerated error of %.4f per pixel, and minimum PSNR of %.2f\n",
            tolerated_per_pixel, required_psnr);
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