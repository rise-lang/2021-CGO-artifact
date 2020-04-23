#include <arm_neon.h>

typedef float32x4_t float4;

#define vload(ptr) vld1q_f32(ptr)
#define vstore(v, ptr) vst1q_f32(ptr, v)

#define vleft1(a, b) vextq_f32(a, b, 3)
#define vright1(b, c) vextq_f32(b, c, 1)

#define vadd(a, b) vaddq_f32(a, b)
#define vsub(a, b) vsubq_f32(a, b)
#define vmul(a, b) vmulq_f32(a, b)
#define vset(s) vdupq_n_f32(s)
