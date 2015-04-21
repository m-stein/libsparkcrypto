theory lscmnec_Lsc__ec__point_double__subprogram_def_WP_parameter_def_20
imports "../LibSPARKcrypto"
begin

why3_open "lscmnec_Lsc__ec__point_double__subprogram_def_WP_parameter_def_20.xml"

why3_vc WP_parameter_def
  using
    `x2 = x21` `l = o1`
    `\<lfloor>o1\<rfloor>\<^sub>\<nat> = \<lfloor>x1_last\<rfloor>\<^sub>\<nat> - \<lfloor>x1_first\<rfloor>\<^sub>\<nat>`
    `(num_of_big_int' (Array x21 _) _ _ = _) = _`
    `(1 < num_of_big_int' m _ _) = _`
  by simp

why3_end

end
