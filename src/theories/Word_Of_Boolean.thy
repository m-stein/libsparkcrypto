theory Word_Of_Boolean
imports Bignum
begin

spark_open "$VCG_DIR/lsc_/bignum/word_of_boolean.siv" (lsc__bignum)

spark_vc function_word_of_boolean_3
  by simp

spark_vc function_word_of_boolean_4
  by simp

spark_end

end
