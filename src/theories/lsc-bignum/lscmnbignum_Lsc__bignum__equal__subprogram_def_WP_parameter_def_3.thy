theory lscmnbignum_Lsc__bignum__equal__subprogram_def_WP_parameter_def_3
imports "../LibSPARKcrypto"
begin

why3_open "lscmnbignum_Lsc__bignum__equal__subprogram_def_WP_parameter_def_3.xml"

why3_vc WP_parameter_def
  using
    `True = _`
    `(num_of_big_int' a _ _ = num_of_big_int' b _ _) = _`
    `a_first \<le> i1` `i1 \<le> a_last`
  by (simp add: num_of_lint_equals_iff uint_lt [where 'a=32, simplified]
    word32_to_int_def del: num_of_lint_sum)

why3_end

end
