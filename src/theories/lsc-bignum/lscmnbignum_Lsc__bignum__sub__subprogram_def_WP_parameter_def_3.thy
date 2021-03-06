theory lscmnbignum_Lsc__bignum__sub__subprogram_def_WP_parameter_def_3
imports "../Sub"
begin

why3_open "lscmnbignum_Lsc__bignum__sub__subprogram_def_WP_parameter_def_3.xml"

why3_vc WP_parameter_def
proof -
  from `(if BV32.ult (elts b (b_first + (o1 - a_first))) (elts c (c_first + (o1 - a_first))) then _ else _) = _`
  have eq: "num_of_bool True = num_of_bool
    (\<lfloor>elts b (b_first + (o1 - a_first))\<rfloor>\<^sub>s < \<lfloor>elts c (c_first + (o1 - a_first))\<rfloor>\<^sub>s \<or>
     \<lfloor>elts b (b_first + (o1 - a_first))\<rfloor>\<^sub>s = \<lfloor>elts c (c_first + (o1 - a_first))\<rfloor>\<^sub>s \<and> carry1)"
    by (simp add: BV32.ult_def word32_to_int_def)
  from
    `(num_of_big_int' b _ _ - num_of_big_int' c _ _= _) = _`
    `a_first \<le> o1`
    `o2 = _`
    `(math_int_from_word (word_of_boolean carry1) = num_of_bool carry1) = _`
  show ?thesis
    by (simp (no_asm_simp) only: eq)
      (simp add: diff_add_eq [symmetric] nat_add_distrib
       sub_carry [of _ Base] div_mod_eq ring_distribs base_eq
       fun_upd_comp uint_lt [where 'a=32, simplified]
       word32_to_int_def uint_word_ariths del: uint_inject)
qed

why3_end

end
