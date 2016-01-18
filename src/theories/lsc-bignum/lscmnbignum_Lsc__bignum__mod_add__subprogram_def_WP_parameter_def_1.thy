theory lscmnbignum_Lsc__bignum__mod_add__subprogram_def_WP_parameter_def_1
imports "../LibSPARKcrypto"
begin

why3_open "lscmnbignum_Lsc__bignum__mod_add__subprogram_def_WP_parameter_def_1.xml"

why3_vc WP_parameter_def
proof -
  let ?k = "a_last - a_first + 1"
  have "num_of_big_int (word32_to_int o a) a_first ?k < Base ^ nat ?k"
    by (simp add: num_of_lint_upper word32_to_int_upper')
  with `(num_of_big_int' b _ _ + num_of_big_int' c _ _ = _) = _`
    `carry \<noteq> True`
  show ?thesis by (simp add: base_eq)
qed

why3_end

end
