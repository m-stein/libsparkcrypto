theory lscmnbignum_Lsc__bignum__add_inplace__subprogram_def_WP_parameter_def_2
imports "../Add"
begin

why3_open "lscmnbignum_Lsc__bignum__add_inplace__subprogram_def_WP_parameter_def_2.xml"

why3_vc WP_parameter_def
proof -
  from `\<lfloor>a_first1\<rfloor>\<^sub>\<nat> \<le> i`
  have "num_of_big_int (word32_to_int o a) \<lfloor>a_first1\<rfloor>\<^sub>\<nat> (i + 1 - \<lfloor>a_first1\<rfloor>\<^sub>\<nat>) +
    num_of_big_int' b \<lfloor>b_first\<rfloor>\<^sub>\<nat> (i + 1 - \<lfloor>a_first1\<rfloor>\<^sub>\<nat>) =
    num_of_big_int (word32_to_int o a) \<lfloor>a_first1\<rfloor>\<^sub>\<nat> (i - \<lfloor>a_first1\<rfloor>\<^sub>\<nat>) +
    num_of_big_int' b \<lfloor>b_first\<rfloor>\<^sub>\<nat> (i - \<lfloor>a_first1\<rfloor>\<^sub>\<nat>) +
    (Base ^ nat (i - \<lfloor>a_first1\<rfloor>\<^sub>\<nat>) * \<lfloor>a i\<rfloor>\<^bsub>w32\<^esub> +
     Base ^ nat (i - \<lfloor>a_first1\<rfloor>\<^sub>\<nat>) * \<lfloor>elts b (\<lfloor>b_first\<rfloor>\<^sub>\<nat> + (i - \<lfloor>a_first1\<rfloor>\<^sub>\<nat>))\<rfloor>\<^bsub>w32\<^esub>)"
    by (simp add: diff_add_eq [symmetric])
  moreover from `\<forall>k. i \<le> k \<and> k \<le> \<lfloor>a_last1\<rfloor>\<^sub>\<nat> \<longrightarrow> \<lfloor>a1 k\<rfloor>\<^bsub>w32\<^esub> = \<lfloor>a k\<rfloor>\<^bsub>w32\<^esub>`
    `i \<le> \<lfloor>a_last1\<rfloor>\<^sub>\<nat>`
  have "\<lfloor>a i\<rfloor>\<^bsub>w32\<^esub> = \<lfloor>a1 i\<rfloor>\<^bsub>w32\<^esub>" by simp
  ultimately show ?thesis using
    `\<lfloor>o1\<rfloor>\<^bsub>w32\<^esub> = _`
    `(num_of_big_int' (Array a _) _ _ + num_of_big_int' b _ _ = _) = _`
    `(\<lfloor>word_of_boolean carry\<rfloor>\<^bsub>w32\<^esub> = num_of_bool carry) = _`
    `\<lfloor>a_first1\<rfloor>\<^sub>\<nat> \<le> i`
    by (simp add: diff_add_eq [symmetric] nat_add_distrib
      add_carry div_mod_eq ring_distribs base_eq emod_def fun_upd_comp
      word32_to_int_lower word32_to_int_upper')
qed

why3_end

end