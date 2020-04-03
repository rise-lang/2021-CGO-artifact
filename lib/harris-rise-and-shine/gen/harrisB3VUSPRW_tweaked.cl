

__kernel
void harris(global float* restrict output, int n0, int n1, const global float* restrict x0, global float* restrict cb3, global float* restrict cb2, global float* restrict cb1){
  /* Start of moved local vars */
  /* End of moved local vars */
  /* mapGlobal */
  for (int gl_y = get_global_id(0);(gl_y < (n0 / 32));gl_y = (gl_y + get_global_size(0))) {
    for (int y = 0;(y < 2);y = (1 + y)) {
      /* mapSeq */
      for (int x = 0;(x < (n1 / 4));x = (1 + x)) {
        /* oclReduceSeq */
        {
          float4 accG;
          accG = (float4)(0.0f);
          /* unrolling loop of 3 */
          accG = (accG + ((float4)(0.299f) * vload4(0, (&(x0[(((4 * x) + ((32 * gl_y) * n1)) + (y * n1))])))));
          accG = (accG + ((float4)(0.587f) * vload4(0, (&(x0[(((((4 * x) + (4 * n1)) + ((32 * gl_y) * n1)) + (y * n1)) + (n0 * n1))])))));
          accG = (accG + ((float4)(0.114f) * vload4(0, (&(x0[((((((2 * n0) * n1) + (4 * x)) + (8 * n1)) + ((32 * gl_y) * n1)) + (y * n1))])))));
          vstore4(accG, 0, (&(cb1[(((((2 * y) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (y * n1))])));
        }
        
      }
      
    }
    
    for (int y = 0;(y < 2);y = (1 + y)) {
      /* mapSeq */
      for (int x = 0;(x < (n1 / 4));x = (1 + x)) {
        /* oclReduceSeq */
        {
          float4 accG;
          accG = (float4)(0.0f);
          /* unrolling loop of 3 */
          accG = (accG + ((float4)(0.299f) * vload4(0, (&(x0[((((2 * n1) + (4 * x)) + ((32 * gl_y) * n1)) + (y * n1))])))));
          accG = (accG + ((float4)(0.587f) * vload4(0, (&(x0[(((((4 * x) + (6 * n1)) + ((32 * gl_y) * n1)) + (y * n1)) + (n0 * n1))])))));
          accG = (accG + ((float4)(0.114f) * vload4(0, (&(x0[((((((2 * n0) * n1) + (4 * x)) + (10 * n1)) + ((32 * gl_y) * n1)) + (y * n1))])))));
          vstore4(accG, 0, (&(cb1[(((((2 * ((2 + y) % 3)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))])));
        }
        
      }
      
      /* mapSeq */
      for (int x = 0;(x < (n1 / 4));x = (1 + x)) {
        /* oclReduceSeq */
        {
          float4 accIx;
          accIx = (float4)(0.0f);
          /* unrolling loop of 9 */
          accIx = (accIx + ((float4)(((float[3]){-0.083333336f, 0.0f, 0.083333336f})[0]) * (float4)(cb1[(((((2 * y) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (y * n1))], cb1[(((((1 + (2 * y)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (y * n1))], cb1[(((((2 + (2 * y)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (y * n1))], cb1[(((((3 + (2 * y)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (y * n1))])));
          accIx = (accIx + ((float4)(((float[3]){-0.083333336f, 0.0f, 0.083333336f})[1]) * (float4)(cb1[(((((1 + (2 * y)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (y * n1))], cb1[(((((2 + (2 * y)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (y * n1))], cb1[(((((3 + (2 * y)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (y * n1))], cb1[(((((4 + (2 * y)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (y * n1))])));
          accIx = (accIx + ((float4)(((float[3]){-0.083333336f, 0.0f, 0.083333336f})[2]) * (float4)(cb1[(((((2 + (2 * y)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (y * n1))], cb1[(((((3 + (2 * y)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (y * n1))], cb1[(((((4 + (2 * y)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (y * n1))], cb1[(((((5 + (2 * y)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (y * n1))])));
          accIx = (accIx + ((float4)(((float[3]){-0.16666667f, 0.0f, 0.16666667f})[0]) * (float4)(cb1[((((((2 + n1) + (2 * y)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (y * n1))], cb1[((((((3 + n1) + (2 * y)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (y * n1))], cb1[((((((4 + n1) + (2 * y)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (y * n1))], cb1[((((((5 + n1) + (2 * y)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (y * n1))])));
          accIx = (accIx + ((float4)(((float[3]){-0.16666667f, 0.0f, 0.16666667f})[1]) * (float4)(cb1[((((((3 + n1) + (2 * y)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (y * n1))], cb1[((((((4 + n1) + (2 * y)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (y * n1))], cb1[((((((5 + n1) + (2 * y)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (y * n1))], cb1[((((((6 + n1) + (2 * y)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (y * n1))])));
          accIx = (accIx + ((float4)(((float[3]){-0.16666667f, 0.0f, 0.16666667f})[2]) * (float4)(cb1[((((((4 + n1) + (2 * y)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (y * n1))], cb1[((((((5 + n1) + (2 * y)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (y * n1))], cb1[((((((6 + n1) + (2 * y)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (y * n1))], cb1[((((((7 + n1) + (2 * y)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (y * n1))])));
          accIx = (accIx + ((float4)(((float[3]){-0.083333336f, 0.0f, 0.083333336f})[0]) * (float4)(cb1[(((((2 * ((2 + y) % 3)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))], cb1[(((((1 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))], cb1[(((((2 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))], cb1[(((((3 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))])));
          accIx = (accIx + ((float4)(((float[3]){-0.083333336f, 0.0f, 0.083333336f})[1]) * (float4)(cb1[(((((1 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))], cb1[(((((2 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))], cb1[(((((3 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))], cb1[(((((4 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))])));
          accIx = (accIx + ((float4)(((float[3]){-0.083333336f, 0.0f, 0.083333336f})[2]) * (float4)(cb1[(((((2 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))], cb1[(((((3 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))], cb1[(((((4 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))], cb1[(((((5 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))])));
          vstore4(accIx, 0, (&(cb2[(((((2 * y) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (y * n1))])));
        }
        
        /* oclReduceSeq */
        {
          float4 accIy;
          accIy = (float4)(0.0f);
          /* unrolling loop of 9 */
          accIy = (accIy + ((float4)(((float[3]){-0.083333336f, -0.16666667f, -0.083333336f})[0]) * (float4)(cb1[(((((2 * y) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (y * n1))], cb1[(((((1 + (2 * y)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (y * n1))], cb1[(((((2 + (2 * y)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (y * n1))], cb1[(((((3 + (2 * y)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (y * n1))])));
          accIy = (accIy + ((float4)(((float[3]){-0.083333336f, -0.16666667f, -0.083333336f})[1]) * (float4)(cb1[(((((1 + (2 * y)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (y * n1))], cb1[(((((2 + (2 * y)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (y * n1))], cb1[(((((3 + (2 * y)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (y * n1))], cb1[(((((4 + (2 * y)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (y * n1))])));
          accIy = (accIy + ((float4)(((float[3]){-0.083333336f, -0.16666667f, -0.083333336f})[2]) * (float4)(cb1[(((((2 + (2 * y)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (y * n1))], cb1[(((((3 + (2 * y)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (y * n1))], cb1[(((((4 + (2 * y)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (y * n1))], cb1[(((((5 + (2 * y)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (y * n1))])));
          accIy = (accIy + ((float4)(((float[3]){0.0f, 0.0f, 0.0f})[0]) * (float4)(cb1[((((((2 + n1) + (2 * y)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (y * n1))], cb1[((((((3 + n1) + (2 * y)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (y * n1))], cb1[((((((4 + n1) + (2 * y)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (y * n1))], cb1[((((((5 + n1) + (2 * y)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (y * n1))])));
          accIy = (accIy + ((float4)(((float[3]){0.0f, 0.0f, 0.0f})[1]) * (float4)(cb1[((((((3 + n1) + (2 * y)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (y * n1))], cb1[((((((4 + n1) + (2 * y)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (y * n1))], cb1[((((((5 + n1) + (2 * y)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (y * n1))], cb1[((((((6 + n1) + (2 * y)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (y * n1))])));
          accIy = (accIy + ((float4)(((float[3]){0.0f, 0.0f, 0.0f})[2]) * (float4)(cb1[((((((4 + n1) + (2 * y)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (y * n1))], cb1[((((((5 + n1) + (2 * y)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (y * n1))], cb1[((((((6 + n1) + (2 * y)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (y * n1))], cb1[((((((7 + n1) + (2 * y)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (y * n1))])));
          accIy = (accIy + ((float4)(((float[3]){0.083333336f, 0.16666667f, 0.083333336f})[0]) * (float4)(cb1[(((((2 * ((2 + y) % 3)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))], cb1[(((((1 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))], cb1[(((((2 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))], cb1[(((((3 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))])));
          accIy = (accIy + ((float4)(((float[3]){0.083333336f, 0.16666667f, 0.083333336f})[1]) * (float4)(cb1[(((((1 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))], cb1[(((((2 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))], cb1[(((((3 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))], cb1[(((((4 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))])));
          accIy = (accIy + ((float4)(((float[3]){0.083333336f, 0.16666667f, 0.083333336f})[2]) * (float4)(cb1[(((((2 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))], cb1[(((((3 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))], cb1[(((((4 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))], cb1[(((((5 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))])));
          vstore4(accIy, 0, (&(cb3[(((((2 * y) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (y * n1))])));
        }
        
      }
      
    }
    
    /* iterateStream */
    for (int y = 0;(y < 32);y = (1 + y)) {
      /* mapSeq */
      for (int x = 0;(x < (n1 / 4));x = (1 + x)) {
        /* oclReduceSeq */
        {
          float4 accG;
          accG = (float4)(0.0f);
          /* unrolling loop of 3 */
          accG = (accG + ((float4)(0.299f) * vload4(0, (&(x0[((((4 * x) + (4 * n1)) + ((32 * gl_y) * n1)) + (y * n1))])))));
          accG = (accG + ((float4)(0.587f) * vload4(0, (&(x0[(((((4 * x) + (8 * n1)) + ((32 * gl_y) * n1)) + (y * n1)) + (n0 * n1))])))));
          accG = (accG + ((float4)(0.114f) * vload4(0, (&(x0[((((((2 * n0) * n1) + (4 * x)) + (12 * n1)) + ((32 * gl_y) * n1)) + (y * n1))])))));
          vstore4(accG, 0, (&(cb1[(((((2 * ((1 + y) % 3)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((1 + y) % 3)))])));
        }
        
      }
      
      /* mapSeq */
      for (int x = 0;(x < (n1 / 4));x = (1 + x)) {
        /* oclReduceSeq */
        {
          float4 accIx;
          accIx = (float4)(0.0f);
          /* unrolling loop of 9 */
          accIx = (accIx + ((float4)(((float[3]){-0.083333336f, 0.0f, 0.083333336f})[0]) * (float4)(cb1[(((((2 * ((2 + y) % 3)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))], cb1[(((((1 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))], cb1[(((((2 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))], cb1[(((((3 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))])));
          accIx = (accIx + ((float4)(((float[3]){-0.083333336f, 0.0f, 0.083333336f})[1]) * (float4)(cb1[(((((1 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))], cb1[(((((2 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))], cb1[(((((3 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))], cb1[(((((4 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))])));
          accIx = (accIx + ((float4)(((float[3]){-0.083333336f, 0.0f, 0.083333336f})[2]) * (float4)(cb1[(((((2 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))], cb1[(((((3 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))], cb1[(((((4 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))], cb1[(((((5 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))])));
          accIx = (accIx + ((float4)(((float[3]){-0.16666667f, 0.0f, 0.16666667f})[0]) * (float4)(cb1[(((((2 * (y % 3)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * (y % 3)))], cb1[(((((1 + (2 * (y % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * (y % 3)))], cb1[(((((2 + (2 * (y % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * (y % 3)))], cb1[(((((3 + (2 * (y % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * (y % 3)))])));
          accIx = (accIx + ((float4)(((float[3]){-0.16666667f, 0.0f, 0.16666667f})[1]) * (float4)(cb1[(((((1 + (2 * (y % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * (y % 3)))], cb1[(((((2 + (2 * (y % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * (y % 3)))], cb1[(((((3 + (2 * (y % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * (y % 3)))], cb1[(((((4 + (2 * (y % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * (y % 3)))])));
          accIx = (accIx + ((float4)(((float[3]){-0.16666667f, 0.0f, 0.16666667f})[2]) * (float4)(cb1[(((((2 + (2 * (y % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * (y % 3)))], cb1[(((((3 + (2 * (y % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * (y % 3)))], cb1[(((((4 + (2 * (y % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * (y % 3)))], cb1[(((((5 + (2 * (y % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * (y % 3)))])));
          accIx = (accIx + ((float4)(((float[3]){-0.083333336f, 0.0f, 0.083333336f})[0]) * (float4)(cb1[(((((2 * ((1 + y) % 3)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((1 + y) % 3)))], cb1[(((((1 + (2 * ((1 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((1 + y) % 3)))], cb1[(((((2 + (2 * ((1 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((1 + y) % 3)))], cb1[(((((3 + (2 * ((1 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((1 + y) % 3)))])));
          accIx = (accIx + ((float4)(((float[3]){-0.083333336f, 0.0f, 0.083333336f})[1]) * (float4)(cb1[(((((1 + (2 * ((1 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((1 + y) % 3)))], cb1[(((((2 + (2 * ((1 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((1 + y) % 3)))], cb1[(((((3 + (2 * ((1 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((1 + y) % 3)))], cb1[(((((4 + (2 * ((1 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((1 + y) % 3)))])));
          accIx = (accIx + ((float4)(((float[3]){-0.083333336f, 0.0f, 0.083333336f})[2]) * (float4)(cb1[(((((2 + (2 * ((1 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((1 + y) % 3)))], cb1[(((((3 + (2 * ((1 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((1 + y) % 3)))], cb1[(((((4 + (2 * ((1 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((1 + y) % 3)))], cb1[(((((5 + (2 * ((1 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((1 + y) % 3)))])));
          vstore4(accIx, 0, (&(cb2[(((((2 * ((2 + y) % 3)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))])));
        }
        
        /* oclReduceSeq */
        {
          float4 accIy;
          accIy = (float4)(0.0f);
          /* unrolling loop of 9 */
          accIy = (accIy + ((float4)(((float[3]){-0.083333336f, -0.16666667f, -0.083333336f})[0]) * (float4)(cb1[(((((2 * ((2 + y) % 3)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))], cb1[(((((1 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))], cb1[(((((2 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))], cb1[(((((3 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))])));
          accIy = (accIy + ((float4)(((float[3]){-0.083333336f, -0.16666667f, -0.083333336f})[1]) * (float4)(cb1[(((((1 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))], cb1[(((((2 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))], cb1[(((((3 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))], cb1[(((((4 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))])));
          accIy = (accIy + ((float4)(((float[3]){-0.083333336f, -0.16666667f, -0.083333336f})[2]) * (float4)(cb1[(((((2 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))], cb1[(((((3 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))], cb1[(((((4 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))], cb1[(((((5 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))])));
          accIy = (accIy + ((float4)(((float[3]){0.0f, 0.0f, 0.0f})[0]) * (float4)(cb1[(((((2 * (y % 3)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * (y % 3)))], cb1[(((((1 + (2 * (y % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * (y % 3)))], cb1[(((((2 + (2 * (y % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * (y % 3)))], cb1[(((((3 + (2 * (y % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * (y % 3)))])));
          accIy = (accIy + ((float4)(((float[3]){0.0f, 0.0f, 0.0f})[1]) * (float4)(cb1[(((((1 + (2 * (y % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * (y % 3)))], cb1[(((((2 + (2 * (y % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * (y % 3)))], cb1[(((((3 + (2 * (y % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * (y % 3)))], cb1[(((((4 + (2 * (y % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * (y % 3)))])));
          accIy = (accIy + ((float4)(((float[3]){0.0f, 0.0f, 0.0f})[2]) * (float4)(cb1[(((((2 + (2 * (y % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * (y % 3)))], cb1[(((((3 + (2 * (y % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * (y % 3)))], cb1[(((((4 + (2 * (y % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * (y % 3)))], cb1[(((((5 + (2 * (y % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * (y % 3)))])));
          accIy = (accIy + ((float4)(((float[3]){0.083333336f, 0.16666667f, 0.083333336f})[0]) * (float4)(cb1[(((((2 * ((1 + y) % 3)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((1 + y) % 3)))], cb1[(((((1 + (2 * ((1 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((1 + y) % 3)))], cb1[(((((2 + (2 * ((1 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((1 + y) % 3)))], cb1[(((((3 + (2 * ((1 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((1 + y) % 3)))])));
          accIy = (accIy + ((float4)(((float[3]){0.083333336f, 0.16666667f, 0.083333336f})[1]) * (float4)(cb1[(((((1 + (2 * ((1 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((1 + y) % 3)))], cb1[(((((2 + (2 * ((1 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((1 + y) % 3)))], cb1[(((((3 + (2 * ((1 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((1 + y) % 3)))], cb1[(((((4 + (2 * ((1 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((1 + y) % 3)))])));
          accIy = (accIy + ((float4)(((float[3]){0.083333336f, 0.16666667f, 0.083333336f})[2]) * (float4)(cb1[(((((2 + (2 * ((1 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((1 + y) % 3)))], cb1[(((((3 + (2 * ((1 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((1 + y) % 3)))], cb1[(((((4 + (2 * ((1 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((1 + y) % 3)))], cb1[(((((5 + (2 * ((1 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((1 + y) % 3)))])));
          vstore4(accIy, 0, (&(cb3[(((((2 * ((2 + y) % 3)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))])));
        }
        
      }
      
      /* mapSeq */
      for (int x = 0;(x < (n1 / 4));x = (1 + x)) {
        float4 cb2_11 = (float4)(
          cb2[(((((2 * (y % 3)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * (y % 3)))],
          cb2[(((((1 + (2 * (y % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * (y % 3)))],
          cb2[(((((2 + (2 * (y % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * (y % 3)))],
          cb2[(((((3 + (2 * (y % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * (y % 3)))]
        );
        float4 cb2_12 = (float4)(
          cb2[(((((1 + (2 * (y % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * (y % 3)))],
          cb2[(((((2 + (2 * (y % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * (y % 3)))],
          cb2[(((((3 + (2 * (y % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * (y % 3)))],
          cb2[(((((4 + (2 * (y % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * (y % 3)))]
        );
        float4 cb2_13 = (float4)(
          cb2[(((((2 + (2 * (y % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * (y % 3)))],
          cb2[(((((3 + (2 * (y % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * (y % 3)))],
          cb2[(((((4 + (2 * (y % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * (y % 3)))],
          cb2[(((((5 + (2 * (y % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * (y % 3)))]
        );
        float4 cb2_21 = (float4)(
          cb2[(((((2 * ((1 + y) % 3)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((1 + y) % 3)))],
          cb2[(((((1 + (2 * ((1 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((1 + y) % 3)))],
          cb2[(((((2 + (2 * ((1 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((1 + y) % 3)))],
          cb2[(((((3 + (2 * ((1 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((1 + y) % 3)))]
        );
        float4 cb2_22 = (float4)(
          cb2[(((((1 + (2 * ((1 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((1 + y) % 3)))],
          cb2[(((((2 + (2 * ((1 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((1 + y) % 3)))],
          cb2[(((((3 + (2 * ((1 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((1 + y) % 3)))],
          cb2[(((((4 + (2 * ((1 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((1 + y) % 3)))]
        );
        float4 cb2_23 = (float4)(
          cb2[(((((2 + (2 * ((1 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((1 + y) % 3)))],
          cb2[(((((3 + (2 * ((1 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((1 + y) % 3)))],
          cb2[(((((4 + (2 * ((1 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((1 + y) % 3)))],
          cb2[(((((5 + (2 * ((1 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((1 + y) % 3)))]
        );
        float4 cb2_31 = (float4)(
          cb2[(((((2 * ((2 + y) % 3)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))],
          cb2[(((((1 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))],
          cb2[(((((2 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))],
          cb2[(((((3 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))]
        );
        float4 cb2_32 = (float4)(
          cb2[(((((1 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))],
          cb2[(((((2 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))],
          cb2[(((((3 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))],
          cb2[(((((4 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))]
        );
        float4 cb2_33 = (float4)(
          cb2[(((((2 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))],
          cb2[(((((3 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))],
          cb2[(((((4 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))],
          cb2[(((((5 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))]
        );

        float4 cb3_11 = (float4)(
          cb3[(((((2 * (y % 3)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * (y % 3)))],
          cb3[(((((1 + (2 * (y % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * (y % 3)))],
          cb3[(((((2 + (2 * (y % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * (y % 3)))],
          cb3[(((((3 + (2 * (y % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * (y % 3)))]
        );
        float4 cb3_12 = (float4)(
          cb3[(((((1 + (2 * (y % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * (y % 3)))],
          cb3[(((((2 + (2 * (y % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * (y % 3)))],
          cb3[(((((3 + (2 * (y % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * (y % 3)))],
          cb3[(((((4 + (2 * (y % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * (y % 3)))]
        );
        float4 cb3_13 = (float4)(
          cb3[(((((2 + (2 * (y % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * (y % 3)))],
          cb3[(((((3 + (2 * (y % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * (y % 3)))],
          cb3[(((((4 + (2 * (y % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * (y % 3)))],
          cb3[(((((5 + (2 * (y % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * (y % 3)))]
        );
        float4 cb3_21 = (float4)(
          cb3[(((((2 * ((1 + y) % 3)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((1 + y) % 3)))],
          cb3[(((((1 + (2 * ((1 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((1 + y) % 3)))],
          cb3[(((((2 + (2 * ((1 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((1 + y) % 3)))],
          cb3[(((((3 + (2 * ((1 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((1 + y) % 3)))]
        );
        float4 cb3_22 = (float4)(
          cb3[(((((1 + (2 * ((1 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((1 + y) % 3)))],
          cb3[(((((2 + (2 * ((1 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((1 + y) % 3)))],
          cb3[(((((3 + (2 * ((1 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((1 + y) % 3)))],
          cb3[(((((4 + (2 * ((1 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((1 + y) % 3)))]
        );
        float4 cb3_23 = (float4)(
          cb3[(((((2 + (2 * ((1 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((1 + y) % 3)))],
          cb3[(((((3 + (2 * ((1 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((1 + y) % 3)))],
          cb3[(((((4 + (2 * ((1 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((1 + y) % 3)))],
          cb3[(((((5 + (2 * ((1 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((1 + y) % 3)))]
        );
        float4 cb3_31 = (float4)(
          cb3[(((((2 * ((2 + y) % 3)) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))],
          cb3[(((((1 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))],
          cb3[(((((2 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))],
          cb3[(((((3 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))]
        );
        float4 cb3_32 = (float4)(
          cb3[(((((1 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))],
          cb3[(((((2 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))],
          cb3[(((((3 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))],
          cb3[(((((4 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))]
        );
        float4 cb3_33 = (float4)(
          cb3[(((((2 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))],
          cb3[(((((3 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))],
          cb3[(((((4 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))],
          cb3[(((((5 + (2 * ((2 + y) % 3))) + ((3 * n1) * get_global_id(0))) + (4 * x)) + (6 * get_global_id(0))) + (n1 * ((2 + y) % 3)))]
        );

        float4 v1;
        /* oclReduceSeq */
        {
          float4 x16554;
          x16554 = (float4)(0.0f);
          /* unrolling loop of 9 */
          x16554 = (x16554 + (cb2_11 * cb2_11));
          x16554 = (x16554 + (cb2_12 * cb2_12));
          x16554 = (x16554 + (cb2_13 * cb2_13));
          x16554 = (x16554 + (cb2_21 * cb2_21));
          x16554 = (x16554 + (cb2_22 * cb2_22));
          x16554 = (x16554 + (cb2_23 * cb2_23));
          x16554 = (x16554 + (cb2_31 * cb2_31));
          x16554 = (x16554 + (cb2_32 * cb2_32));
          x16554 = (x16554 + (cb2_33 * cb2_33));
          v1 = x16554;
        }

        float4 v3;
        /* oclReduceSeq */
        {
          float4 x16554;
          x16554 = (float4)(0.0f);
          /* unrolling loop of 9 */
          x16554 = (x16554 + (cb2_11 * cb3_11));
          x16554 = (x16554 + (cb2_12 * cb3_12));
          x16554 = (x16554 + (cb2_13 * cb3_13));
          x16554 = (x16554 + (cb2_21 * cb3_21));
          x16554 = (x16554 + (cb2_22 * cb3_22));
          x16554 = (x16554 + (cb2_23 * cb3_23));
          x16554 = (x16554 + (cb2_31 * cb3_31));
          x16554 = (x16554 + (cb2_32 * cb3_32));
          x16554 = (x16554 + (cb2_33 * cb3_33));
          v3 = x16554;
        }

        float4 v2;
        /* oclReduceSeq */
        {
          float4 x16554;
          x16554 = (float4)(0.0f);
          /* unrolling loop of 9 */
          x16554 = (x16554 + (cb3_11 * cb3_11));
          x16554 = (x16554 + (cb3_12 * cb3_12));
          x16554 = (x16554 + (cb3_13 * cb3_13));
          x16554 = (x16554 + (cb3_21 * cb3_21));
          x16554 = (x16554 + (cb3_22 * cb3_22));
          x16554 = (x16554 + (cb3_23 * cb3_23));
          x16554 = (x16554 + (cb3_31 * cb3_31));
          x16554 = (x16554 + (cb3_32 * cb3_32));
          x16554 = (x16554 + (cb3_33 * cb3_33));
          v2 = x16554;
        }
              
        vstore4((((v1 * v2) - (v3 * v3)) - (((float4)(0.04f) * (v1 + v2)) * (v1 + v2))), 0, (&(output[(((4 * x) + ((32 * gl_y) * n1)) + (y * n1))])));
      }
      
    }
    
  }
  
}
