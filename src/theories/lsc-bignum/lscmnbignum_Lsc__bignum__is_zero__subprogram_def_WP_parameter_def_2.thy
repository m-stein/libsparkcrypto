theory lscmnbignum_Lsc__bignum__is_zero__subprogram_def_WP_parameter_def_2
imports "../LibSPARKcrypto"
begin

why3_open "lscmnbignum_Lsc__bignum__is_zero__subprogram_def_WP_parameter_def_2.xml"

why3_vc WP_parameter_def
  using
    num_of_lint_equals_iff [where B="\<lambda>i. 0"]
    `mk_bool__ref result_us = mk_bool__ref result_us1`
    `(result_us1 = True) = _`
    `(num_of_big_int' a a_first (a_last - a_first + 1) = _) = _`
    `(if (if elts a a_last = _ then _ else _) \<noteq> _ then _ else _) \<noteq> _`
  by (simp add: num_of_lint_all0
    word32_to_int_def uint_lt [where 'a=32, simplified] uint_0_iff
    del: num_of_lint_sum)

why3_end

end
