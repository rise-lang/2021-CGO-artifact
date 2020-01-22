#include "Halide.h"
#include "HalideBuffer.h"
#include <stdint.h>

#include "halide_image_io.h"

using std::vector;

using namespace Halide;
using namespace Halide::Tools;
using namespace Halide::ConciseCasts;

// Shared variables
Var x, y, c, yi, yo, yii, xi;

// Average two positive values rounding up
Expr avg(Expr a, Expr b) {
    Type wider = a.type().with_bits(a.type().bits() * 2);
    return cast(a.type(), (cast(wider, a) + b + 1) / 2);
}

Expr blur121(Expr a, Expr b, Expr c) {
    return avg(avg(a, c), b);
}

Func interleave_x(Func a, Func b) {
    Func out;
    out(x, y) = select((x % 2) == 0, a(x / 2, y), b(x / 2, y));
    return out;
}

Func interleave_y(Func a, Func b) {
    Func out;
    out(x, y) = select((y % 2) == 0, a(x, y / 2), b(x, y / 2));
    return out;
}

// Int(16), dim 3 -> Int(16), dim 3
Func demosaic(Func deinterleaved) {
    // These are the values we already know from the input
    // x_y = the value of channel x at a site in the input of channel y
    // gb refers to green sites in the blue rows
    // gr refers to green sites in the red rows

    // Give more convenient names to the four channels we know
    Func r_r, g_gr, g_gb, b_b;

    g_gr(x, y) = deinterleaved(x, y, 0);
    r_r(x, y) = deinterleaved(x, y, 1);
    b_b(x, y) = deinterleaved(x, y, 2);
    g_gb(x, y) = deinterleaved(x, y, 3);

    // These are the ones we need to interpolate
    Func b_r, g_r, b_gr, r_gr, b_gb, r_gb, r_b, g_b;

    // First calculate green at the red and blue sites

    // Try interpolating vertically and horizontally. Also compute
    // differences vertically and horizontally. Use interpolation in
    // whichever direction had the smallest difference.
    Expr gv_r = avg(g_gb(x, y - 1), g_gb(x, y));
    Expr gvd_r = absd(g_gb(x, y - 1), g_gb(x, y));
    Expr gh_r = avg(g_gr(x + 1, y), g_gr(x, y));
    Expr ghd_r = absd(g_gr(x + 1, y), g_gr(x, y));

    g_r(x, y) = select(ghd_r < gvd_r, gh_r, gv_r);

    Expr gv_b = avg(g_gr(x, y + 1), g_gr(x, y));
    Expr gvd_b = absd(g_gr(x, y + 1), g_gr(x, y));
    Expr gh_b = avg(g_gb(x - 1, y), g_gb(x, y));
    Expr ghd_b = absd(g_gb(x - 1, y), g_gb(x, y));

    g_b(x, y) = select(ghd_b < gvd_b, gh_b, gv_b);

    // Next interpolate red at gr by first interpolating, then
    // correcting using the error green would have had if we had
    // interpolated it in the same way (i.e. add the second derivative
    // of the green channel at the same place).
    Expr correction;
    correction = g_gr(x, y) - avg(g_r(x, y), g_r(x - 1, y));
    r_gr(x, y) = correction + avg(r_r(x - 1, y), r_r(x, y));

    // Do the same for other reds and blues at green sites
    correction = g_gr(x, y) - avg(g_b(x, y), g_b(x, y - 1));
    b_gr(x, y) = correction + avg(b_b(x, y), b_b(x, y - 1));

    correction = g_gb(x, y) - avg(g_r(x, y), g_r(x, y + 1));
    r_gb(x, y) = correction + avg(r_r(x, y), r_r(x, y + 1));

    correction = g_gb(x, y) - avg(g_b(x, y), g_b(x + 1, y));
    b_gb(x, y) = correction + avg(b_b(x, y), b_b(x + 1, y));

    // Now interpolate diagonally to get red at blue and blue at
    // red. Hold onto your hats; this gets really fancy. We do the
    // same thing as for interpolating green where we try both
    // directions (in this case the positive and negative diagonals),
    // and use the one with the lowest absolute difference. But we
    // also use the same trick as interpolating red and blue at green
    // sites - we correct our interpolations using the second
    // derivative of green at the same sites.

    correction = g_b(x, y) - avg(g_r(x, y), g_r(x - 1, y + 1));
    Expr rp_b = correction + avg(r_r(x, y), r_r(x - 1, y + 1));
    Expr rpd_b = absd(r_r(x, y), r_r(x - 1, y + 1));

    correction = g_b(x, y) - avg(g_r(x - 1, y), g_r(x, y + 1));
    Expr rn_b = correction + avg(r_r(x - 1, y), r_r(x, y + 1));
    Expr rnd_b = absd(r_r(x - 1, y), r_r(x, y + 1));

    r_b(x, y) = select(rpd_b < rnd_b, rp_b, rn_b);

    // Same thing for blue at red
    correction = g_r(x, y) - avg(g_b(x, y), g_b(x + 1, y - 1));
    Expr bp_r = correction + avg(b_b(x, y), b_b(x + 1, y - 1));
    Expr bpd_r = absd(b_b(x, y), b_b(x + 1, y - 1));

    correction = g_r(x, y) - avg(g_b(x + 1, y), g_b(x, y - 1));
    Expr bn_r = correction + avg(b_b(x + 1, y), b_b(x, y - 1));
    Expr bnd_r = absd(b_b(x + 1, y), b_b(x, y - 1));

    b_r(x, y) = select(bpd_r < bnd_r, bp_r, bn_r);

    // Resulting color channels
    Func r, g, b;

    // Interleave the resulting channels
    r = interleave_y(interleave_x(r_gr, r_r),
                        interleave_x(r_b, r_gb));
    g = interleave_y(interleave_x(g_gr, g_r),
                        interleave_x(g_b, g_gb));
    b = interleave_y(interleave_x(b_gr, b_r),
                        interleave_x(b_b, b_gb));

    Func output("demosaiced");
    output(x, y, c) = select(c == 0, r(x, y),
                                c == 1, g(x, y),
                                b(x, y));
                                
    return output;
}

Func hot_pixel_suppression(Func input) {
    Expr a = max(input(x - 2, y), input(x + 2, y),
                 input(x, y - 2), input(x, y + 2));

    Func denoised("denoised");
    denoised(x, y) = clamp(input(x, y), 0, a);

    return denoised;
}

Func deinterleave(Func raw) {
    // Deinterleave the color channels
    Func deinterleaved("deinterleaved");

    deinterleaved(x, y, c) = select(c == 0, raw(2 * x, 2 * y),
                                    c == 1, raw(2 * x + 1, 2 * y),
                                    c == 2, raw(2 * x, 2 * y + 1),
                                    raw(2 * x + 1, 2 * y + 1));
    return deinterleaved;
}

Func color_correct(
    Func input,
    Func matrix_3200, // float, dim 2
    Func matrix_7000, // float, dim 2
    Param<float> color_temp
) {
    // Get a color matrix by linearly interpolating between two
    // calibrated matrices using inverse kelvin.
    Expr kelvin = color_temp;

    Func matrix;
    Expr alpha = (1.0f / kelvin - 1.0f / 3200) / (1.0f / 7000 - 1.0f / 3200);
    Expr val = (matrix_3200(x, y) * alpha + matrix_7000(x, y) * (1 - alpha));
    matrix(x, y) = cast<int16_t>(val * 256.0f);  // Q8.8 fixed point

    matrix.compute_root();

    Expr ir = cast<int32_t>(input(x, y, 0));
    Expr ig = cast<int32_t>(input(x, y, 1));
    Expr ib = cast<int32_t>(input(x, y, 2));

    Expr r = matrix(3, 0) + matrix(0, 0) * ir + matrix(1, 0) * ig + matrix(2, 0) * ib;
    Expr g = matrix(3, 1) + matrix(0, 1) * ir + matrix(1, 1) * ig + matrix(2, 1) * ib;
    Expr b = matrix(3, 2) + matrix(0, 2) * ir + matrix(1, 2) * ig + matrix(2, 2) * ib;

    r = cast<int16_t>(r / 256);
    g = cast<int16_t>(g / 256);
    b = cast<int16_t>(b / 256);

    Func corrected("corrected");
    corrected(x, y, c) = select(c == 0, r,
                                c == 1, g,
                                b);

    return corrected;
}

Func apply_curve(
    Func input,
    Param<float> gamma,
    Param<float> contrast,
    Param<int> blackLevel,
    Param<int> whiteLevel
) {
    // copied from FCam
    Func curve("curve");

    Expr minRaw = 0 + blackLevel;
    Expr maxRaw = whiteLevel;

    // How much to upsample the LUT by when sampling it.
    int lutResample = 1;

    minRaw /= lutResample;
    maxRaw /= lutResample;

    Expr invRange = 1.0f / (maxRaw - minRaw);
    Expr b = 2.0f - pow(2.0f, contrast / 100.0f);
    Expr a = 2.0f - 2.0f * b;

    // Get a linear luminance in the range 0-1
    Expr xf = clamp(cast<float>(x - minRaw) * invRange, 0.0f, 1.0f);
    // Gamma correct it
    Expr g = pow(xf, 1.0f / gamma);
    // Apply a piecewise quadratic contrast curve
    Expr z = select(g > 0.5f,
                    1.0f - (a * (1.0f - g) * (1.0f - g) + b * (1.0f - g)),
                    a * g * g + b * g);

    // Convert to 8 bit and save
    Expr val = cast(UInt(8), clamp(z * 255.0f + 0.5f, 0.0f, 255.0f));
    // makeLUT add guard band outside of (minRaw, maxRaw]:
    curve(x) = select(x <= minRaw, 0, select(x > maxRaw, 255, val));

    // It's a LUT, compute it once ahead of time.
    curve.compute_root();

    Func curved;

    if (lutResample == 1) {
        // Use clamp to restrict size of LUT as allocated by compute_root
        curved(x, y, c) = curve(clamp(input(x, y, c), 0, 1023));
    } else {
        // Use linear interpolation to sample the LUT.
        Expr in = input(x, y, c);
        Expr u0 = in / lutResample;
        Expr u = in % lutResample;
        Expr y0 = curve(clamp(u0, 0, 127));
        Expr y1 = curve(clamp(u0 + 1, 0, 127));
        curved(x, y, c) = cast<uint8_t>((cast<uint16_t>(y0) * lutResample + (y1 - y0) * u) / lutResample);
    }

    return curved;
}

Func sharpen(Func input, Param<float> sharpen_strength) {
    // Convert the sharpening strength to 2.5 fixed point. This allows sharpening in the range [0, 4].
    Func sharpen_strength_x32("sharpen_strength_x32");
    sharpen_strength_x32() = u8_sat(sharpen_strength * 32);
    
    sharpen_strength_x32.compute_root();

    // Make an unsharp mask by blurring in y, then in x.
    Func unsharp_y("unsharp_y");
    unsharp_y(x, y, c) = blur121(input(x, y - 1, c), input(x, y, c), input(x, y + 1, c));

    Func unsharp("unsharp");
    unsharp(x, y, c) = blur121(unsharp_y(x - 1, y, c), unsharp_y(x, y, c), unsharp_y(x + 1, y, c));

    Func mask("mask");
    mask(x, y, c) = cast<int16_t>(input(x, y, c)) - cast<int16_t>(unsharp(x, y, c));

    // Weight the mask with the sharpening strength, and add it to the
    // input to get the sharpened result.
    Func sharpened("sharpened");
    sharpened(x, y, c) = u8_sat(input(x, y, c) + (mask(x, y, c) * sharpen_strength_x32()) / 32);

    return sharpened;
}

const float color_temp = 3700;
const float my_gamma = 2.0f;
const float contrast = 50;
const float sharpen_strength = 1.0f;
const int blackLevel = 25;
const int whiteLevel = 1023;

// These color matrices are for the sensor in the Nokia N900 and are
// taken from the FCam source.
const float _matrix_3200[][4] = {{1.6697f, -0.2693f, -0.4004f, -42.4346f},
                            {-0.3576f, 1.0615f, 1.5949f, -37.1158f},
                            {-0.2175f, -1.8751f, 6.9640f, -26.6970f}};

const float _matrix_7000[][4] = {{2.2997f, -0.4478f, 0.1706f, -39.0923f},
                            {-0.3826f, 1.5906f, -0.2080f, -25.4311f},
                            {-0.0888f, -0.7344f, 2.2832f, -20.0826f}};

// UInt(16), dim 2 -> UInt(8), dim 3
// Func camera_pipe(Func input)

template <typename T>
void dump_buffer(const char* name, Buffer<T> buf) {
    printf("---- %s ----\n", name);
    for (int i = 0; i < buf.dimensions(); i++) {
        printf("%d from %d by %d\n", buf.dim(i).extent(), buf.dim(i).min(), buf.dim(i).stride());
    }
    printf("----\n");

    FILE *f;
    f = fopen((std::string("camera_pipe:") + name + ".dump").c_str(), "w");
    buf.for_each_value([&](T v) {
        fprintf(f, "%d ", v);
    });
    fclose(f);
}

int main(int arc, char** argv) {
    Buffer<uint16_t> image = load_and_convert_image("../lib/halide/apps/images/bayer_raw.png");

    std::vector<std::pair<int, int>> rect = { {0, 324}, {0, 246} };
    Buffer<uint16_t> input(image.get()->cropped(rect));

    printf("---- input ----\n");
    for (int i = 0; i < input.dimensions(); i++) {
        printf("%d from %d by %d\n", input.dim(i).extent(), input.dim(i).min(), input.dim(i).stride());
    }
    printf("----\n");

    Buffer<float> matrix_3200(4, 3), matrix_7000(4, 3);
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 4; j++) {
            matrix_3200(j, i) = _matrix_3200[i][j];
            matrix_7000(j, i) = _matrix_7000[i][j];
        }
    }

    // shift things inwards to give us enough padding on the
    // boundaries so that we don't need to check bounds. We're going
    // to make a 2560x1920 output image, just like the FCam pipe, so
    // shift by 16, 12. We also convert it to be signed, so we can deal
    // with values that fall below 0 during processing.

    Func shifted;
    shifted(x, y) = cast<int16_t>(input(x + 16, y + 12));

    Func denoised = hot_pixel_suppression(shifted);

    Func deinterleaved = deinterleave(denoised);

    Func demosaiced = demosaic(deinterleaved);

    Func corrected = color_correct(
        demosaiced,
        Func(matrix_3200),
        Func(matrix_7000),
        Param<float>(color_temp)
    );

    Func curved = apply_curve(
        corrected,
        Param<float>(my_gamma),
        Param<float>(contrast),
        Param<int>(blackLevel),
        Param<int>(whiteLevel)
    );

    Func sharpened = sharpen(curved, Param<float>(sharpen_strength));

    Pipeline p = Pipeline({ shifted, denoised, deinterleaved, demosaiced, corrected, curved, sharpened });
    p.print_loop_nest();

    // -20, -36 dropped in Rise
    Buffer<int16_t> shifted_b(input.width() - 20, input.height() - 36);
    shifted_b.translate({ -6, -6 });
    // shifted_b.translate({ -16, -12 });
    Buffer<int16_t> denoised_b(shifted_b.width() - 4, shifted_b.height() - 4);
    denoised_b.translate({ -4, -4 });
    // denoised_b.translate({ -14, -10 });
    Buffer<int16_t> deinterleaved_b(denoised_b.width() / 2, denoised_b.height() / 2, 4);
    deinterleaved_b.translate({ -2, -2 });
    // deinterleaved_b.translate({ -7, -5 });
    Buffer<int16_t> demosaiced_b(deinterleaved_b.width() * 2 - 4, deinterleaved_b.height() * 2 - 4, 3);
    demosaiced_b.translate({ -2, -2 });
    // demosaiced_b.translate({ -12, -8 });
    Buffer<int16_t> corrected_b(demosaiced_b.width() - 2, demosaiced_b.height() - 2, 3);
    corrected_b.translate({ -1, -1 });
    // corrected_b.translate({ -12, -8 });
    Buffer<uint8_t> curved_b(corrected_b.width(), corrected_b.height(), 3);
    curved_b.translate({ -1, -1 });
    // curved_b.translate({ -12, -8 });
    Buffer<uint8_t> sharpened_b(curved_b.width() - 2, curved_b.height() - 2, 3);
    // sharpened_b.translate({ -11, -7 });
    p.realize({
       shifted_b, denoised_b, deinterleaved_b, demosaiced_b, corrected_b, curved_b, sharpened_b
    });

    dump_buffer("input", input);
    dump_buffer("shifted", shifted_b);
    dump_buffer("denoised", denoised_b);
    dump_buffer("deinterleaved", deinterleaved_b);
    dump_buffer("demosaiced", demosaiced_b);
    dump_buffer("corrected", corrected_b);
    dump_buffer("curved", curved_b);
    dump_buffer("sharpened", sharpened_b);

    return EXIT_SUCCESS;
}