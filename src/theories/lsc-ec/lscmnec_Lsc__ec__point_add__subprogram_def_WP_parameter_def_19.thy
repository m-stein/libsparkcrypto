theory lscmnec_Lsc__ec__point_add__subprogram_def_WP_parameter_def_19
imports "../LibSPARKcrypto"
begin

why3_open "lscmnec_Lsc__ec__point_add__subprogram_def_WP_parameter_def_19.xml"

why3_vc WP_parameter_def
proof -
  let ?l = "\<lfloor>x1_last\<rfloor>\<^sub>\<nat> - \<lfloor>x1_first\<rfloor>\<^sub>\<nat> + 1"
  from
    `\<forall>k. \<lfloor>x3_first\<rfloor>\<^sub>\<int> \<le> k \<and> k \<le> \<lfloor>x3_last\<rfloor>\<^sub>\<int> \<longrightarrow> _`
    `\<lfloor>x3_first\<rfloor>\<^sub>\<int> \<le> \<lfloor>x3_first1\<rfloor>\<^sub>\<nat>`
    `\<lfloor>x3_first1\<rfloor>\<^sub>\<nat> + (\<lfloor>x1_last\<rfloor>\<^sub>\<nat> - \<lfloor>x1_first\<rfloor>\<^sub>\<nat>) \<le> \<lfloor>x3_last\<rfloor>\<^sub>\<int>`
  have "num_of_big_int (word32_to_int \<circ> x31) \<lfloor>x3_first1\<rfloor>\<^sub>\<nat> ?l =
    num_of_big_int' x1 \<lfloor>x1_first\<rfloor>\<^sub>\<nat> ?l"
    by (simp add: num_of_lint_ext sign_simps)
  with
    `x3 = x31` `l = o1`
    `\<lfloor>o1\<rfloor>\<^sub>\<nat> = \<lfloor>x1_last\<rfloor>\<^sub>\<nat> - \<lfloor>x1_first\<rfloor>\<^sub>\<nat>`
    `(num_of_big_int' x1 _ _ < num_of_big_int' m _ _) = _`
  show ?thesis by simp
qed

why3_end

end
