extern "C" {

#include <stdint.h>

void camera_pipe_shine(
    uint8_t* output,
    int h, int w,
    int hm, int wm,
    uint16_t* input,
    float* matrix_3200,
    float* matrix_7000,
    float color_temp,
    float gamma,
    float contrast,
    int blackLevel,
    int whiteLevel,
    float sharpen_strength
);

}