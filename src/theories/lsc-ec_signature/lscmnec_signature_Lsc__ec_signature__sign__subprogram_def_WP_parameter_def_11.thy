theory lscmnec_signature_Lsc__ec_signature__sign__subprogram_def_WP_parameter_def_11
imports "../LibSPARKcrypto"
begin

why3_open "lscmnec_signature_Lsc__ec_signature__sign__subprogram_def_WP_parameter_def_11.xml"

why3_vc WP_parameter_def
proof -
  have "0 \<le> num_of_big_int (word32_to_int \<circ> sign2) sign2_first
    (sign1_last - sign1_first + 1)"
    by (simp add: num_of_lint_lower word32_to_int_lower)
  with
    `bool__content (mk_bool__ref (if is_zero (Array sign2 _) _ _ \<noteq> True then _ else _)) = _`
    `(is_zero (Array sign2 _) _ _ = True) = _`
  show ?thesis by (simp add: map__content_def bool__content_def)
qed

why3_end

end
