theory lscmnbignum_Lsc__bignum__double_inplace__subprogram_def_WP_parameter_def_2
imports "../LibSPARKcrypto"
begin

lemma num_of_bool_mod2: "num_of_bool (x mod 2 \<noteq> 0) = x mod 2"
  by (simp split: num_of_bool_split)

lemma div_mod_eq: "(x::int) * (y mod b) + b * x * (y div b) = x * y"
proof -
  have "x * (y mod b) + b * x * (y div b) = x * (y mod b + b * (y div b))"
    by (simp only: ring_distribs mult_ac)
  then show ?thesis by simp
qed

lemma double_inplace_carry:
  assumes "0 \<le> a" and "a \<le> Base - 1"
  shows "num_of_bool (a AND 2147483648 \<noteq> 0) =
    (a * 2 + num_of_bool carry) div (2 * 2147483648)"
proof -
  let ?X = 2147483648
  from AND_div_mod [of _ 31]
  have "(a AND ?X \<noteq> 0) = (a div ?X mod 2 \<noteq> 0)" (is "?l = ?r")
    by simp
  then have "num_of_bool ?l = num_of_bool ?r" by simp
  also note num_of_bool_mod2
  also from `a \<le> Base - 1` have "a div ?X \<le> 1" by simp
  with `0 \<le> a` have "a div ?X mod 2 = a div ?X"
    by (simp add: mod_pos_pos_trivial)
  also have "a div ?X = (a * 2 + num_of_bool carry) div (2 * ?X)"
    by (simp only: zdiv_zmult2_eq)
      (simp add: zdiv_zadd1_eq [of "a * 2" "num_of_bool carry" 2]
         split: num_of_bool_split)
  finally show ?thesis .
qed

why3_open "lscmnbignum_Lsc__bignum__double_inplace__subprogram_def_WP_parameter_def_2.xml"

why3_vc WP_parameter_def
proof -
  have "0 \<le> \<lfloor>a1 i\<rfloor>\<^bsub>w32\<^esub>" "\<lfloor>a1 i\<rfloor>\<^bsub>w32\<^esub> \<le> Base - 1"
    by (simp_all add: word32_to_int_lower word32_to_int_upper')
  then have "num_of_bool (\<lfloor>a1 i\<rfloor>\<^bsub>w32\<^esub> AND 2147483648 \<noteq> 0) =
    (\<lfloor>a1 i\<rfloor>\<^bsub>w32\<^esub> * 2 + num_of_bool carry) div (2 * 2147483648)"
    by (rule double_inplace_carry)
  moreover from `\<forall>k. i \<le> k \<and> k \<le> \<lfloor>a_last1\<rfloor>\<^sub>\<nat> \<longrightarrow> \<lfloor>a1 k\<rfloor>\<^bsub>w32\<^esub> = \<lfloor>a k\<rfloor>\<^bsub>w32\<^esub>`
    `i \<le> \<lfloor>a_last1\<rfloor>\<^sub>\<nat>`
  have "\<lfloor>a i\<rfloor>\<^bsub>w32\<^esub> = \<lfloor>a1 i\<rfloor>\<^bsub>w32\<^esub>" by simp
  ultimately show ?thesis
    using `\<lfloor>a_first1\<rfloor>\<^sub>\<nat> \<le> i`
      `(num_of_big_int' (Array a _) _ _ * 2 = num_of_big_int' (Array a1 _) _ _ + _) = _`
      `\<lfloor>o1\<rfloor>\<^bsub>w32\<^esub> = _`
      `\<lfloor>shl32 \<lfloor>a1 i\<rfloor>\<^bsub>w32\<^esub> 1\<rfloor>\<^bsub>w32\<^esub> = \<lfloor>a1 i\<rfloor>\<^bsub>w32\<^esub> * 2 ^ nat 1 emod Base`
      `(\<lfloor>word_of_boolean carry\<rfloor>\<^bsub>w32\<^esub> = num_of_bool carry) = _`
    by (simp add: diff_add_eq [symmetric] nat_add_distrib div_mod_eq ring_distribs
      emod_def base_eq fun_upd_comp)
qed

why3_end

end
