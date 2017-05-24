theory lscmnbignum_Lsc__bignum__mont_exp_window__subprogram_def_WP_parameter_def_59
imports "../LibSPARKcrypto"
begin

why3_open "lscmnbignum_Lsc__bignum__mont_exp_window__subprogram_def_WP_parameter_def_59.xml"

why3_vc WP_parameter_def
proof -
  let ?L = "a_last - a_first + 1"
  let ?e = "num_of_big_int (word32_to_int \<circ> elts e) e_first (e_last - e_first + 1)"

  have "?e div 2 ^ nat (uint i - s2) mod 2 ^ nat (s2 + 1) < 2 ^ nat (s2 + 1)"
    by simp
  also from `int__content (mk_int__ref s2) + 1 \<le> k + 1`
  have "(2::int) ^ nat (s2 + 1) \<le> 2 ^ nat (k + 1)"
    by (simp add: int__content_def)
  with `natural_in_range k`
  have "(2::int) ^ nat (s2 + 1) \<le> 2 * 2 ^ nat k"
    by (simp add: nat_add_distrib natural_in_range_def)
  finally have "?e div 2 ^ nat (uint i - s2) mod
    2 ^ nat (s2 + 1) div 2 < 2 ^ nat k"
    by simp
  moreover from `a_first < a_last`
  have "0 \<le> ?e div 2 ^ nat (uint i - s2) mod
    2 ^ nat (s2 + 1) div 2"
    by (simp add: pos_imp_zdiv_nonneg_iff)
  ultimately show ?thesis using
    `\<forall>n. 0 \<le> n \<and> n \<le> 2 ^ nat k - 1 \<longrightarrow> _`
    `(math_int_from_word (t__content (mk_t__ref w)) = _) = _`
    `(_ < num_of_big_int' m _ _) = _`
    by (simp add: ediv_def BV32.facts.to_uint_lsr [of _ 1, simplified] t__content_def int__content_def)
qed

why3_end

end
