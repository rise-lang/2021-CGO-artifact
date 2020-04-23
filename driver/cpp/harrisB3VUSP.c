#include "neon.h"
#include <omp.h>

void harrisB3VUSP(float* restrict output, int n0, int n1, const float* restrict x0, float* restrict x2350, float* restrict x2349, float* restrict x2364){
  #pragma omp parallel for schedule(static, 1)
  for (int gl_id_2476 = 0; gl_id_2476 < (n0 / 32); gl_id_2476 += 1) {
    int get_global_id = omp_get_thread_num();
    for (int i_2477 = 0;(i_2477 < 2);i_2477 = (1 + i_2477)) {
      /* mapSeq */
      for (int i_2478 = 0;(i_2478 < (n1 / 4));i_2478 = (1 + i_2478)) {
        /* oclReduceSeq */
        {
          float4 x2393 = vadd(vadd(
	        vmul(vset(0.299f), vload(&x0[(((4 * i_2478) + ((32 * gl_id_2476) * n1)) + (i_2477 * n1))])),
	        vmul(vset(0.587f), vload(&x0[(((((4 * i_2478) + (4 * n1)) + ((32 * gl_id_2476) * n1)) + (i_2477 * n1)) + (n0 * n1))]))),
	        vmul(vset(0.114f), vload(&x0[((((((2 * n0) * n1) + (4 * i_2478)) + (8 * n1)) + ((32 * gl_id_2476) * n1)) + (i_2477 * n1))])));
          vstore(x2393, (&(x2364[(((((2 * i_2477) + ((3 * n1) * get_global_id)) + (4 * i_2478)) + (6 * get_global_id)) + (i_2477 * n1))])));
        }
        
      }
      
    }
    
    for (int i_2515 = 0;(i_2515 < 2);i_2515 = (1 + i_2515)) {
      /* mapSeq */
      for (int i_2516 = 0;(i_2516 < (n1 / 4));i_2516 = (1 + i_2516)) {
        /* oclReduceSeq */
        {
          float4 x2433 = vadd(vadd(
            vmul(vset(0.299f), vload(&(x0[((((2 * n1) + (4 * i_2516)) + ((32 * gl_id_2476) * n1)) + (i_2515 * n1))]))),
	        vmul(vset(0.587f), vload(&(x0[(((((4 * i_2516) + (6 * n1)) + ((32 * gl_id_2476) * n1)) + (i_2515 * n1)) + (n0 * n1))])))),
	        vmul(vset(0.114f), vload(&(x0[((((((2 * n0) * n1) + (4 * i_2516)) + (10 * n1)) + ((32 * gl_id_2476) * n1)) + (i_2515 * n1))]))));
          vstore(x2433, &(x2364[(((((2 * ((2 + i_2515) % 3)) + ((3 * n1) * get_global_id)) + (4 * i_2516)) + (6 * get_global_id)) + (n1 * ((2 + i_2515) % 3)))]));
        }
        
      }
      
      /* mapSeq */
      for (int i_2553 = 0;(i_2553 < (n1 / 4));i_2553 = (1 + i_2553)) {
        {
          float4 x2328[9];
          /* mapSeq */
          /* unrolling loop of 9 */
          x2328[0] = vload(&x2364[(((((2 * i_2515) + ((3 * n1) * get_global_id)) + (4 * i_2553)) + (6 * get_global_id)) + (i_2515 * n1))]);
          x2328[1] = vload(&x2364[(((((1 + (2 * i_2515)) + ((3 * n1) * get_global_id)) + (4 * i_2553)) + (6 * get_global_id)) + (i_2515 * n1))]);
          x2328[2] = vload(&x2364[(((((2 + (2 * i_2515)) + ((3 * n1) * get_global_id)) + (4 * i_2553)) + (6 * get_global_id)) + (i_2515 * n1))]);
          x2328[3] = vload(&x2364[((((((2 + n1) + (2 * i_2515)) + ((3 * n1) * get_global_id)) + (4 * i_2553)) + (6 * get_global_id)) + (i_2515 * n1))]);
          x2328[4] = vload(&x2364[((((((3 + n1) + (2 * i_2515)) + ((3 * n1) * get_global_id)) + (4 * i_2553)) + (6 * get_global_id)) + (i_2515 * n1))]);
          x2328[5] = vload(&x2364[((((((4 + n1) + (2 * i_2515)) + ((3 * n1) * get_global_id)) + (4 * i_2553)) + (6 * get_global_id)) + (i_2515 * n1))]);
          x2328[6] = vload(&x2364[(((((2 * ((2 + i_2515) % 3)) + ((3 * n1) * get_global_id)) + (4 * i_2553)) + (6 * get_global_id)) + (n1 * ((2 + i_2515) % 3)))]);
          x2328[7] = vload(&x2364[(((((1 + (2 * ((2 + i_2515) % 3))) + ((3 * n1) * get_global_id)) + (4 * i_2553)) + (6 * get_global_id)) + (n1 * ((2 + i_2515) % 3)))]);
          x2328[8] = vload(&x2364[(((((2 + (2 * ((2 + i_2515) % 3))) + ((3 * n1) * get_global_id)) + (4 * i_2553)) + (6 * get_global_id)) + (n1 * ((2 + i_2515) % 3)))]);
          /* oclReduceSeq */
          {
            float4 x2283 = vadd(vadd(vadd(vadd(vadd(
              vmul(vset(-0.083333336f), x2328[0]),
              vmul(vset(0.083333336f), x2328[2])),
              vmul(vset(-0.16666667f), x2328[3])),
              vmul(vset(0.16666667f), x2328[5])),
              vmul(vset(-0.083333336f), x2328[6])),
              vmul(vset(0.083333336f), x2328[8]));
            vstore(x2283, (&(x2349[(((((2 * i_2515) + ((3 * n1) * get_global_id)) + (4 * i_2553)) + (6 * get_global_id)) + (i_2515 * n1))])));
          }
          
          /* oclReduceSeq */
          {
            float4 x2309 = vadd(vadd(vadd(vadd(vadd(
              vmul(vset(-0.083333336f), x2328[0]),
              vmul(vset(-0.16666667f), x2328[1])),
              vmul(vset(-0.083333336f), x2328[2])),
              vmul(vset(0.083333336f), x2328[6])),
              vmul(vset(0.16666667f), x2328[7])),
              vmul(vset(0.083333336f), x2328[8]));
            vstore(x2309, (&(x2350[(((((2 * i_2515) + ((3 * n1) * get_global_id)) + (4 * i_2553)) + (6 * get_global_id)) + (i_2515 * n1))])));
          }
          
        }
        
      }
      
    }
    
    /* iterateStream */
    for (int i_2608 = 0;(i_2608 < 32);i_2608 = (1 + i_2608)) {
      /* mapSeq */
      for (int i_2609 = 0;(i_2609 < (n1 / 4));i_2609 = (1 + i_2609)) {
        /* oclReduceSeq */
        {
          float4 x2451 = vadd(vadd(
            vmul(vset(0.299f), vload((&(x0[((((4 * i_2609) + (4 * n1)) + ((32 * gl_id_2476) * n1)) + (i_2608 * n1))])))),
            vmul(vset(0.587f), vload((&(x0[(((((4 * i_2609) + (8 * n1)) + ((32 * gl_id_2476) * n1)) + (i_2608 * n1)) + (n0 * n1))]))))),
            vmul(vset(0.114f), vload((&(x0[((((((2 * n0) * n1) + (4 * i_2609)) + (12 * n1)) + ((32 * gl_id_2476) * n1)) + (i_2608 * n1))])))));
          vstore(x2451, (&(x2364[(((((2 * ((1 + i_2608) % 3)) + ((3 * n1) * get_global_id)) + (4 * i_2609)) + (6 * get_global_id)) + (n1 * ((1 + i_2608) % 3)))])));
        }
        
      }
      
      /* mapSeq */
      for (int i_2646 = 0;(i_2646 < (n1 / 4));i_2646 = (1 + i_2646)) {
        {
          float4 x2328[9];
          /* mapSeq */
          /* unrolling loop of 9 */
          x2328[0] = vload(&x2364[(((((2 * ((2 + i_2608) % 3)) + ((3 * n1) * get_global_id)) + (4 * i_2646)) + (6 * get_global_id)) + (n1 * ((2 + i_2608) % 3)))]);
          x2328[1] = vload(&x2364[(((((1 + (2 * ((2 + i_2608) % 3))) + ((3 * n1) * get_global_id)) + (4 * i_2646)) + (6 * get_global_id)) + (n1 * ((2 + i_2608) % 3)))]);
          x2328[2] = vload(&x2364[(((((2 + (2 * ((2 + i_2608) % 3))) + ((3 * n1) * get_global_id)) + (4 * i_2646)) + (6 * get_global_id)) + (n1 * ((2 + i_2608) % 3)))]);
          x2328[3] = vload(&x2364[(((((2 * (i_2608 % 3)) + ((3 * n1) * get_global_id)) + (4 * i_2646)) + (6 * get_global_id)) + (n1 * (i_2608 % 3)))]);
          x2328[4] = vload(&x2364[(((((1 + (2 * (i_2608 % 3))) + ((3 * n1) * get_global_id)) + (4 * i_2646)) + (6 * get_global_id)) + (n1 * (i_2608 % 3)))]);
          x2328[5] = vload(&x2364[(((((2 + (2 * (i_2608 % 3))) + ((3 * n1) * get_global_id)) + (4 * i_2646)) + (6 * get_global_id)) + (n1 * (i_2608 % 3)))]);
          x2328[6] = vload(&x2364[(((((2 * ((1 + i_2608) % 3)) + ((3 * n1) * get_global_id)) + (4 * i_2646)) + (6 * get_global_id)) + (n1 * ((1 + i_2608) % 3)))]);
          x2328[7] = vload(&x2364[(((((1 + (2 * ((1 + i_2608) % 3))) + ((3 * n1) * get_global_id)) + (4 * i_2646)) + (6 * get_global_id)) + (n1 * ((1 + i_2608) % 3)))]);
          x2328[8] = vload(&x2364[(((((2 + (2 * ((1 + i_2608) % 3))) + ((3 * n1) * get_global_id)) + (4 * i_2646)) + (6 * get_global_id)) + (n1 * ((1 + i_2608) % 3)))]);
          /* oclReduceSeq */
          {
            float4 x2283 = vadd(vadd(vadd(vadd(vadd(
              vmul(vset(-0.083333336f), x2328[0]),
              vmul(vset(0.083333336f), x2328[2])),
              vmul(vset(-0.16666667f), x2328[3])),
              vmul(vset(0.16666667f), x2328[5])),
              vmul(vset(-0.083333336f), x2328[6])),
              vmul(vset(0.083333336f), x2328[8]));
            vstore(x2283, (&(x2349[(((((2 * ((2 + i_2608) % 3)) + ((3 * n1) * get_global_id)) + (4 * i_2646)) + (6 * get_global_id)) + (n1 * ((2 + i_2608) % 3)))])));
          }
          
          /* oclReduceSeq */
          {
            float4 x2309 = vadd(vadd(vadd(vadd(vadd(
              vmul(vset(-0.083333336f), x2328[0]),
              vmul(vset(-0.16666667f), x2328[1])),
              vmul(vset(-0.083333336f), x2328[2])),
              vmul(vset(0.083333336f), x2328[6])),
              vmul(vset(0.16666667f), x2328[7])),
              vmul(vset(0.083333336f), x2328[8]));
            vstore(x2309, (&(x2350[(((((2 * ((2 + i_2608) % 3)) + ((3 * n1) * get_global_id)) + (4 * i_2646)) + (6 * get_global_id)) + (n1 * ((2 + i_2608) % 3)))])));
          }
          
        }
        
      }
      
      /* mapSeq */
      for (int i_2701 = 0;(i_2701 < (n1 / 4));i_2701 = (1 + i_2701)) {
        {
          float4 tix[9];
          float4 tiy[9];
          /* mapSeq */
          /* unrolling loop of 3 */
          /* mapSeq */
          /* unrolling loop of 3 */
          tix[0] = vload(&x2349[(((((2 * (i_2608 % 3)) + ((3 * n1) * get_global_id)) + (4 * i_2701)) + (6 * get_global_id)) + (n1 * (i_2608 % 3)))]);
          tix[1] = vload(&x2349[(((((1 + (2 * (i_2608 % 3))) + ((3 * n1) * get_global_id)) + (4 * i_2701)) + (6 * get_global_id)) + (n1 * (i_2608 % 3)))]);
          tix[2] = vload(&x2349[(((((2 + (2 * (i_2608 % 3))) + ((3 * n1) * get_global_id)) + (4 * i_2701)) + (6 * get_global_id)) + (n1 * (i_2608 % 3)))]);
          tix[3] = vload(&x2349[(((((2 * ((1 + i_2608) % 3)) + ((3 * n1) * get_global_id)) + (4 * i_2701)) + (6 * get_global_id)) + (n1 * ((1 + i_2608) % 3)))]);
          tix[4] = vload(&x2349[(((((1 + (2 * ((1 + i_2608) % 3))) + ((3 * n1) * get_global_id)) + (4 * i_2701)) + (6 * get_global_id)) + (n1 * ((1 + i_2608) % 3)))]);
          tix[5] = vload(&x2349[(((((2 + (2 * ((1 + i_2608) % 3))) + ((3 * n1) * get_global_id)) + (4 * i_2701)) + (6 * get_global_id)) + (n1 * ((1 + i_2608) % 3)))]);
          tix[6] = vload(&x2349[(((((2 * ((2 + i_2608) % 3)) + ((3 * n1) * get_global_id)) + (4 * i_2701)) + (6 * get_global_id)) + (n1 * ((2 + i_2608) % 3)))]);
          tix[7] = vload(&x2349[(((((1 + (2 * ((2 + i_2608) % 3))) + ((3 * n1) * get_global_id)) + (4 * i_2701)) + (6 * get_global_id)) + (n1 * ((2 + i_2608) % 3)))]);
          tix[8] = vload(&x2349[(((((2 + (2 * ((2 + i_2608) % 3))) + ((3 * n1) * get_global_id)) + (4 * i_2701)) + (6 * get_global_id)) + (n1 * ((2 + i_2608) % 3)))]);

          tiy[0] = vload(&x2350[(((((2 * (i_2608 % 3)) + ((3 * n1) * get_global_id)) + (4 * i_2701)) + (6 * get_global_id)) + (n1 * (i_2608 % 3)))]);
          tiy[1] = vload(&x2350[(((((1 + (2 * (i_2608 % 3))) + ((3 * n1) * get_global_id)) + (4 * i_2701)) + (6 * get_global_id)) + (n1 * (i_2608 % 3)))]);
          tiy[2] = vload(&x2350[(((((2 + (2 * (i_2608 % 3))) + ((3 * n1) * get_global_id)) + (4 * i_2701)) + (6 * get_global_id)) + (n1 * (i_2608 % 3)))]);
          tiy[3] = vload(&x2350[(((((2 * ((1 + i_2608) % 3)) + ((3 * n1) * get_global_id)) + (4 * i_2701)) + (6 * get_global_id)) + (n1 * ((1 + i_2608) % 3)))]);
          tiy[4] = vload(&x2350[(((((1 + (2 * ((1 + i_2608) % 3))) + ((3 * n1) * get_global_id)) + (4 * i_2701)) + (6 * get_global_id)) + (n1 * ((1 + i_2608) % 3)))]);
          tiy[5] = vload(&x2350[(((((2 + (2 * ((1 + i_2608) % 3))) + ((3 * n1) * get_global_id)) + (4 * i_2701)) + (6 * get_global_id)) + (n1 * ((1 + i_2608) % 3)))]);
          tiy[6] = vload(&x2350[(((((2 * ((2 + i_2608) % 3)) + ((3 * n1) * get_global_id)) + (4 * i_2701)) + (6 * get_global_id)) + (n1 * ((2 + i_2608) % 3)))]);
          tiy[7] = vload(&x2350[(((((1 + (2 * ((2 + i_2608) % 3))) + ((3 * n1) * get_global_id)) + (4 * i_2701)) + (6 * get_global_id)) + (n1 * ((2 + i_2608) % 3)))]);
          tiy[8] = vload(&x2350[(((((2 + (2 * ((2 + i_2608) % 3))) + ((3 * n1) * get_global_id)) + (4 * i_2701)) + (6 * get_global_id)) + (n1 * ((2 + i_2608) % 3)))]);
          {
            float4 x2186 = vadd(vadd(vadd(vadd(vadd(vadd(vadd(vadd(
              tix[0] * tix[0],
              tix[1] * tix[1]),
              tix[2] * tix[2]),
              tix[3] * tix[3]),
              tix[4] * tix[4]),
              tix[5] * tix[5]),
              tix[6] * tix[6]),
              tix[7] * tix[7]),
              tix[8] * tix[8]);

              float4 x2162 = vadd(vadd(vadd(vadd(vadd(vadd(vadd(vadd(
                tix[0] * tiy[0],
                tix[1] * tiy[1]),
                tix[2] * tiy[2]),
                tix[3] * tiy[3]),
                tix[4] * tiy[4]),
                tix[5] * tiy[5]),
                tix[6] * tiy[6]),
                tix[7] * tiy[7]),
                tix[8] * tiy[8]);

                float4 x2138 = vadd(vadd(vadd(vadd(vadd(vadd(vadd(vadd(
                  tiy[0] * tiy[0],
                  tiy[1] * tiy[1]),
                  tiy[2] * tiy[2]),
                  tiy[3] * tiy[3]),
                  tiy[4] * tiy[4]),
                  tiy[5] * tiy[5]),
                  tiy[6] * tiy[6]),
                  tiy[7] * tiy[7]),
                  tiy[8] * tiy[8]);
                
                vstore(vsub(vsub(vmul(x2186, x2138), vmul(x2162, x2162)), vmul(vmul(vset(0.04f), vadd(x2186, x2138)), vadd(x2186, x2138))), (&(output[(((4 * i_2701) + ((32 * gl_id_2476) * n1)) + (i_2608 * n1))])));
          }
        }
      }
    }
  }
}
