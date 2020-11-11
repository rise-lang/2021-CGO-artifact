

__kernel
void mul(global float* restrict output, int n0, int n1, const global float* restrict x0, const global float* restrict x1){
  /* Start of moved local vars */
  /* End of moved local vars */
  /* mapGlobal */
  for (int gl_id_47301 = get_global_id(0);(gl_id_47301 < (2 + n0));gl_id_47301 = (gl_id_47301 + get_global_size(0))) {
    /* mapSeq */
    for (int i_47302 = 0;(i_47302 < (-2 + n1));i_47302 = (1 + i_47302)) {
      output[((i_47302 + (-2 * gl_id_47301)) + (gl_id_47301 * n1))] = (x0[((i_47302 + (-2 * gl_id_47301)) + (gl_id_47301 * n1))] * x1[((i_47302 + (-2 * gl_id_47301)) + (gl_id_47301 * n1))]);
    }
    
  }
  
}
