theory lscmnbignum_Lsc__bignum__size_square_mod__subprogram_def_WP_parameter_def_7
imports "../LibSPARKcrypto"
begin

why3_open "lscmnbignum_Lsc__bignum__size_square_mod__subprogram_def_WP_parameter_def_7.xml"

why3_vc WP_parameter_def
  using
    `(num_of_big_int' (Array r1 _) _ _ = _) = _`
    `m_first \<le> m_last`
  by (simp add: nat_add_distrib mult_ac base_eq map__content_def)

why3_end

end
