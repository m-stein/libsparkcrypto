theory lscmnbignum_Lsc__bignum__mont_exp_window__subprogram_def_WP_parameter_def_4
imports "../LibSPARKcrypto"
begin

why3_open "lscmnbignum_Lsc__bignum__mont_exp_window__subprogram_def_WP_parameter_def_4.xml"

why3_vc WP_parameter_def
  using
    `(num_of_big_int' r _ _ = _) = _`
    `(_ < num_of_big_int' m _ _) = _`
  by simp

why3_end

end
