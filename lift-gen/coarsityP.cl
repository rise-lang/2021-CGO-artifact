

__kernel
void coarsity(global float* restrict output, int n0, int n1, const global float* restrict x0, const global float* restrict x1, const global float* restrict x2){
  /* Start of moved local vars */
  /* End of moved local vars */
  /* mapGlobal */
  for (int gl_id_47800 = get_global_id(0);(gl_id_47800 < n0);gl_id_47800 = (gl_id_47800 + get_global_size(0))) {
    /* mapSeq */
    for (int i_47801 = 0;(i_47801 < (-4 + n1));i_47801 = (1 + i_47801)) {
      output[(i_47801 + (gl_id_47800 * n1))] = (((x0[((i_47801 + (-4 * gl_id_47800)) + (gl_id_47800 * n1))] * x2[((i_47801 + (-4 * gl_id_47800)) + (gl_id_47800 * n1))]) - (x1[((i_47801 + (-4 * gl_id_47800)) + (gl_id_47800 * n1))] * x1[((i_47801 + (-4 * gl_id_47800)) + (gl_id_47800 * n1))])) - ((0.04f * (x0[((i_47801 + (-4 * gl_id_47800)) + (gl_id_47800 * n1))] + x2[((i_47801 + (-4 * gl_id_47800)) + (gl_id_47800 * n1))])) * (x0[((i_47801 + (-4 * gl_id_47800)) + (gl_id_47800 * n1))] + x2[((i_47801 + (-4 * gl_id_47800)) + (gl_id_47800 * n1))])));
    }
    
  }
  
}
