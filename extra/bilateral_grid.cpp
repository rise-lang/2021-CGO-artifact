#include "Halide.h"

using namespace Halide;

Var x("x"), y("y"), z("z"), c("c");

// output dim2 float
Func bilateral_grid(
    int s_sigma, // default 8
    ImageParam input, // dim2 float
    Param<float> r_sigma
) {
    Func output;

    // Add a boundary condition
    Func clamped = Halide::BoundaryConditions::repeat_edge(input);

    // Construct the bilateral grid
    RDom r(0, s_sigma, 0, s_sigma);
    Expr val = clamped(x * s_sigma + r.x - s_sigma / 2, y * s_sigma + r.y - s_sigma / 2);
    val = clamp(val, 0.0f, 1.0f);

    Expr zi = cast<int>(val * (1.0f / r_sigma) + 0.5f);

    Func histogram("histogram");
    histogram(x, y, z, c) = 0.0f;
    histogram(x, y, zi, c) += select(c == 0, val, 1.0f);

    // Blur the grid using a five-tap filter
    Func blurx("blurx"), blury("blury"), blurz("blurz");
    blurz(x, y, z, c) = (histogram(x, y, z - 2, c) +
                         histogram(x, y, z - 1, c) * 4 +
                         histogram(x, y, z, c) * 6 +
                         histogram(x, y, z + 1, c) * 4 +
                         histogram(x, y, z + 2, c));
    blurx(x, y, z, c) = (blurz(x - 2, y, z, c) +
                         blurz(x - 1, y, z, c) * 4 +
                         blurz(x, y, z, c) * 6 +
                         blurz(x + 1, y, z, c) * 4 +
                         blurz(x + 2, y, z, c));
    blury(x, y, z, c) = (blurx(x, y - 2, z, c) +
                         blurx(x, y - 1, z, c) * 4 +
                         blurx(x, y, z, c) * 6 +
                         blurx(x, y + 1, z, c) * 4 +
                         blurx(x, y + 2, z, c));

    // Take trilinear samples to compute the output
    val = clamp(input(x, y), 0.0f, 1.0f);
    Expr zv = val * (1.0f / r_sigma);
    zi = cast<int>(zv);
    Expr zf = zv - zi;
    Expr xf = cast<float>(x % s_sigma) / s_sigma;
    Expr yf = cast<float>(y % s_sigma) / s_sigma;
    Expr xi = x / s_sigma;
    Expr yi = y / s_sigma;
    Func interpolated("interpolated");
    interpolated(x, y, c) =
        lerp(lerp(lerp(blury(xi, yi, zi, c), blury(xi + 1, yi, zi, c), xf),
                  lerp(blury(xi, yi + 1, zi, c), blury(xi + 1, yi + 1, zi, c), xf), yf),
             lerp(lerp(blury(xi, yi, zi + 1, c), blury(xi + 1, yi, zi + 1, c), xf),
                  lerp(blury(xi, yi + 1, zi + 1, c), blury(xi + 1, yi + 1, zi + 1, c), xf), yf),
             zf);

    // Normalize
    output(x, y) = interpolated(x, y, 0) / interpolated(x, y, 1);

    /* ESTIMATES */
    // (This can be useful in conjunction with RunGen and benchmarks as well
    // as auto-schedule, so we do it in all cases.)
    // Provide estimates on the input image
    input.set_estimates({{0, 1536}, {0, 2560}});
    // Provide estimates on the parameters
    r_sigma.set_estimate(0.1f);
    // TODO: Compute estimates from the parameter values
    histogram.set_estimate(z, -2, 16);
    blurz.set_estimate(z, 0, 12);
    blurx.set_estimate(z, 0, 12);
    blury.set_estimate(z, 0, 12);
    output.set_estimates({{0, 1536}, {0, 2560}});

    return output;
}

int H = 40;
int W = 24;

int s_sigma = 8;
float r_sigma = 0.1;

int main(int arc, char** argv) {
    Func input_;
    input_(x, y) = random_float();
    Buffer<float> input = input_.realize(W, H);

    printf("---- input ----\n");
    for (int y = 0; y < H; y++) {
        for (int x = 0; x < W; x ++) {
            printf("%.4f ", input(x, y));
        }
    }
    printf("----\n");

    ImageParam input_param(Float(32), 2);
    ParamMap params;
    params.set(input_param, input);
    Target t = get_jit_target_from_environment();
    Buffer<float> output = bilateral_grid(
        s_sigma,
        input_param,
        Param<float>(r_sigma)
    ).realize(W, H, t, params);

    printf("---- output ----\n");
    for (int y = 0; y < H; y++) {
        for (int x = 0; x < W; x ++) {
            printf("%.4f ", output(x, y));
        }
    }
    printf("----\n");

    return EXIT_SUCCESS;
}