

__kernel
void harris(global float* restrict output, int n0, int n1, const global float* restrict x0, global float4* restrict x18389, global float4* restrict x18388, global float4* restrict x18403){
  /* Start of moved local vars */
  /* End of moved local vars */
  /* mapGlobal */
  for (int gl_id_18515 = get_global_id(0);(gl_id_18515 < (n0 / 32));gl_id_18515 = (gl_id_18515 + get_global_size(0))) {
    for (int i_18516 = 0;(i_18516 < 2);i_18516 = (1 + i_18516)) {
      /* mapSeq */
      for (int i_18517 = 0;(i_18517 < (n1 / 4));i_18517 = (1 + i_18517)) {
        /* oclReduceSeq */
        {
          float4 x18432;
          x18432 = (float4)(0.0f);
          /* unrolling loop of 3 */
          x18432 = (x18432 + ((float4)(0.299f) * vload4(0, (&(x0[(((4 * i_18517) + ((32 * gl_id_18515) * n1)) + (i_18516 * n1))])))));
          x18432 = (x18432 + ((float4)(0.587f) * vload4(0, (&(x0[(((((4 * i_18517) + (4 * n1)) + ((32 * gl_id_18515) * n1)) + (i_18516 * n1)) + (n0 * n1))])))));
          x18432 = (x18432 + ((float4)(0.114f) * vload4(0, (&(x0[((((((2 * n0) * n1) + (4 * i_18517)) + (8 * n1)) + ((32 * gl_id_18515) * n1)) + (i_18516 * n1))])))));
          x18403[((((i_18516 + i_18517) + (((3 * n1) * get_global_id(0)) / 4)) + (3 * get_global_id(0))) + ((i_18516 * n1) / 4))] = x18432;
        }
        
      }
      
    }
    
    for (int i_18554 = 0;(i_18554 < 2);i_18554 = (1 + i_18554)) {
      /* mapSeq */
      for (int i_18555 = 0;(i_18555 < (n1 / 4));i_18555 = (1 + i_18555)) {
        /* oclReduceSeq */
        {
          float4 x18472;
          x18472 = (float4)(0.0f);
          /* unrolling loop of 3 */
          x18472 = (x18472 + ((float4)(0.299f) * vload4(0, (&(x0[((((2 * n1) + (4 * i_18555)) + ((32 * gl_id_18515) * n1)) + (i_18554 * n1))])))));
          x18472 = (x18472 + ((float4)(0.587f) * vload4(0, (&(x0[(((((4 * i_18555) + (6 * n1)) + ((32 * gl_id_18515) * n1)) + (i_18554 * n1)) + (n0 * n1))])))));
          x18472 = (x18472 + ((float4)(0.114f) * vload4(0, (&(x0[((((((2 * n0) * n1) + (4 * i_18555)) + (10 * n1)) + ((32 * gl_id_18515) * n1)) + (i_18554 * n1))])))));
          x18403[((((i_18555 + ((2 + i_18554) % 3)) + (((3 * n1) * get_global_id(0)) / 4)) + (3 * get_global_id(0))) + ((n1 * ((2 + i_18554) % 3)) / 4))] = x18472;
        }
        
      }
      
      /* mapSeq */
      for (int i_18592 = 0;(i_18592 < (n1 / 4));i_18592 = (1 + i_18592)) {
        float4 tmp1 = x18403[((((i_18554 + i_18592) + (((3 * n1) * get_global_id(0)) / 4)) + (3 * get_global_id(0))) + ((i_18554 * n1) / 4))];
        float4 tmp2 = x18403[(((((1 + i_18554) + i_18592) + (((3 * n1) * get_global_id(0)) / 4)) + (3 * get_global_id(0))) + ((i_18554 * n1) / 4))];
        float4 tmp3 = x18403[((((((1 + i_18554) + i_18592) + (((3 * n1) * get_global_id(0)) / 4)) + (3 * get_global_id(0))) + ((i_18554 * n1) / 4)) + (n1 / 4))];
        float4 tmp4 = x18403[((((((2 + i_18554) + i_18592) + (((3 * n1) * get_global_id(0)) / 4)) + (3 * get_global_id(0))) + ((i_18554 * n1) / 4)) + (n1 / 4))];
        float4 tmp5 = x18403[((((i_18592 + ((2 + i_18554) % 3)) + (((3 * n1) * get_global_id(0)) / 4)) + (3 * get_global_id(0))) + ((n1 * ((2 + i_18554) % 3)) / 4))];
        float4 tmp6 = x18403[(((((1 + i_18592) + ((2 + i_18554) % 3)) + (((3 * n1) * get_global_id(0)) / 4)) + (3 * get_global_id(0))) + ((n1 * ((2 + i_18554) % 3)) / 4))];

        /* oclReduceSeq */
        {
          float4 x18333;
          x18333 = (float4)(0.0f);
          /* unrolling loop of 9 */
          x18333 = (x18333 + ((float4)(((float[3]){-0.083333336f, 0.0f, 0.083333336f})[0]) * (float4)(tmp1.s0, tmp1.s1, tmp1.s2, tmp1.s3)));
          x18333 = (x18333 + ((float4)(((float[3]){-0.083333336f, 0.0f, 0.083333336f})[1]) * (float4)(tmp1.s1, tmp1.s2, tmp1.s3, tmp2.s0)));
          x18333 = (x18333 + ((float4)(((float[3]){-0.083333336f, 0.0f, 0.083333336f})[2]) * (float4)(tmp1.s2, tmp1.s3, tmp2.s0, tmp2.s1)));
          x18333 = (x18333 + ((float4)(((float[3]){-0.16666667f, 0.0f, 0.16666667f})[0]) * (float4)(tmp3.s0, tmp3.s1, tmp3.s2, tmp3.s3)));
          x18333 = (x18333 + ((float4)(((float[3]){-0.16666667f, 0.0f, 0.16666667f})[1]) * (float4)(tmp3.s1, tmp3.s2, tmp3.s3, tmp4.s0)));
          x18333 = (x18333 + ((float4)(((float[3]){-0.16666667f, 0.0f, 0.16666667f})[2]) * (float4)(tmp3.s2, tmp3.s3, tmp4.s0, tmp4.s1)));
          x18333 = (x18333 + ((float4)(((float[3]){-0.083333336f, 0.0f, 0.083333336f})[0]) * (float4)(tmp5.s0, tmp5.s1, tmp5.s2, tmp5.s3)));
          x18333 = (x18333 + ((float4)(((float[3]){-0.083333336f, 0.0f, 0.083333336f})[1]) * (float4)(tmp5.s1, tmp5.s2, tmp5.s3, tmp6.s0)));
          x18333 = (x18333 + ((float4)(((float[3]){-0.083333336f, 0.0f, 0.083333336f})[2]) * (float4)(tmp5.s2, tmp5.s3, tmp6.s0, tmp6.s1)));
          x18388[((((i_18554 + i_18592) + (((3 * n1) * get_global_id(0)) / 4)) + (3 * get_global_id(0))) + ((i_18554 * n1) / 4))] = x18333;
        }
        
        /* oclReduceSeq */
        {
          float4 x18372;
          x18372 = (float4)(0.0f);
          /* unrolling loop of 9 */
          x18372 = (x18372 + ((float4)(((float[3]){-0.083333336f, -0.16666667f, -0.083333336f})[0]) * (float4)(tmp1.s0, tmp1.s1, tmp1.s2, tmp1.s3)));
          x18372 = (x18372 + ((float4)(((float[3]){-0.083333336f, -0.16666667f, -0.083333336f})[1]) * (float4)(tmp1.s1, tmp1.s2, tmp1.s3, tmp2.s0)));
          x18372 = (x18372 + ((float4)(((float[3]){-0.083333336f, -0.16666667f, -0.083333336f})[2]) * (float4)(tmp1.s2, tmp1.s3, tmp2.s0, tmp2.s1)));
          x18372 = (x18372 + ((float4)(((float[3]){0.0f, 0.0f, 0.0f})[0]) * (float4)(tmp3.s0, tmp3.s1, tmp3.s2, tmp3.s3)));
          x18372 = (x18372 + ((float4)(((float[3]){0.0f, 0.0f, 0.0f})[1]) * (float4)(tmp3.s1, tmp3.s2, tmp3.s3, tmp4.s0)));
          x18372 = (x18372 + ((float4)(((float[3]){0.0f, 0.0f, 0.0f})[2]) * (float4)(tmp3.s2, tmp3.s3, tmp4.s0, tmp4.s1)));
          x18372 = (x18372 + ((float4)(((float[3]){0.083333336f, 0.16666667f, 0.083333336f})[0]) * (float4)(tmp5.s0, tmp5.s1, tmp5.s2, tmp5.s3)));
          x18372 = (x18372 + ((float4)(((float[3]){0.083333336f, 0.16666667f, 0.083333336f})[1]) * (float4)(tmp5.s1, tmp5.s2, tmp5.s3, tmp6.s0)));
          x18372 = (x18372 + ((float4)(((float[3]){0.083333336f, 0.16666667f, 0.083333336f})[2]) * (float4)(tmp5.s2, tmp5.s3, tmp6.s0, tmp6.s1)));
          x18389[((((i_18554 + i_18592) + (((3 * n1) * get_global_id(0)) / 4)) + (3 * get_global_id(0))) + ((i_18554 * n1) / 4))] = x18372;
        }
        
      }
      
    }
    
    /* iterateStream */
    for (int i_18877 = 0;(i_18877 < 32);i_18877 = (1 + i_18877)) {
      /* mapSeq */
      for (int i_18878 = 0;(i_18878 < (n1 / 4));i_18878 = (1 + i_18878)) {
        /* oclReduceSeq */
        {
          float4 x18490;
          x18490 = (float4)(0.0f);
          /* unrolling loop of 3 */
          x18490 = (x18490 + ((float4)(0.299f) * vload4(0, (&(x0[((((4 * i_18878) + (4 * n1)) + ((32 * gl_id_18515) * n1)) + (i_18877 * n1))])))));
          x18490 = (x18490 + ((float4)(0.587f) * vload4(0, (&(x0[(((((4 * i_18878) + (8 * n1)) + ((32 * gl_id_18515) * n1)) + (i_18877 * n1)) + (n0 * n1))])))));
          x18490 = (x18490 + ((float4)(0.114f) * vload4(0, (&(x0[((((((2 * n0) * n1) + (4 * i_18878)) + (12 * n1)) + ((32 * gl_id_18515) * n1)) + (i_18877 * n1))])))));
          x18403[((((i_18878 + ((1 + i_18877) % 3)) + (((3 * n1) * get_global_id(0)) / 4)) + (3 * get_global_id(0))) + ((n1 * ((1 + i_18877) % 3)) / 4))] = x18490;
        }
        
      }

      float4 ld00 = x18403[((((0 + ((2 + i_18877) % 3)) + (((3 * n1) * get_global_id(0)) / 4)) + (3 * get_global_id(0))) + ((n1 * ((2 + i_18877) % 3)) / 4))];
      float4 ld10 = x18403[((((0 + (i_18877 % 3)) + (((3 * n1) * get_global_id(0)) / 4)) + (3 * get_global_id(0))) + ((n1 * (i_18877 % 3)) / 4))];
      float4 ld20 = x18403[((((0 + ((1 + i_18877) % 3)) + (((3 * n1) * get_global_id(0)) / 4)) + (3 * get_global_id(0))) + ((n1 * ((1 + i_18877) % 3)) / 4))];
      float4 rotX0 = ld00 + (float4)(2.f) * ld10 + ld20;
      float4 rotY0 = -ld00 + ld20;
      /* mapSeq */
      for (int i_18915 = 0;(i_18915 < (n1 / 4));i_18915 = (1 + i_18915)) {
        float4 ld01 = x18403[(((((1 + i_18915) + ((2 + i_18877) % 3)) + (((3 * n1) * get_global_id(0)) / 4)) + (3 * get_global_id(0))) + ((n1 * ((2 + i_18877) % 3)) / 4))];
        float4 ld11 = x18403[(((((1 + i_18915) + (i_18877 % 3)) + (((3 * n1) * get_global_id(0)) / 4)) + (3 * get_global_id(0))) + ((n1 * (i_18877 % 3)) / 4))];
        float4 ld21 = x18403[(((((1 + i_18915) + ((1 + i_18877) % 3)) + (((3 * n1) * get_global_id(0)) / 4)) + (3 * get_global_id(0))) + ((n1 * ((1 + i_18877) % 3)) / 4))];
        float4 rotX1 = ld01 + (float4)(2.f) * ld11 + ld21;
        float4 rotY1 = -ld01 + ld21;

        float4 ix =
          -0.083333336f * (float4)(rotX0.s0, rotX0.s1, rotX0.s2, rotX0.s3) +
          0.0f * (float4)(rotX0.s1, rotX0.s2, rotX0.s3, rotX1.s0) +
          0.083333336f * (float4)(rotX0.s2, rotX0.s3, rotX1.s0, rotX1.s1);
        float4 iy =
          0.083333336f * (float4)(rotY0.s0, rotY0.s1, rotY0.s2, rotY0.s3) +
          0.16666667f * (float4)(rotY0.s1, rotY0.s2, rotY0.s3, rotY1.s0) +
          0.083333336f * (float4)(rotY0.s2, rotY0.s3, rotY1.s0, rotY1.s1);

        x18388[((((i_18915 + ((2 + i_18877) % 3)) + (((3 * n1) * get_global_id(0)) / 4)) + (3 * get_global_id(0))) + ((n1 * ((2 + i_18877) % 3)) / 4))] = ix;
        x18389[((((i_18915 + ((2 + i_18877) % 3)) + (((3 * n1) * get_global_id(0)) / 4)) + (3 * get_global_id(0))) + ((n1 * ((2 + i_18877) % 3)) / 4))] = iy;

        rotX0 = rotX1;
        rotY0 = rotY1;
      }

      float4 ldX00 = x18388[((((0 + (i_18877 % 3)) + (((3 * n1) * get_global_id(0)) / 4)) + (3 * get_global_id(0))) + ((n1 * (i_18877 % 3)) / 4))];
      float4 ldX10 = x18388[((((0 + ((1 + i_18877) % 3)) + (((3 * n1) * get_global_id(0)) / 4)) + (3 * get_global_id(0))) + ((n1 * ((1 + i_18877) % 3)) / 4))];
      float4 ldX20 = x18388[((((0 + ((2 + i_18877) % 3)) + (((3 * n1) * get_global_id(0)) / 4)) + (3 * get_global_id(0))) + ((n1 * ((2 + i_18877) % 3)) / 4))];
      float4 ldY00 = x18389[((((0 + (i_18877 % 3)) + (((3 * n1) * get_global_id(0)) / 4)) + (3 * get_global_id(0))) + ((n1 * (i_18877 % 3)) / 4))];
      float4 ldY10 = x18389[((((0 + ((1 + i_18877) % 3)) + (((3 * n1) * get_global_id(0)) / 4)) + (3 * get_global_id(0))) + ((n1 * ((1 + i_18877) % 3)) / 4))];
      float4 ldY20 = x18389[((((0 + ((2 + i_18877) % 3)) + (((3 * n1) * get_global_id(0)) / 4)) + (3 * get_global_id(0))) + ((n1 * ((2 + i_18877) % 3)) / 4))];
      float4 rotSXX0 = ldX00*ldX00 + ldX10*ldX10 + ldX20*ldX20;
      float4 rotSXY0 = ldX00*ldY00 + ldX10*ldY10 + ldX20*ldY20;
      float4 rotSYY0 = ldY00*ldY00 + ldY10*ldY10 + ldY20*ldY20;
      /* mapSeq */
      for (int i_19200 = 0;(i_19200 < (n1 / 4));i_19200 = (1 + i_19200)) {
        float4 ldX01 = x18388[(((((1 + i_19200) + (i_18877 % 3)) + (((3 * n1) * get_global_id(0)) / 4)) + (3 * get_global_id(0))) + ((n1 * (i_18877 % 3)) / 4))];
        float4 ldX11 = x18388[(((((1 + i_19200) + ((1 + i_18877) % 3)) + (((3 * n1) * get_global_id(0)) / 4)) + (3 * get_global_id(0))) + ((n1 * ((1 + i_18877) % 3)) / 4))];
        float4 ldX21 = x18388[(((((1 + i_19200) + ((2 + i_18877) % 3)) + (((3 * n1) * get_global_id(0)) / 4)) + (3 * get_global_id(0))) + ((n1 * ((2 + i_18877) % 3)) / 4))];
        float4 ldY01 = x18389[(((((1 + i_19200) + (i_18877 % 3)) + (((3 * n1) * get_global_id(0)) / 4)) + (3 * get_global_id(0))) + ((n1 * (i_18877 % 3)) / 4))];
        float4 ldY11 = x18389[(((((1 + i_19200) + ((1 + i_18877) % 3)) + (((3 * n1) * get_global_id(0)) / 4)) + (3 * get_global_id(0))) + ((n1 * ((1 + i_18877) % 3)) / 4))];
        float4 ldY21 = x18389[(((((1 + i_19200) + ((2 + i_18877) % 3)) + (((3 * n1) * get_global_id(0)) / 4)) + (3 * get_global_id(0))) + ((n1 * ((2 + i_18877) % 3)) / 4))];
        float4 rotSXX1 = ldX01*ldX01 + ldX11*ldX11 + ldX21*ldX21;
        float4 rotSXY1 = ldX01*ldY01 + ldX11*ldY11 + ldX21*ldY21;
        float4 rotSYY1 = ldY01*ldY01 + ldY11*ldY11 + ldY21*ldY21;

        float4 sxx =
            (float4)(rotSXX0.s0, rotSXX0.s1, rotSXX0.s2, rotSXX0.s3) +
            (float4)(rotSXX0.s1, rotSXX0.s2, rotSXX0.s3, rotSXX1.s0) +
            (float4)(rotSXX0.s2, rotSXX0.s3, rotSXX1.s0, rotSXX1.s1);
        float4 sxy =
            (float4)(rotSXY0.s0, rotSXY0.s1, rotSXY0.s2, rotSXY0.s3) +
            (float4)(rotSXY0.s1, rotSXY0.s2, rotSXY0.s3, rotSXY1.s0) +
            (float4)(rotSXY0.s2, rotSXY0.s3, rotSXY1.s0, rotSXY1.s1);
        float4 syy =
            (float4)(rotSYY0.s0, rotSYY0.s1, rotSYY0.s2, rotSYY0.s3) +
            (float4)(rotSYY0.s1, rotSYY0.s2, rotSYY0.s3, rotSYY1.s0) +
            (float4)(rotSYY0.s2, rotSYY0.s3, rotSYY1.s0, rotSYY1.s1);

        vstore4((((sxx * syy) - (sxy * sxy)) - (((float4)(0.04f) * (sxx + syy)) * (sxx + syy))), 0, (&(output[(((4 * i_19200) + ((32 * gl_id_18515) * n1)) + (i_18877 * n1))])));

        rotSXX0 = rotSXX1;
        rotSXY0 = rotSXY1;
        rotSYY0 = rotSYY1;
      }
      
    }
    
  }
  
}
