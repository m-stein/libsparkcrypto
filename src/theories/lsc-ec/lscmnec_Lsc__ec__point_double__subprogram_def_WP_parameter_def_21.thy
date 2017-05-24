theory lscmnec_Lsc__ec__point_double__subprogram_def_WP_parameter_def_21
imports "../LibSPARKcrypto"
begin

why3_open "lscmnec_Lsc__ec__point_double__subprogram_def_WP_parameter_def_21.xml"

why3_vc WP_parameter_def
  using
    `\<forall>k. x2_first \<le> k \<and> k \<le> x2_first + _ \<longrightarrow> x2 k = of_int 0`
    `(math_int_from_word (of_int 1) < num_of_big_int' m _ _) = _`
  by (simp add: num_of_lint_all0 word32_to_int_def map__content_def)

why3_end

end
