theory lscmnbignum_Lsc__bignum__word_of_boolean__subprogram_def_WP_parameter_def_2
imports "../LibSPARKcrypto"
begin

why3_open "lscmnbignum_Lsc__bignum__word_of_boolean__subprogram_def_WP_parameter_def_2.xml"

why3_vc WP_parameter_def
  using
    `lsc__bignum__word_of_boolean__result = o1`
    `\<lfloor>o1\<rfloor>\<^bsub>w32\<^esub> = 1`
    `b = True`
  by simp

why3_end

end