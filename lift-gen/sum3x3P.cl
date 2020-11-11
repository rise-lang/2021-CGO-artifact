

__kernel
void sum3x3(global float* restrict output, int n0, int n1, const global float* restrict x0){
  /* Start of moved local vars */
  /* End of moved local vars */
  /* mapGlobal */
  for (int gl_id_47460 = get_global_id(0);(gl_id_47460 < n0);gl_id_47460 = (gl_id_47460 + get_global_size(0))) {
    /* mapSeq */
    for (int i_47461 = 0;(i_47461 < (-4 + n1));i_47461 = (1 + i_47461)) {
      /* oclReduceSeq */
      {
        float x47436;
        x47436 = 0.0f;
        /* unrolling loop of 9 */
        x47436 = (x47436 + x0[((i_47461 + (-2 * gl_id_47460)) + (gl_id_47460 * n1))]);
        x47436 = (x47436 + x0[(((1 + i_47461) + (-2 * gl_id_47460)) + (gl_id_47460 * n1))]);
        x47436 = (x47436 + x0[(((2 + i_47461) + (-2 * gl_id_47460)) + (gl_id_47460 * n1))]);
        x47436 = (x47436 + x0[((((-2 + i_47461) + n1) + (-2 * gl_id_47460)) + (gl_id_47460 * n1))]);
        x47436 = (x47436 + x0[((((-1 + i_47461) + n1) + (-2 * gl_id_47460)) + (gl_id_47460 * n1))]);
        x47436 = (x47436 + x0[(((i_47461 + n1) + (-2 * gl_id_47460)) + (gl_id_47460 * n1))]);
        x47436 = (x47436 + x0[((((-4 + i_47461) + (-2 * gl_id_47460)) + (2 * n1)) + (gl_id_47460 * n1))]);
        x47436 = (x47436 + x0[((((-3 + i_47461) + (-2 * gl_id_47460)) + (2 * n1)) + (gl_id_47460 * n1))]);
        x47436 = (x47436 + x0[((((-2 + i_47461) + (-2 * gl_id_47460)) + (2 * n1)) + (gl_id_47460 * n1))]);
        output[((i_47461 + (-4 * gl_id_47460)) + (gl_id_47460 * n1))] = x47436;
      }
      
    }
    
  }
  
}
