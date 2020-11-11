

__kernel
void gray(global float* restrict output, int n0, int n1, const global float* restrict x0){
  /* Start of moved local vars */
  /* End of moved local vars */
  /* mapGlobal */
  for (int gl_id_46591 = get_global_id(0);(gl_id_46591 < (4 + n0));gl_id_46591 = (gl_id_46591 + get_global_size(0))) {
    /* mapSeq */
    for (int i_46592 = 0;(i_46592 < n1);i_46592 = (1 + i_46592)) {
      /* oclReduceSeq */
      {
        float x46564;
        x46564 = 0.0f;
        /* unrolling loop of 3 */
        x46564 = (x46564 + (0.299f * x0[(i_46592 + (gl_id_46591 * n1))]));
        x46564 = (x46564 + (0.587f * x0[(((i_46592 + (4 * n1)) + (gl_id_46591 * n1)) + (n0 * n1))]));
        x46564 = (x46564 + (0.114f * x0[(((i_46592 + ((2 * n0) * n1)) + (8 * n1)) + (gl_id_46591 * n1))]));
        output[(i_46592 + (gl_id_46591 * n1))] = x46564;
      }
      
    }
    
  }
  
}
