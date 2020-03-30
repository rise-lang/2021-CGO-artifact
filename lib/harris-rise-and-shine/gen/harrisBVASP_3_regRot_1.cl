

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
      
      /* mapSeq */
      for (int i_19200 = 0;(i_19200 < (n1 / 4));i_19200 = (1 + i_19200)) {
        {
          float4 tmp1 = x18388[((((i_19200 + (i_18877 % 3)) + (((3 * n1) * get_global_id(0)) / 4)) + (3 * get_global_id(0))) + ((n1 * (i_18877 % 3)) / 4))];
          float4 tmp2 = x18388[(((((1 + i_19200) + (i_18877 % 3)) + (((3 * n1) * get_global_id(0)) / 4)) + (3 * get_global_id(0))) + ((n1 * (i_18877 % 3)) / 4))];
          float4 tmp3 = x18388[((((i_19200 + ((1 + i_18877) % 3)) + (((3 * n1) * get_global_id(0)) / 4)) + (3 * get_global_id(0))) + ((n1 * ((1 + i_18877) % 3)) / 4))];
          float4 tmp4 = x18388[(((((1 + i_19200) + ((1 + i_18877) % 3)) + (((3 * n1) * get_global_id(0)) / 4)) + (3 * get_global_id(0))) + ((n1 * ((1 + i_18877) % 3)) / 4))];
          float4 tmp5 = x18388[((((i_19200 + ((2 + i_18877) % 3)) + (((3 * n1) * get_global_id(0)) / 4)) + (3 * get_global_id(0))) + ((n1 * ((2 + i_18877) % 3)) / 4))];
          float4 tmp6 = x18388[(((((1 + i_19200) + ((2 + i_18877) % 3)) + (((3 * n1) * get_global_id(0)) / 4)) + (3 * get_global_id(0))) + ((n1 * ((2 + i_18877) % 3)) / 4))];

          float4 tmp7 = x18389[((((i_19200 + (i_18877 % 3)) + (((3 * n1) * get_global_id(0)) / 4)) + (3 * get_global_id(0))) + ((n1 * (i_18877 % 3)) / 4))];
          float4 tmp8 = x18389[(((((1 + i_19200) + (i_18877 % 3)) + (((3 * n1) * get_global_id(0)) / 4)) + (3 * get_global_id(0))) + ((n1 * (i_18877 % 3)) / 4))];
          float4 tmp9 = x18389[((((i_19200 + ((1 + i_18877) % 3)) + (((3 * n1) * get_global_id(0)) / 4)) + (3 * get_global_id(0))) + ((n1 * ((1 + i_18877) % 3)) / 4))];
          float4 tmp10 = x18389[(((((1 + i_19200) + ((1 + i_18877) % 3)) + (((3 * n1) * get_global_id(0)) / 4)) + (3 * get_global_id(0))) + ((n1 * ((1 + i_18877) % 3)) / 4))];
          float4 tmp11 = x18389[((((i_19200 + ((2 + i_18877) % 3)) + (((3 * n1) * get_global_id(0)) / 4)) + (3 * get_global_id(0))) + ((n1 * ((2 + i_18877) % 3)) / 4))];
          float4 tmp12 = x18389[(((((1 + i_19200) + ((2 + i_18877) % 3)) + (((3 * n1) * get_global_id(0)) / 4)) + (3 * get_global_id(0))) + ((n1 * ((2 + i_18877) % 3)) / 4))];

          float4 x18206;
          /* oclReduceSeq */
          {
            float4 x18214;
            x18214 = (float4)(0.0f);
            /* unrolling loop of 9 */
            x18214 = (x18214 + (float4)(tmp1.s0, tmp1.s1, tmp1.s2, tmp1.s3) * (float4)(tmp1.s0, tmp1.s1, tmp1.s2, tmp1.s3));
            x18214 = (x18214 + (float4)(tmp1.s1, tmp1.s2, tmp1.s3, tmp2.s0) * (float4)(tmp1.s1, tmp1.s2, tmp1.s3, tmp2.s0));
            x18214 = (x18214 + (float4)(tmp1.s2, tmp1.s3, tmp2.s0, tmp2.s1) * (float4)(tmp1.s2, tmp1.s3, tmp2.s0, tmp2.s1));
            x18214 = (x18214 + (float4)(tmp3.s0, tmp3.s1, tmp3.s2, tmp3.s3) * (float4)(tmp3.s0, tmp3.s1, tmp3.s2, tmp3.s3));
            x18214 = (x18214 + (float4)(tmp3.s1, tmp3.s2, tmp3.s3, tmp4.s0) * (float4)(tmp3.s1, tmp3.s2, tmp3.s3, tmp4.s0));
            x18214 = (x18214 + (float4)(tmp3.s2, tmp3.s3, tmp4.s0, tmp4.s1) * (float4)(tmp3.s2, tmp3.s3, tmp4.s0, tmp4.s1));
            x18214 = (x18214 + (float4)(tmp5.s0, tmp5.s1, tmp5.s2, tmp5.s3) * (float4)(tmp5.s0, tmp5.s1, tmp5.s2, tmp5.s3));
            x18214 = (x18214 + (float4)(tmp5.s1, tmp5.s2, tmp5.s3, tmp6.s0) * (float4)(tmp5.s1, tmp5.s2, tmp5.s3, tmp6.s0));
            x18214 = (x18214 + (float4)(tmp5.s2, tmp5.s3, tmp6.s0, tmp6.s1) * (float4)(tmp5.s2, tmp5.s3, tmp6.s0, tmp6.s1));
            x18206 = x18214;
          }
          
          {
            float4 x18173;
            /* oclReduceSeq */
            {
              float4 x18181;
              x18181 = (float4)(0.0f);
              /* unrolling loop of 9 */
              x18181 = (x18181 + (float4)(tmp1.s0, tmp1.s1, tmp1.s2, tmp1.s3) * (float4)(tmp7.s0, tmp7.s1, tmp7.s2, tmp7.s3));
              x18181 = (x18181 + (float4)(tmp1.s1, tmp1.s2, tmp1.s3, tmp2.s0) * (float4)(tmp7.s1, tmp7.s2, tmp7.s3, tmp8.s0));
              x18181 = (x18181 + (float4)(tmp1.s2, tmp1.s3, tmp2.s0, tmp2.s1) * (float4)(tmp7.s2, tmp7.s3, tmp8.s0, tmp8.s1));
              x18181 = (x18181 + (float4)(tmp3.s0, tmp3.s1, tmp3.s2, tmp3.s3) * (float4)(tmp9.s0, tmp9.s1, tmp9.s2, tmp9.s3));
              x18181 = (x18181 + (float4)(tmp3.s1, tmp3.s2, tmp3.s3, tmp4.s0) * (float4)(tmp9.s1, tmp9.s2, tmp9.s3, tmp10.s0));
              x18181 = (x18181 + (float4)(tmp3.s2, tmp3.s3, tmp4.s0, tmp4.s1) * (float4)(tmp9.s2, tmp9.s3, tmp10.s0, tmp10.s1));
              x18181 = (x18181 + (float4)(tmp5.s0, tmp5.s1, tmp5.s2, tmp5.s3) * (float4)(tmp11.s0, tmp11.s1, tmp11.s2, tmp11.s3));
              x18181 = (x18181 + (float4)(tmp5.s1, tmp5.s2, tmp5.s3, tmp6.s0) * (float4)(tmp11.s1, tmp11.s2, tmp11.s3, tmp12.s0));
              x18181 = (x18181 + (float4)(tmp5.s2, tmp5.s3, tmp6.s0, tmp6.s1) * (float4)(tmp11.s2, tmp11.s3, tmp12.s0, tmp12.s1));
              x18173 = x18181;
            }
            
            {
              float4 x18140;
              /* oclReduceSeq */
              {
                float4 x18148;
                x18148 = (float4)(0.0f);
                /* unrolling loop of 9 */
                x18148 = (x18148 + (float4)(tmp7.s0, tmp7.s1, tmp7.s2, tmp7.s3) * (float4)(tmp7.s0, tmp7.s1, tmp7.s2, tmp7.s3));
                x18148 = (x18148 + (float4)(tmp7.s1, tmp7.s2, tmp7.s3, tmp8.s0) * (float4)(tmp7.s1, tmp7.s2, tmp7.s3, tmp8.s0));
                x18148 = (x18148 + (float4)(tmp7.s2, tmp7.s3, tmp8.s0, tmp8.s1) * (float4)(tmp7.s2, tmp7.s3, tmp8.s0, tmp8.s1));
                x18148 = (x18148 + (float4)(tmp9.s0, tmp9.s1, tmp9.s2, tmp9.s3) * (float4)(tmp9.s0, tmp9.s1, tmp9.s2, tmp9.s3));
                x18148 = (x18148 + (float4)(tmp9.s1, tmp9.s2, tmp9.s3, tmp10.s0) * (float4)(tmp9.s1, tmp9.s2, tmp9.s3, tmp10.s0));
                x18148 = (x18148 + (float4)(tmp9.s2, tmp9.s3, tmp10.s0, tmp10.s1) * (float4)(tmp9.s2, tmp9.s3, tmp10.s0, tmp10.s1));
                x18148 = (x18148 + (float4)(tmp11.s0, tmp11.s1, tmp11.s2, tmp11.s3) * (float4)(tmp11.s0, tmp11.s1, tmp11.s2, tmp11.s3));
                x18148 = (x18148 + (float4)(tmp11.s1, tmp11.s2, tmp11.s3, tmp12.s0) * (float4)(tmp11.s1, tmp11.s2, tmp11.s3, tmp12.s0));
                x18148 = (x18148 + (float4)(tmp11.s2, tmp11.s3, tmp12.s0, tmp12.s1) * (float4)(tmp11.s2, tmp11.s3, tmp12.s0, tmp12.s1));
                x18140 = x18148;
              }
              
              vstore4((((x18206 * x18140) - (x18173 * x18173)) - (((float4)(0.04f) * (x18206 + x18140)) * (x18206 + x18140))), 0, (&(output[(((4 * i_19200) + ((32 * gl_id_18515) * n1)) + (i_18877 * n1))])));
            }
            
          }
          
        }
        
      }
      
    }
    
  }
  
}
