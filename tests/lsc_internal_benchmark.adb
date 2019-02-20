-------------------------------------------------------------------------------
-- This file is part of libsparkcrypto.
--
-- Copyright (C) 2018, Componolit GmbH
-- Copyright (C) 2015, Stefan Berghofer
-- Copyright (C) 2010, Alexander Senier
-- Copyright (C) 2010, secunet Security Networks AG
-- All rights reserved.
--
-- Redistribution  and  use  in  source  and  binary  forms,  with  or  without
-- modification, are permitted provided that the following conditions are met:
--
--    * Redistributions of source code must retain the above copyright notice,
--      this list of conditions and the following disclaimer.
--
--    * Redistributions in binary form must reproduce the above copyright
--      notice, this list of conditions and the following disclaimer in the
--      documentation and/or other materials provided with the distribution.
--
--    * Neither the name of the  nor the names of its contributors may be used
--      to endorse or promote products derived from this software without
--      specific prior written permission.
--
-- THIS SOFTWARE IS PROVIDED BY THE  COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
-- AND ANY  EXPRESS OR IMPLIED WARRANTIES,  INCLUDING, BUT NOT LIMITED  TO, THE
-- IMPLIED WARRANTIES OF  MERCHANTABILITY AND FITNESS FOR  A PARTICULAR PURPOSE
-- ARE  DISCLAIMED. IN  NO EVENT  SHALL  THE COPYRIGHT  HOLDER OR  CONTRIBUTORS
-- BE  LIABLE FOR  ANY  DIRECT, INDIRECT,  INCIDENTAL,  SPECIAL, EXEMPLARY,  OR
-- CONSEQUENTIAL  DAMAGES  (INCLUDING,  BUT  NOT  LIMITED  TO,  PROCUREMENT  OF
-- SUBSTITUTE GOODS  OR SERVICES; LOSS  OF USE,  DATA, OR PROFITS;  OR BUSINESS
-- INTERRUPTION)  HOWEVER CAUSED  AND ON  ANY THEORY  OF LIABILITY,  WHETHER IN
-- CONTRACT,  STRICT LIABILITY,  OR  TORT (INCLUDING  NEGLIGENCE OR  OTHERWISE)
-- ARISING IN ANY WAY  OUT OF THE USE OF THIS SOFTWARE, EVEN  IF ADVISED OF THE
-- POSSIBILITY OF SUCH DAMAGE.
-------------------------------------------------------------------------------

with LSC.Internal.Types;
with LSC.Internal.RIPEMD160;
with LSC.Internal.SHA1;
with LSC.Internal.SHA256;
with LSC.Internal.SHA512;
with LSC.Internal.AES.CBC;
with LSC.Internal.HMAC_RIPEMD160;
with LSC.Internal.HMAC_SHA1;
with LSC.Internal.HMAC_SHA256;
with LSC.Internal.HMAC_SHA384;
with LSC.Internal.HMAC_SHA512;
with LSC.Internal.Bignum;
with OpenSSL;
with AUnit.Assertions; use AUnit.Assertions;
with Interfaces;

use type LSC.Internal.Types.Word32_Array_Type;
use type LSC.Internal.Types.Word64_Array_Type;
use type LSC.Internal.AES.Message_Type;
use type LSC.Internal.Bignum.Big_Int;
use type Interfaces.Unsigned_32;

pragma Style_Checks ("-s");

package body LSC_Internal_Benchmark
is
   use Ada.Calendar;

   function Routine_Name (T : Test_Case) return Message_String
   is
      Ref_Time  : constant Duration := T.Reference_Stop - T.Reference_Start;
      Test_Time : constant Duration := T.Test_Stop - T.Test_Start;
      Percent   : constant Natural  := Natural (Duration'(Test_Time / Ref_Time) * 100.0);
   begin
      return Format (AUnit.Test_Cases.Test_Case (T).Routine_Name.all & " ... [" & Percent'Img & "% ]");
   end Routine_Name;

   ---------------------------------------------------------------------------

   procedure Benchmark_RIPEMD160 (T : in out Test_Case'Class)
   is
      Block1, Block2       : LSC.Internal.RIPEMD160.Block_Type;
      RIPEMD160_Context1   : OpenSSL.RIPEMD160_Context_Type;
      RIPEMD160_Context2   : LSC.Internal.RIPEMD160.Context_Type;
      H1, H2               : LSC.Internal.RIPEMD160.Hash_Type;
   begin

      Block1  := LSC.Internal.RIPEMD160.Block_Type'(others => 16#cafebabe#);
      Block2  := LSC.Internal.RIPEMD160.Block_Type'(others => 16#00636261#);

      T.Reference_Start := Clock;
      for I in Natural range 1 .. 200000
      loop
         OpenSSL.RIPEMD160_Context_Init (RIPEMD160_Context1);
         OpenSSL.RIPEMD160_Context_Update (RIPEMD160_Context1, Block1);
         OpenSSL.RIPEMD160_Context_Finalize (RIPEMD160_Context1, Block2, 56);
      end loop;
      H1 := OpenSSL.RIPEMD160_Get_Hash (RIPEMD160_Context1);
      T.Reference_Stop := Clock;

      T.Test_Start := Clock;
      for I in Natural range 1 .. 200000
      loop
         RIPEMD160_Context2 := LSC.Internal.RIPEMD160.Context_Init;
         LSC.Internal.RIPEMD160.Context_Update (RIPEMD160_Context2, Block1);
         LSC.Internal.RIPEMD160.Context_Finalize (RIPEMD160_Context2, Block2, 56);
      end loop;
      H2 := LSC.Internal.RIPEMD160.Get_Hash (RIPEMD160_Context2);
      T.Test_Stop := Clock;

      Assert (H1 = H2, "Invalid hash");

   end Benchmark_RIPEMD160;

   ---------------------------------------------------------------------------

   procedure Benchmark_SHA1 (T : in out Test_Case'Class)
   is
      Block1, Block2 : LSC.Internal.SHA1.Block_Type;
      SHA1_Context1  : OpenSSL.SHA1_Context_Type;
      SHA1_Context2  : LSC.Internal.SHA1.Context_Type;
      H1, H2         : LSC.Internal.SHA1.Hash_Type;
   begin
      Block1 := LSC.Internal.SHA1.Block_Type'(others => 16#cafebabe#);
      Block2 := LSC.Internal.SHA1.Block_Type'(others => 16#00636261#);

      T.Reference_Start := Clock;
      for I in Natural range 1 .. 500000
      loop
         OpenSSL.SHA1_Context_Init (SHA1_Context1);
         OpenSSL.SHA1_Context_Update (SHA1_Context1, Block1);
         OpenSSL.SHA1_Context_Finalize (SHA1_Context1, Block2, 56);
      end loop;
      H1 := OpenSSL.SHA1_Get_Hash (SHA1_Context1);
      T.Reference_Stop := Clock;

      T.Test_Start := Clock;
      for I in Natural range 1 .. 500000
      loop
         SHA1_Context2 := LSC.Internal.SHA1.Context_Init;
         LSC.Internal.SHA1.Context_Update (SHA1_Context2, Block1);
         LSC.Internal.SHA1.Context_Finalize (SHA1_Context2, Block2, 56);
      end loop;
      H2 := LSC.Internal.SHA1.Get_Hash (SHA1_Context2);
      T.Test_Stop := Clock;

      Assert (H1 = H2, "Invalid hash");

   end Benchmark_SHA1;

   ---------------------------------------------------------------------------

   procedure Benchmark_SHA256 (T : in out Test_Case'Class)
   is
      Block1, Block2  : LSC.Internal.SHA256.Block_Type;
      SHA256_Context1 : OpenSSL.SHA256_Context_Type;
      SHA256_Context2 : LSC.Internal.SHA256.Context_Type;
      H1, H2          : LSC.Internal.SHA256.SHA256_Hash_Type;
   begin
      Block1  := LSC.Internal.SHA256.Block_Type'(others => 16#cafebabe#);
      Block2  := LSC.Internal.SHA256.Block_Type'(others => 16#00636261#);

      T.Reference_Start := Clock;
      for I in Natural range 1 .. 500000
      loop
         OpenSSL.SHA256_Context_Init (SHA256_Context1);
         OpenSSL.SHA256_Context_Update (SHA256_Context1, Block1);
         OpenSSL.SHA256_Context_Finalize (SHA256_Context1, Block2, 56);
      end loop;
      H1 := OpenSSL.SHA256_Get_Hash (SHA256_Context1);
      T.Reference_Stop := Clock;

      T.Test_Start := Clock;
      for I in Natural range 1 .. 500000
      loop
         SHA256_Context2 := LSC.Internal.SHA256.SHA256_Context_Init;
         LSC.Internal.SHA256.Context_Update (SHA256_Context2, Block1);
         LSC.Internal.SHA256.Context_Finalize (SHA256_Context2, Block2, 56);
      end loop;
      H2 := LSC.Internal.SHA256.SHA256_Get_Hash (SHA256_Context2);
      T.Test_Stop := Clock;

      Assert (H1 = H2, "Invalid hash");

   end Benchmark_SHA256;

   ---------------------------------------------------------------------------

   procedure Benchmark_SHA384 (T : in out Test_Case'Class)
   is
      Block1, Block2  : LSC.Internal.SHA512.Block_Type;
      SHA384_Context1 : OpenSSL.SHA384_Context_Type;
      SHA384_Context2 : LSC.Internal.SHA512.Context_Type;
      H1, H2          : LSC.Internal.SHA512.SHA384_Hash_Type;
   begin
      Block1  := LSC.Internal.SHA512.Block_Type'(others => 16#deadbeefcafebabe#);
      Block2  := LSC.Internal.SHA512.Block_Type'(others => 16#0000000000636261#);

      T.Reference_Start := Clock;
      for I in Natural range 1 .. 500000
      loop
         OpenSSL.SHA384_Context_Init (SHA384_Context1);
         OpenSSL.SHA384_Context_Update (SHA384_Context1, Block1);
         OpenSSL.SHA384_Context_Finalize (SHA384_Context1, Block2, 56);
      end loop;
      H1 := OpenSSL.SHA384_Get_Hash (SHA384_Context1);
      T.Reference_Stop := Clock;

      T.Test_Start := Clock;
      for I in Natural range 1 .. 500000
      loop
         SHA384_Context2 := LSC.Internal.SHA512.SHA384_Context_Init;
         LSC.Internal.SHA512.Context_Update (SHA384_Context2, Block1);
         LSC.Internal.SHA512.Context_Finalize (SHA384_Context2, Block2, 56);
      end loop;
      H2 := LSC.Internal.SHA512.SHA384_Get_Hash (SHA384_Context2);
      T.Test_Stop := Clock;

      Assert (H1 = H2, "Invalid hash");

   end Benchmark_SHA384;

   ---------------------------------------------------------------------------

   procedure Benchmark_SHA512 (T : in out Test_Case'Class)
   is
      Block1, Block2  : LSC.Internal.SHA512.Block_Type;
      SHA512_Context1 : OpenSSL.SHA512_Context_Type;
      SHA512_Context2 : LSC.Internal.SHA512.Context_Type;
      H1, H2          : LSC.Internal.SHA512.SHA512_Hash_Type;
   begin
      Block1  := LSC.Internal.SHA512.Block_Type'(others => 16#deadbeefcafebabe#);
      Block2  := LSC.Internal.SHA512.Block_Type'(others => 16#0000000000636261#);

      T.Reference_Start := Clock;
      for I in Natural range 1 .. 500000
      loop
         OpenSSL.SHA512_Context_Init (SHA512_Context1);
         OpenSSL.SHA512_Context_Update (SHA512_Context1, Block1);
         OpenSSL.SHA512_Context_Finalize (SHA512_Context1, Block2, 56);
      end loop;
      H1 := OpenSSL.SHA512_Get_Hash (SHA512_Context1);
      T.Reference_Stop := Clock;

      T.Test_Start := Clock;
      for I in Natural range 1 .. 500000
      loop
         SHA512_Context2 := LSC.Internal.SHA512.SHA512_Context_Init;
         LSC.Internal.SHA512.Context_Update (SHA512_Context2, Block1);
         LSC.Internal.SHA512.Context_Finalize (SHA512_Context2, Block2, 56);
      end loop;
      H2 := LSC.Internal.SHA512.SHA512_Get_Hash (SHA512_Context2);
      T.Test_Stop := Clock;

      Assert (H1 = H2, "Invalid hash");
   end Benchmark_SHA512;

   ---------------------------------------------------------------------------

   procedure Benchmark_AES128_Decrypt (T : in out Test_Case'Class)
   is
      subtype Message_Index is Natural range 1 .. 1000;
      subtype Message_Type is LSC.Internal.AES.Message_Type (Message_Index);

      Plain1, Plain2, Cipher  : Message_Type;
      Key128                  : LSC.Internal.AES.AES128_Key_Type;
      Context1                : OpenSSL.AES_Dec_Context_Type;
      Context2                : LSC.Internal.AES.AES_Dec_Context;
   begin

      Cipher := Message_Type'
         (others => LSC.Internal.AES.Block_Type'(16#33221100#,
                                                 16#77665544#,
                                                 16#bbaa9988#,
                                                 16#ffeeddcc#));

      Key128 := LSC.Internal.AES.AES128_Key_Type'(16#03020100#,
                                                  16#07060504#,
                                                  16#0b0a0908#,
                                                  16#1f1e1d1c#);

      T.Reference_Start := Clock;
      Context1 := OpenSSL.Create_AES128_Dec_Context (Key128);
      for k in Natural range 1 .. 20
      loop
         for I in Message_Index
         loop
            Plain1 (I) := OpenSSL.Decrypt (Context1, Cipher (I));
         end loop;
      end loop;
      T.Reference_Stop := Clock;

      T.Test_Start := Clock;
      Context2 := LSC.Internal.AES.Create_AES128_Dec_Context (Key128);
      for k in Natural range 1 .. 20
      loop
         for I in Message_Index
         loop
            Plain2 (I) := LSC.Internal.AES.Decrypt (Context2, Cipher (I));
         end loop;
      end loop;
      T.Test_Stop := Clock;

      Assert (Plain1 = Plain2, "Invalid decryption");

   end Benchmark_AES128_Decrypt;

   ---------------------------------------------------------------------------

   procedure Benchmark_AES128_CBC_Decrypt (T : in out Test_Case'Class)
   is
      subtype Message_Index is Natural range 1 .. 1000;
      subtype Message_Type is LSC.Internal.AES.Message_Type (Message_Index);

      Plain1, Plain2, Cipher  : Message_Type;
      Key128                  : LSC.Internal.AES.AES128_Key_Type;
      Context1                : OpenSSL.AES_Dec_Context_Type;
      Context2                : LSC.Internal.AES.AES_Dec_Context;
      IV                      : LSC.Internal.AES.Block_Type;
   begin

      IV := LSC.Internal.AES.Block_Type'
        (16#cafebabe#,
         16#deadbeef#,
         16#d00faffe#,
         16#12345678#);

      Cipher := Message_Type'
         (others => LSC.Internal.AES.Block_Type'(16#33221100#,
                                                 16#77665544#,
                                                 16#bbaa9988#,
                                                 16#ffeeddcc#));

      Key128 := LSC.Internal.AES.AES128_Key_Type'(16#03020100#,
                                                  16#07060504#,
                                                  16#0b0a0908#,
                                                  16#1f1e1d1c#);

      T.Reference_Start := Clock;
      Context1 := OpenSSL.Create_AES128_Dec_Context (Key128);
      for k in Natural range 1 .. 20
      loop
         OpenSSL.CBC_Decrypt (Cipher, Plain1, Context1, IV);
      end loop;
      T.Reference_Stop := Clock;

      T.Test_Start := Clock;
      Context2 := LSC.Internal.AES.Create_AES128_Dec_Context (Key128);
      for k in Natural range 1 .. 20
      loop
         LSC.Internal.AES.CBC.Decrypt (Context2, IV, Cipher, Cipher'Length, Plain2);
      end loop;
      T.Test_Stop := Clock;

      Assert (Plain1 = Plain2, "Invalid decryption");

   end Benchmark_AES128_CBC_Decrypt;

   ---------------------------------------------------------------------------

   procedure Benchmark_AES128_Encrypt (T : in out Test_Case'Class)
   is
      subtype Message_Index is Natural range 1 .. 1000;
      subtype Message_Type is LSC.Internal.AES.Message_Type (Message_Index);

      Plain, Cipher1, Cipher2 : Message_Type;
      Key128                  : LSC.Internal.AES.AES128_Key_Type;
      Context1                : OpenSSL.AES_Enc_Context_Type;
      Context2                : LSC.Internal.AES.AES_Enc_Context;
   begin

      Plain := Message_Type'
         (others => LSC.Internal.AES.Block_Type'(16#33221100#,
                                        16#77665544#,
                                        16#bbaa9988#,
                                        16#ffeeddcc#));

      Key128 := LSC.Internal.AES.AES128_Key_Type'(16#03020100#,
                                                  16#07060504#,
                                                  16#0b0a0908#,
                                                  16#0f0e0d0c#);

      T.Reference_Start := Clock;
      Context1 := OpenSSL.Create_AES128_Enc_Context (Key128);
      for k in Natural range 1 .. 20
      loop
         for I in Message_Index
         loop
            Cipher1 (I) := OpenSSL.Encrypt (Context1, Plain (I));
         end loop;
      end loop;
      T.Reference_Stop := Clock;

      T.Test_Start := Clock;
      Context2 := LSC.Internal.AES.Create_AES128_Enc_Context (Key128);
      for k in Natural range 1 .. 20
      loop
         for I in Message_Index
         loop
            Cipher2 (I) := LSC.Internal.AES.Encrypt (Context2, Plain (I));
         end loop;
      end loop;
      T.Test_Stop := Clock;

      Assert (Cipher1 = Cipher2, "Invalid encryption");

   end Benchmark_AES128_Encrypt;

   ---------------------------------------------------------------------------

   procedure Benchmark_AES128_CBC_Encrypt (T : in out Test_Case'Class)
   is
      subtype Message_Index is Natural range 1 .. 1000;
      subtype Message_Type is LSC.Internal.AES.Message_Type (Message_Index);

      Plain, Cipher1, Cipher2 : Message_Type;
      Key128                  : LSC.Internal.AES.AES128_Key_Type;
      Context1                : OpenSSL.AES_Enc_Context_Type;
      Context2                : LSC.Internal.AES.AES_Enc_Context;
      IV                      : LSC.Internal.AES.Block_Type;
   begin

      IV := LSC.Internal.AES.Block_Type'
        (16#cafebabe#,
         16#deadbeef#,
         16#d00faffe#,
         16#12345678#);

      Plain := Message_Type'
         (others => LSC.Internal.AES.Block_Type'(16#33221100#,
                                                 16#77665544#,
                                                 16#bbaa9988#,
                                                 16#ffeeddcc#));

      Key128 := LSC.Internal.AES.AES128_Key_Type'(16#03020100#,
                                                  16#07060504#,
                                                  16#0b0a0908#,
                                                  16#0f0e0d0c#);

      T.Reference_Start := Clock;
      Context1 := OpenSSL.Create_AES128_Enc_Context (Key128);
      for k in Natural range 1 .. 20
      loop
         OpenSSL.CBC_Encrypt (Plain, Cipher1, Context1, IV);
      end loop;
      T.Reference_Stop := Clock;

      T.Test_Start := Clock;
      Context2 := LSC.Internal.AES.Create_AES128_Enc_Context (Key128);
      for k in Natural range 1 .. 20
      loop
         LSC.Internal.AES.CBC.Encrypt (Context2, IV, Plain, Plain'Length, Cipher2);
      end loop;
      T.Test_Stop := Clock;

      Assert (Cipher1 = Cipher2, "Invalid decryption");

   end Benchmark_AES128_CBC_Encrypt;

   ---------------------------------------------------------------------------

   procedure Benchmark_AES192_Decrypt (T : in out Test_Case'Class)
   is
      subtype Message_Index is Natural range 1 .. 1000;
      subtype Message_Type is LSC.Internal.AES.Message_Type (Message_Index);

      Plain1, Plain2, Cipher  : Message_Type;
      Key192                  : LSC.Internal.AES.AES192_Key_Type;
      Context1                : OpenSSL.AES_Dec_Context_Type;
      Context2                : LSC.Internal.AES.AES_Dec_Context;
   begin

      Cipher := Message_Type'
         (others => LSC.Internal.AES.Block_Type'(16#33221100#,
                                                 16#77665544#,
                                                 16#bbaa9988#,
                                                 16#ffeeddcc#));

      Key192 := LSC.Internal.AES.AES192_Key_Type'(16#03020100#,
                                                  16#07060504#,
                                                  16#13121110#,
                                                  16#17161514#,
                                                  16#1b1a1918#,
                                                  16#1f1e1d1c#);

      T.Reference_Start := Clock;
      Context1 := OpenSSL.Create_AES192_Dec_Context (Key192);
      for k in Natural range 1 .. 20
      loop
         for I in Message_Index
         loop
            Plain1 (I) := OpenSSL.Decrypt (Context1, Cipher (I));
         end loop;
      end loop;
      T.Reference_Stop := Clock;

      T.Test_Start := Clock;
      Context2 := LSC.Internal.AES.Create_AES192_Dec_Context (Key192);
      for k in Natural range 1 .. 20
      loop
         for I in Message_Index
         loop
            Plain2 (I) := LSC.Internal.AES.Decrypt (Context2, Cipher (I));
         end loop;
      end loop;
      T.Test_Stop := Clock;

      Assert (Plain1 = Plain2, "Invalid decryption");

   end Benchmark_AES192_Decrypt;

   ---------------------------------------------------------------------------

   procedure Benchmark_AES192_CBC_Decrypt (T : in out Test_Case'Class)
   is
      subtype Message_Index is Natural range 1 .. 1000;
      subtype Message_Type is LSC.Internal.AES.Message_Type (Message_Index);

      Plain1, Plain2, Cipher  : Message_Type;
      Key192                  : LSC.Internal.AES.AES192_Key_Type;
      Context1                : OpenSSL.AES_Dec_Context_Type;
      Context2                : LSC.Internal.AES.AES_Dec_Context;
      IV                      : LSC.Internal.AES.Block_Type;
   begin

      IV := LSC.Internal.AES.Block_Type'
        (16#cafebabe#,
         16#deadbeef#,
         16#d00faffe#,
         16#12345678#);

      Cipher := Message_Type'
         (others => LSC.Internal.AES.Block_Type'(16#33221100#,
                                                 16#77665544#,
                                                 16#bbaa9988#,
                                                 16#ffeeddcc#));

      Key192 := LSC.Internal.AES.AES192_Key_Type'(16#03020100#,
                                                  16#07060504#,
                                                  16#13121110#,
                                                  16#17161514#,
                                                  16#1b1a1918#,
                                                  16#1f1e1d1c#);

      T.Reference_Start := Clock;
      Context1 := OpenSSL.Create_AES192_Dec_Context (Key192);
      for k in Natural range 1 .. 20
      loop
         OpenSSL.CBC_Decrypt (Cipher, Plain1, Context1, IV);
      end loop;
      T.Reference_Stop := Clock;

      T.Test_Start := Clock;
      Context2 := LSC.Internal.AES.Create_AES192_Dec_Context (Key192);
      for k in Natural range 1 .. 20
      loop
         LSC.Internal.AES.CBC.Decrypt (Context2, IV, Cipher, Cipher'Length, Plain2);
      end loop;
      T.Test_Stop := Clock;

      Assert (Plain1 = Plain2, "Invalid decryption");

   end Benchmark_AES192_CBC_Decrypt;

   ---------------------------------------------------------------------------

   procedure Benchmark_AES192_Encrypt (T : in out Test_Case'Class)
   is
      subtype Message_Index is Natural range 1 .. 1000;
      subtype Message_Type is LSC.Internal.AES.Message_Type (Message_Index);

      Plain, Cipher1, Cipher2 : Message_Type;
      Key192                  : LSC.Internal.AES.AES192_Key_Type;
      Context1                : OpenSSL.AES_Enc_Context_Type;
      Context2                : LSC.Internal.AES.AES_Enc_Context;
   begin

      Plain := Message_Type'
         (others => LSC.Internal.AES.Block_Type'(16#33221100#,
                                                 16#77665544#,
                                                 16#bbaa9988#,
                                                 16#ffeeddcc#));

      Key192 := LSC.Internal.AES.AES192_Key_Type'(16#03020100#,
                                                  16#07060504#,
                                                  16#07060504#,
                                                  16#0b0a0908#,
                                                  16#0b0a0908#,
                                                  16#0f0e0d0c#);

      T.Reference_Start := Clock;
      Context1 := OpenSSL.Create_AES192_Enc_Context (Key192);
      for k in Natural range 1 .. 20
      loop
         for I in Message_Index
         loop
            Cipher1 (I) := OpenSSL.Encrypt (Context1, Plain (I));
         end loop;
      end loop;
      T.Reference_Stop := Clock;

      T.Test_Start := Clock;
      Context2 := LSC.Internal.AES.Create_AES192_Enc_Context (Key192);
      for k in Natural range 1 .. 20
      loop
         for I in Message_Index
         loop
            Cipher2 (I) := LSC.Internal.AES.Encrypt (Context2, Plain (I));
         end loop;
      end loop;
      T.Test_Stop := Clock;

      Assert (Cipher1 = Cipher2, "Invalid encryption");

   end Benchmark_AES192_Encrypt;

   ---------------------------------------------------------------------------

   procedure Benchmark_AES192_CBC_Encrypt (T : in out Test_Case'Class)
   is
      subtype Message_Index is Natural range 1 .. 1000;
      subtype Message_Type is LSC.Internal.AES.Message_Type (Message_Index);

      Plain, Cipher1, Cipher2 : Message_Type;
      Key192                  : LSC.Internal.AES.AES192_Key_Type;
      Context1                : OpenSSL.AES_Enc_Context_Type;
      Context2                : LSC.Internal.AES.AES_Enc_Context;
      IV                      : LSC.Internal.AES.Block_Type;
   begin

      IV := LSC.Internal.AES.Block_Type'
        (16#cafebabe#,
         16#deadbeef#,
         16#d00faffe#,
         16#12345678#);

      Plain := Message_Type'
         (others => LSC.Internal.AES.Block_Type'(16#33221100#,
                                        16#77665544#,
                                        16#bbaa9988#,
                                        16#ffeeddcc#));

      Key192 := LSC.Internal.AES.AES192_Key_Type'(16#03020100#,
                                                  16#07060504#,
                                                  16#07060504#,
                                                  16#0b0a0908#,
                                                  16#0b0a0908#,
                                                  16#0f0e0d0c#);

      T.Reference_Start := Clock;
      Context1 := OpenSSL.Create_AES192_Enc_Context (Key192);
      for k in Natural range 1 .. 20
      loop
         OpenSSL.CBC_Encrypt (Plain, Cipher1, Context1, IV);
      end loop;
      T.Reference_Stop := Clock;

      T.Test_Start := Clock;
      Context2 := LSC.Internal.AES.Create_AES192_Enc_Context (Key192);
      for k in Natural range 1 .. 20
      loop
         LSC.Internal.AES.CBC.Encrypt (Context2, IV, Plain, Plain'Length, Cipher2);
      end loop;
      T.Test_Stop := Clock;

      Assert (Cipher1 = Cipher2, "Invalid encryption");

   end Benchmark_AES192_CBC_Encrypt;

   ---------------------------------------------------------------------------

   procedure Benchmark_AES256_Decrypt (T : in out Test_Case'Class)
   is
      subtype Message_Index is Natural range 1 .. 1000;
      subtype Message_Type is LSC.Internal.AES.Message_Type (Message_Index);

      Plain1, Plain2, Cipher  : Message_Type;
      Key256                  : LSC.Internal.AES.AES256_Key_Type;
      Context1                : OpenSSL.AES_Dec_Context_Type;
      Context2                : LSC.Internal.AES.AES_Dec_Context;
   begin

      Cipher := Message_Type'
         (others => LSC.Internal.AES.Block_Type'(16#33221100#,
                                                 16#77665544#,
                                                 16#bbaa9988#,
                                                 16#ffeeddcc#));

      Key256 := LSC.Internal.AES.AES256_Key_Type'(16#03020100#,
                                                  16#07060504#,
                                                  16#0b0a0908#,
                                                  16#0f0e0d0c#,
                                                  16#13121110#,
                                                  16#17161514#,
                                                  16#1b1a1918#,
                                                  16#1f1e1d1c#);

      T.Reference_Start := Clock;
      Context1 := OpenSSL.Create_AES256_Dec_Context (Key256);
      for k in Natural range 1 .. 20
      loop
         for I in Message_Index
         loop
            Plain1 (I) := OpenSSL.Decrypt (Context1, Cipher (I));
         end loop;
      end loop;
      T.Reference_Stop := Clock;

      T.Test_Start := Clock;
      Context2 := LSC.Internal.AES.Create_AES256_Dec_Context (Key256);
      for k in Natural range 1 .. 20
      loop
         for I in Message_Index
         loop
            Plain2 (I) := LSC.Internal.AES.Decrypt (Context2, Cipher (I));
         end loop;
      end loop;
      T.Test_Stop := Clock;

      Assert (Plain1 = Plain2, "Invalid decryption");

   end Benchmark_AES256_Decrypt;

   ---------------------------------------------------------------------------

   procedure Benchmark_AES256_CBC_Decrypt (T : in out Test_Case'Class)
   is
      subtype Message_Index is Natural range 1 .. 1000;
      subtype Message_Type is LSC.Internal.AES.Message_Type (Message_Index);

      Plain1, Plain2, Cipher  : Message_Type;
      Key256                  : LSC.Internal.AES.AES256_Key_Type;
      Context1                : OpenSSL.AES_Dec_Context_Type;
      Context2                : LSC.Internal.AES.AES_Dec_Context;
      IV                      : LSC.Internal.AES.Block_Type;
   begin

      IV := LSC.Internal.AES.Block_Type'
        (16#cafebabe#,
         16#deadbeef#,
         16#d00faffe#,
         16#12345678#);

      Cipher := Message_Type'
         (others => LSC.Internal.AES.Block_Type'(16#33221100#,
                                        16#77665544#,
                                        16#bbaa9988#,
                                        16#ffeeddcc#));

      Key256 := LSC.Internal.AES.AES256_Key_Type'(16#03020100#,
                                                  16#07060504#,
                                                  16#0b0a0908#,
                                                  16#0f0e0d0c#,
                                                  16#13121110#,
                                                  16#17161514#,
                                                  16#1b1a1918#,
                                                  16#1f1e1d1c#);

      T.Reference_Start := Clock;
      Context1 := OpenSSL.Create_AES256_Dec_Context (Key256);
      for k in Natural range 1 .. 20
      loop
         OpenSSL.CBC_Decrypt (Cipher, Plain1, Context1, IV);
      end loop;
      T.Reference_Stop := Clock;

      T.Test_Start := Clock;
      Context2 := LSC.Internal.AES.Create_AES256_Dec_Context (Key256);
      for k in Natural range 1 .. 20
      loop
         LSC.Internal.AES.CBC.Decrypt (Context2, IV, Cipher, Cipher'Length, Plain2);
      end loop;
      T.Test_Stop := Clock;

      Assert (Plain1 = Plain2, "Invalid decryption");

   end Benchmark_AES256_CBC_Decrypt;

   ---------------------------------------------------------------------------

   procedure Benchmark_AES256_Encrypt (T : in out Test_Case'Class)
   is
      subtype Message_Index is Natural range 1 .. 1000;
      subtype Message_Type is LSC.Internal.AES.Message_Type (Message_Index);

      Plain, Cipher1, Cipher2 : Message_Type;
      Key256                  : LSC.Internal.AES.AES256_Key_Type;
      Context1                : OpenSSL.AES_Enc_Context_Type;
      Context2                : LSC.Internal.AES.AES_Enc_Context;
   begin

      Plain := Message_Type'
         (others => LSC.Internal.AES.Block_Type'(16#33221100#,
                                        16#77665544#,
                                        16#bbaa9988#,
                                        16#ffeeddcc#));

      Key256 := LSC.Internal.AES.AES256_Key_Type'(16#03020100#,
                                                  16#07060504#,
                                                  16#0b0a0908#,
                                                  16#0f0e0d0c#,
                                                  16#13121110#,
                                                  16#17161514#,
                                                  16#1b1a1918#,
                                                  16#1f1e1d1c#);

      T.Reference_Start := Clock;
      Context1 := OpenSSL.Create_AES256_Enc_Context (Key256);
      for k in Natural range 1 .. 20
      loop
         for I in Message_Index
         loop
            Cipher1 (I) := OpenSSL.Encrypt (Context1, Plain (I));
         end loop;
      end loop;
      T.Reference_Stop := Clock;

      T.Test_Start := Clock;
      Context2 := LSC.Internal.AES.Create_AES256_Enc_Context (Key256);
      for k in Natural range 1 .. 20
      loop
         for I in Message_Index
         loop
            Cipher2 (I) := LSC.Internal.AES.Encrypt (Context2, Plain (I));
         end loop;
      end loop;
      T.Test_Stop := Clock;

      Assert (Cipher1 = Cipher2, "Invalid encryption");

   end Benchmark_AES256_Encrypt;

   ---------------------------------------------------------------------------

   procedure Benchmark_AES256_CBC_Encrypt (T : in out Test_Case'Class)
   is
      subtype Message_Index is Natural range 1 .. 1000;
      subtype Message_Type is LSC.Internal.AES.Message_Type (Message_Index);

      Plain, Cipher1, Cipher2 : Message_Type;
      Key256                  : LSC.Internal.AES.AES256_Key_Type;
      Context1                : OpenSSL.AES_Enc_Context_Type;
      Context2                : LSC.Internal.AES.AES_Enc_Context;
      IV                      : LSC.Internal.AES.Block_Type;
   begin

      IV := LSC.Internal.AES.Block_Type'
        (16#cafebabe#,
         16#deadbeef#,
         16#d00faffe#,
         16#12345678#);

      Plain := Message_Type'
         (others => LSC.Internal.AES.Block_Type'(16#33221100#,
                                        16#77665544#,
                                        16#bbaa9988#,
                                        16#ffeeddcc#));

      Key256 := LSC.Internal.AES.AES256_Key_Type'(16#03020100#,
                                                  16#07060504#,
                                                  16#0b0a0908#,
                                                  16#0f0e0d0c#,
                                                  16#13121110#,
                                                  16#17161514#,
                                                  16#1b1a1918#,
                                                  16#1f1e1d1c#);

      T.Reference_Start := Clock;
      Context1 := OpenSSL.Create_AES256_Enc_Context (Key256);
      for k in Natural range 1 .. 20
      loop
         OpenSSL.CBC_Encrypt (Plain, Cipher1, Context1, IV);
      end loop;
      T.Reference_Stop := Clock;

      T.Test_Start := Clock;
      Context2 := LSC.Internal.AES.Create_AES256_Enc_Context (Key256);
      for k in Natural range 1 .. 20
      loop
         LSC.Internal.AES.CBC.Encrypt (Context2, IV, Plain, Plain'Length, Cipher2);
      end loop;
      T.Test_Stop := Clock;

      Assert (Cipher1 = Cipher2, "Invalid encryption");

   end Benchmark_AES256_CBC_Encrypt;

   ---------------------------------------------------------------------------

   procedure Benchmark_HMAC_RIPEMD160 (T : in out Test_Case'Class)
   is
      Message : constant OpenSSL.RMD160_Message_Type := OpenSSL.RMD160_Message_Type'
         (others => LSC.Internal.RIPEMD160.Block_Type'(others => 16#dead_beef#));

      Key : constant LSC.Internal.RIPEMD160.Block_Type := LSC.Internal.RIPEMD160.Block_Type'
         (others => 16#c0deaffe#);

      H1 : LSC.Internal.RIPEMD160.Hash_Type;
      H2 : LSC.Internal.RIPEMD160.Hash_Type;
   begin

      T.Reference_Start := Clock;
      for I in Natural range 1 .. 50000
      loop
         H1 := OpenSSL.Authenticate_RMD160 (Key, Message, 10000);
      end loop;
      T.Reference_Stop := Clock;

      T.Test_Start := Clock;
      for I in Natural range 1 .. 50000
      loop
         H2 := LSC.Internal.HMAC_RIPEMD160.Authenticate (Key, Message, 10000);
      end loop;
      T.Test_Stop := Clock;

      Assert (H1 = H2, "Invalid encryption");
   end Benchmark_HMAC_RIPEMD160;

   ---------------------------------------------------------------------------

   procedure Benchmark_HMAC_SHA1 (T : in out Test_Case'Class)
   is
      Message : constant OpenSSL.SHA1_Message_Type := OpenSSL.SHA1_Message_Type'
        (others => LSC.Internal.SHA1.Block_Type'(others => 16#dead_beef#));

      Key     : constant LSC.Internal.SHA1.Block_Type := LSC.Internal.SHA1.Block_Type'(others => 16#c0deaffe#);

      H1      : LSC.Internal.SHA1.Hash_Type;
      H2      : LSC.Internal.SHA1.Hash_Type;
   begin

      T.Reference_Start := Clock;
      for I in Natural range 1 .. 50000
      loop
         H1 := OpenSSL.Authenticate_SHA1 (Key, Message, 10000);
      end loop;
      T.Reference_Stop := Clock;

      T.Test_Start := Clock;
      for I in Natural range 1 .. 50000
      loop
         H2 := LSC.Internal.HMAC_SHA1.Authenticate (Key, Message, 10000);
      end loop;
      T.Test_Stop := Clock;

      Assert (H1 = H2, "Invalid encryption");
   end Benchmark_HMAC_SHA1;

   ---------------------------------------------------------------------------

   procedure Benchmark_HMAC_SHA256 (T : in out Test_Case'Class)
   is
      use type LSC.Internal.SHA256.Message_Index;
      use type Interfaces.Unsigned_64;
      Message : constant OpenSSL.SHA256_Message_Type := OpenSSL.SHA256_Message_Type'
         (others => LSC.Internal.SHA256.Block_Type'(others => 16#dead_beef#));

      Key : constant LSC.Internal.SHA256.Block_Type := LSC.Internal.SHA256.Block_Type'
         (others => 16#c0deaffe#);

      H1 : LSC.Internal.HMAC_SHA256.Auth_Type;
      H2 : LSC.Internal.HMAC_SHA256.Auth_Type;
   begin

      T.Reference_Start := Clock;
      for I in Natural range 1 .. 50000
      loop
         H1 := OpenSSL.Authenticate_SHA256 (Key, Message, Message'Size / 8);
      end loop;
      T.Reference_Stop := Clock;

      T.Test_Start := Clock;
      for I in Natural range 1 .. 50000
      loop
         H2 := LSC.Internal.HMAC_SHA256.Authenticate (Key, Message, Message'Size / 8);
      end loop;
      T.Test_Stop := Clock;

      Assert (H1 = H2, "Invalid encryption");
   end Benchmark_HMAC_SHA256;

   ---------------------------------------------------------------------------

   procedure Benchmark_HMAC_SHA384 (T : in out Test_Case'Class)
   is
      use type LSC.Internal.SHA512.Message_Index;
      use type Interfaces.Unsigned_64;
      Message : constant OpenSSL.SHA512_Message_Type := OpenSSL.SHA512_Message_Type'
         (others => LSC.Internal.SHA512.Block_Type'(others => 16#dead_beef_dead_c0de#));

      Key : constant LSC.Internal.SHA512.Block_Type := LSC.Internal.SHA512.Block_Type'
         (others => 16#c0de_affe_cafe_babe#);

      H1 : LSC.Internal.HMAC_SHA384.Auth_Type;
      H2 : LSC.Internal.HMAC_SHA384.Auth_Type;
   begin

      T.Reference_Start := Clock;
      for I in Natural range 1 .. 50000
      loop
         H1 := OpenSSL.Authenticate_SHA384 (Key, Message, Message'Size / 8);
      end loop;
      T.Reference_Stop := Clock;

      T.Test_Start := Clock;
      for I in Natural range 1 .. 50000
      loop
         H2 := LSC.Internal.HMAC_SHA384.Authenticate (Key, Message, Message'Size / 8);
      end loop;
      T.Test_Stop := Clock;

      Assert (H1 = H2, "Invalid encryption");
   end Benchmark_HMAC_SHA384;

   ---------------------------------------------------------------------------

   procedure Benchmark_HMAC_SHA512 (T : in out Test_Case'Class)
   is
      use type LSC.Internal.SHA512.Message_Index;
      use type Interfaces.Unsigned_64;
      Message : constant OpenSSL.SHA512_Message_Type := OpenSSL.SHA512_Message_Type'
         (others => LSC.Internal.SHA512.Block_Type'(others => 16#dead_beef_dead_c0de#));

      Key : constant LSC.Internal.SHA512.Block_Type := LSC.Internal.SHA512.Block_Type'
         (others => 16#c0de_affe_cafe_babe#);

      H1 : LSC.Internal.HMAC_SHA512.Auth_Type;
      H2 : LSC.Internal.HMAC_SHA512.Auth_Type;
   begin

      T.Reference_Start := Clock;
      for I in Natural range 1 .. 50000
      loop
         H1 := OpenSSL.Authenticate_SHA512 (Key, Message, Message'Size / 8);
      end loop;
      T.Reference_Stop := Clock;

      T.Test_Start := Clock;
      for I in Natural range 1 .. 50000
      loop
         H2 := LSC.Internal.HMAC_SHA512.Authenticate (Key, Message, Message'Size / 8);
      end loop;
      T.Test_Stop := Clock;

      Assert (H1 = H2, "Invalid encryption");
   end Benchmark_HMAC_SHA512;

   ---------------------------------------------------------------------------

   procedure Benchmark_Bignum_RSA2048 (T : in out Test_Case'Class)
   is
      Window_Size : constant := 5;

      subtype Mod_Range_Small is Natural range 0 .. 63;
      subtype Mod_Range is Natural range 0 .. 127;
      subtype Pub_Exp_Range is Natural range 0 .. 0;
      subtype Window_Aux_Range is Natural range 0 .. 128 * (2 ** Window_Size) - 1;

      subtype LInt_Small is LSC.Internal.Bignum.Big_Int (Mod_Range_Small);
      subtype LInt is LSC.Internal.Bignum.Big_Int (Mod_Range);
      subtype SInt is LSC.Internal.Bignum.Big_Int (Pub_Exp_Range);
      subtype Window_Aux is LSC.Internal.Bignum.Big_Int (Window_Aux_Range);

      Pub_Exp : constant SInt := SInt'(0 => 16#00010001#);

      --  2048 bit

      Modulus_Small : constant LInt_Small := LInt_Small'
        (16#e3855b7b#, 16#695e1d0c#, 16#2f3a389f#, 16#e4e8cfbc#, 16#366c3c0b#,
         16#07f34b0d#, 16#a92ff519#, 16#566a909a#, 16#d79ecc36#, 16#e392c334#,
         16#dbbb737f#, 16#80c97ddd#, 16#812a798c#, 16#0fdf31b2#, 16#c9c3978b#,
         16#f526906b#, 16#cf23d190#, 16#ea1e08a2#, 16#08cf9c02#, 16#b3b794fb#,
         16#7855c403#, 16#49b10dd8#, 16#6ca17d12#, 16#b069b1ab#, 16#b8d28b35#,
         16#a08d0a13#, 16#1a1bf74d#, 16#30ca19b3#, 16#29e5abd7#, 16#4ccb0a06#,
         16#7bae2533#, 16#fc040833#, 16#2c1c80c5#, 16#ea729a13#, 16#ac5ffd04#,
         16#a2dcc2f9#, 16#c1f9c72c#, 16#f466adf6#, 16#ea152c47#, 16#42d76640#,
         16#8b5c067a#, 16#8c870d16#, 16#d3dacf2f#, 16#df33c327#, 16#fdddf873#,
         16#592c3110#, 16#a94e6415#, 16#6b0f63f4#, 16#84919783#, 16#da1672d1#,
         16#6d2b736e#, 16#3c02711d#, 16#eba01b1d#, 16#04463ba8#, 16#a8f0f41b#,
         16#d41c9a16#, 16#2e0a1c54#, 16#e8340e9b#, 16#0194cdee#, 16#4beacec6#,
         16#e23ee4a4#, 16#ec602901#, 16#079751bd#, 16#Dad31766#);

      Priv_Exp_Small : constant LInt_Small := LInt_Small'
        (16#3fd9f299#, 16#64a02913#, 16#780db9d7#, 16#164c83cd#, 16#70ac88cc#,
         16#14e9bfcc#, 16#bff4fa46#, 16#a2956db0#, 16#d5952d92#, 16#d8e23b1b#,
         16#d252925c#, 16#f63f2570#, 16#1232a957#, 16#0ecdf6fc#, 16#23356dd5#,
         16#6dfd8463#, 16#b88e9193#, 16#3e337443#, 16#c30bd004#, 16#f86471bc#,
         16#26836b1f#, 16#36792ee7#, 16#fd7774c3#, 16#e947afe5#, 16#403e454e#,
         16#60886c2f#, 16#7da04cab#, 16#0006c1c8#, 16#87bfa8cc#, 16#c644e026#,
         16#8eea8cce#, 16#beca39f9#, 16#60c3808d#, 16#2faf499f#, 16#c81d0c50#,
         16#ef2e6e1b#, 16#ae3dbc3f#, 16#54a6e7b8#, 16#efdc4e55#, 16#e0ed4e41#,
         16#6ddee985#, 16#2c988959#, 16#2bdbffad#, 16#ec9c5635#, 16#a6ad3fef#,
         16#5df1f2a6#, 16#e4ec57d3#, 16#1c823145#, 16#eecff08e#, 16#51b9f682#,
         16#c8ec37a1#, 16#1212a615#, 16#9265aeed#, 16#4b4e2491#, 16#2b29d53a#,
         16#2bd57be9#, 16#ffd21ce0#, 16#bccc6401#, 16#e2d6c019#, 16#c98b2771#,
         16#4d4cde01#, 16#d507d875#, 16#886bab53#, 16#7cac4629#);

      Aux1, Aux2, Aux3, R : LInt;
      Aux4 : Window_Aux;
      M_Inv : LSC.Internal.Types.Word32;

      Plain1_Small, OpenSSL_Plain1_Small : LInt_Small;
      Plain2_Small, Plain3_Small, OpenSSL_Plain2_Small : LInt_Small;
      Cipher1_Small, Cipher2_Small, OpenSSL_Cipher_Small : LInt_Small;
      OpenSSL_Modulus_Small, OpenSSL_Priv_Exp_Small : LInt_Small;

      OpenSSL_Pub_Exp : SInt;

      Success_Enc, Success_Dec : Boolean;
   begin
      LSC.Internal.Bignum.Native_To_BE
        (Pub_Exp, Pub_Exp'First, Pub_Exp'Last,
         OpenSSL_Pub_Exp, OpenSSL_Pub_Exp'First);

      --  2048 bit

      --  Create original data
      for I in Natural range Modulus_Small'Range
      loop
         Plain1_Small (I) := LSC.Internal.Types.Word32 (I);
      end loop;

      --  Convert modulus, exponent and plaintext to format expected by OpenSSL
      LSC.Internal.Bignum.Native_To_BE
        (Priv_Exp_Small, Priv_Exp_Small'First, Priv_Exp_Small'Last,
         OpenSSL_Priv_Exp_Small, OpenSSL_Priv_Exp_Small'First);

      LSC.Internal.Bignum.Native_To_BE
        (Modulus_Small, Modulus_Small'First, Modulus_Small'Last,
         OpenSSL_Modulus_Small, OpenSSL_Modulus_Small'First);

      LSC.Internal.Bignum.Native_To_BE
        (Plain1_Small, Plain1_Small'First, Plain1_Small'Last,
         OpenSSL_Plain1_Small, OpenSSL_Plain1_Small'First);

      T.Reference_Start := Clock;

      OpenSSL.RSA_Public_Encrypt
        (OpenSSL_Modulus_Small,
         OpenSSL_Pub_Exp,
         OpenSSL_Plain1_Small,
         OpenSSL_Cipher_Small,
         Success_Enc);

      OpenSSL.RSA_Private_Decrypt
        (OpenSSL_Modulus_Small,
         OpenSSL_Pub_Exp,
         OpenSSL_Priv_Exp_Small,
         OpenSSL_Cipher_Small,
         OpenSSL_Plain2_Small,
         Success_Dec);

      T.Reference_Stop := Clock;

      LSC.Internal.Bignum.Native_To_BE
        (OpenSSL_Cipher_Small, OpenSSL_Cipher_Small'First, OpenSSL_Cipher_Small'Last,
         Cipher2_Small, Cipher2_Small'First);

      LSC.Internal.Bignum.Native_To_BE
        (OpenSSL_Plain2_Small, OpenSSL_Plain2_Small'First, OpenSSL_Plain2_Small'Last,
         Plain3_Small, Plain3_Small'First);

      --  Precompute R^2 mod m
      LSC.Internal.Bignum.Size_Square_Mod
        (M       => Modulus_Small,
         M_First => Modulus_Small'First,
         M_Last  => Modulus_Small'Last,
         R       => R,
         R_First => R'First);

      --  Precompute inverse
      M_Inv := LSC.Internal.Bignum.Word_Inverse (Modulus_Small (Modulus_Small'First));

      T.Test_Start := Clock;

      --  Encrypt
      LSC.Internal.Bignum.Mont_Exp_Window
        (A          => Cipher1_Small,
         A_First    => Cipher1_Small'First,
         A_Last     => Cipher1_Small'Last,
         X          => Plain1_Small,
         X_First    => Plain1_Small'First,
         E          => Pub_Exp,
         E_First    => Pub_Exp'First,
         E_Last     => Pub_Exp'Last,
         M          => Modulus_Small,
         M_First    => Modulus_Small'First,
         K          => Window_Size,
         Aux1       => Aux1,
         Aux1_First => Aux1'First,
         Aux2       => Aux2,
         Aux2_First => Aux2'First,
         Aux3       => Aux3,
         Aux3_First => Aux3'First,
         Aux4       => Aux4,
         Aux4_First => Aux4'First,
         R          => R,
         R_First    => R'First,
         M_Inv      => M_Inv);

      --  Decrypt
      LSC.Internal.Bignum.Mont_Exp_Window
        (A          => Plain2_Small,
         A_First    => Plain2_Small'First,
         A_Last     => Plain2_Small'Last,
         X          => Cipher1_Small,
         X_First    => Cipher1_Small'First,
         E          => Priv_Exp_Small,
         E_First    => Priv_Exp_Small'First,
         E_Last     => Priv_Exp_Small'Last,
         M          => Modulus_Small,
         M_First    => Modulus_Small'First,
         K          => Window_Size,
         Aux1       => Aux1,
         Aux1_First => Aux1'First,
         Aux2       => Aux2,
         Aux2_First => Aux2'First,
         Aux3       => Aux3,
         Aux3_First => Aux3'First,
         Aux4       => Aux4,
         Aux4_First => Aux4'First,
         R          => R,
         R_First    => R'First,
         M_Inv      => M_Inv);

      T.Test_Stop := Clock;

      Assert
        (Success_Enc and then Success_Dec and then
         Cipher1_Small = Cipher2_Small and then
         Plain1_Small = Plain2_Small and then
         Plain2_Small = Plain3_Small, "Invalid RSA");

   end Benchmark_Bignum_RSA2048;

   ---------------------------------------------------------------------------

   procedure Benchmark_Bignum_RSA4096 (T : in out Test_Case'Class)
   is
      Window_Size : constant := 5;

      subtype Mod_Range is Natural range 0 .. 127;
      subtype Pub_Exp_Range is Natural range 0 .. 0;
      subtype Window_Aux_Range is Natural range 0 .. 128 * (2 ** Window_Size) - 1;

      subtype LInt is LSC.Internal.Bignum.Big_Int (Mod_Range);
      subtype SInt is LSC.Internal.Bignum.Big_Int (Pub_Exp_Range);
      subtype Window_Aux is LSC.Internal.Bignum.Big_Int (Window_Aux_Range);

      Pub_Exp : constant SInt := SInt'(0 => 16#00010001#);

      Modulus : constant LInt := LInt'
        (16#27a3f371#, 16#f66dc29e#, 16#2c4cf251#, 16#0aa490b7#, 16#2eabfddb#,
         16#4e6d1cc7#, 16#e67fc1bb#, 16#be3cc1e1#, 16#4338d3ae#, 16#372d809a#,
         16#b9d33026#, 16#e3d05bff#, 16#886580b8#, 16#020b3b03#, 16#55c15179#,
         16#a3c026b2#, 16#3e550dcb#, 16#821fcfee#, 16#4f44c3f9#, 16#25c8b0a5#,
         16#30612a20#, 16#8c970432#, 16#32e395aa#, 16#1337a822#, 16#3db2c677#,
         16#35a256d5#, 16#fcbf1cfc#, 16#6354fbe1#, 16#8d0874a2#, 16#a017fe19#,
         16#07f415fc#, 16#e0a45678#, 16#c3e2f1c3#, 16#4b73d538#, 16#962f1c1c#,
         16#448f15fb#, 16#d4ba9b05#, 16#9f6cc819#, 16#f36d2a06#, 16#d1c1d04a#,
         16#efb31b76#, 16#c7cae1cf#, 16#e61520e4#, 16#984ec779#, 16#56f79b73#,
         16#2f8ca314#, 16#a0c4e830#, 16#2e3eba5b#, 16#f739a437#, 16#7852b71e#,
         16#aab09aa6#, 16#3d8dcdc3#, 16#f16ab197#, 16#8b3753d1#, 16#ec52c4e1#,
         16#f70e4f7d#, 16#b4af5c60#, 16#82ae6ca4#, 16#fa6a8a1d#, 16#5655c33d#,
         16#5096b17f#, 16#71c61b6a#, 16#28c84e83#, 16#07a0f985#, 16#b5523b0c#,
         16#d31e75f6#, 16#c8139152#, 16#c94fb87f#, 16#d0d092c4#, 16#b5bae11d#,
         16#3ebaa999#, 16#599cd667#, 16#a156c841#, 16#88a90d02#, 16#73e10c30#,
         16#56b72050#, 16#1cb3c2d9#, 16#abef5973#, 16#8f42b61a#, 16#e54c7b3c#,
         16#0b93bb83#, 16#5ca62bc2#, 16#1a9996a5#, 16#26b48d1b#, 16#98f932d1#,
         16#3f56babe#, 16#dab5a0eb#, 16#4e0de31d#, 16#4bbe26d4#, 16#2812c4f8#,
         16#f6d1866c#, 16#6800ef71#, 16#49cca290#, 16#aa1bbdee#, 16#ee8a75ea#,
         16#4fc8516b#, 16#242c7f52#, 16#96df15ea#, 16#eaac1b33#, 16#c533d8fa#,
         16#a649ef23#, 16#7d29eebb#, 16#8342ce68#, 16#36abe9c0#, 16#82adff4d#,
         16#8fcc54b0#, 16#89144572#, 16#09dfcece#, 16#bcc22be3#, 16#b2184072#,
         16#cf2cf6c3#, 16#dbb62eeb#, 16#9c44b29b#, 16#08dea7eb#, 16#8a92c57e#,
         16#4ed90ea9#, 16#a73379d1#, 16#20767c8f#, 16#bcc1a56d#, 16#6fa7e726#,
         16#d74d548d#, 16#ec21f388#, 16#a2344841#, 16#8b08a316#, 16#c99b8d76#,
         16#d670befe#, 16#31a09763#, 16#d0055749#);

      Priv_Exp : constant LInt := LInt'
        (16#2e274601#, 16#8fab5c50#, 16#48b5239e#, 16#5a37865c#, 16#5670b41d#,
         16#2da87796#, 16#3a82b988#, 16#7a7ce911#, 16#bd4e57b1#, 16#8f6d3da4#,
         16#8669e6a0#, 16#3314c3e7#, 16#36248f99#, 16#4b3e25a7#, 16#600a6f7f#,
         16#04eafed8#, 16#45050c07#, 16#f32daf96#, 16#6b6b4f21#, 16#cd177764#,
         16#e4d13b46#, 16#80f34af3#, 16#1f601841#, 16#65bf67b8#, 16#33729106#,
         16#56b14c9d#, 16#267c46be#, 16#d4acf88c#, 16#fc8ec97e#, 16#06d4df7e#,
         16#198ec5fb#, 16#a098a033#, 16#c7dcc150#, 16#dc980d3f#, 16#29778f62#,
         16#29f4cbca#, 16#e6d86584#, 16#9e366a7a#, 16#b39ab77a#, 16#1a956df3#,
         16#da64c05b#, 16#6f4183a2#, 16#452ad7db#, 16#84d1f44e#, 16#88c4a697#,
         16#d272546e#, 16#c0f5da10#, 16#dca7e68b#, 16#2316a1e5#, 16#93305fcd#,
         16#10a0897b#, 16#e203fc89#, 16#163ef9fa#, 16#a3625c15#, 16#9719bace#,
         16#c5bd6a66#, 16#466893e9#, 16#eb33cb36#, 16#ff6854e6#, 16#f8cf002f#,
         16#5c84f1a6#, 16#f9d89029#, 16#a42c2f21#, 16#7c29e8b3#, 16#07188900#,
         16#37a9da54#, 16#672715c3#, 16#ab9b69ac#, 16#2a32533c#, 16#592932ba#,
         16#90843f00#, 16#4f540d7d#, 16#44f04b78#, 16#efeab1d4#, 16#bc5e76db#,
         16#cd5bd78b#, 16#0eb2723f#, 16#bd633630#, 16#90bf30be#, 16#0023372e#,
         16#5d50308b#, 16#4cbf539a#, 16#1abb5b44#, 16#30cc98de#, 16#869b24e0#,
         16#78bda399#, 16#25e6f54c#, 16#96dac865#, 16#8db1dc73#, 16#770a4d97#,
         16#31123fee#, 16#139ea6d0#, 16#786e32b2#, 16#f3998ab6#, 16#5fd4f43b#,
         16#ae506344#, 16#797f633d#, 16#81682a87#, 16#9b5cb744#, 16#a40a97e5#,
         16#e788eed8#, 16#5c2b1448#, 16#90780722#, 16#77af3218#, 16#66114d4f#,
         16#8857c6c0#, 16#9899ef8a#, 16#dea4d612#, 16#f5986865#, 16#41b3caca#,
         16#ebace112#, 16#1678338c#, 16#34e40889#, 16#3291e166#, 16#3f855200#,
         16#e81eddcb#, 16#b08e2e77#, 16#238ac815#, 16#d2442787#, 16#bb20cea2#,
         16#c4ae4e94#, 16#b575336a#, 16#cd55d286#, 16#e7387f77#, 16#a780f030#,
         16#46526c31#, 16#0e4752a9#, 16#9b036fe1#);

      Aux1, Aux2, Aux3, R : LInt;
      Aux4 : Window_Aux;
      M_Inv : LSC.Internal.Types.Word32;

      Plain1, OpenSSL_Plain1 : LInt;
      Plain2, Plain3, OpenSSL_Plain2 : LInt;
      Cipher1, Cipher2, OpenSSL_Cipher : LInt;
      OpenSSL_Modulus, OpenSSL_Priv_Exp : LInt;

      OpenSSL_Pub_Exp : SInt;

      Success_Enc, Success_Dec : Boolean;
   begin
      LSC.Internal.Bignum.Native_To_BE
        (Pub_Exp, Pub_Exp'First, Pub_Exp'Last,
         OpenSSL_Pub_Exp, OpenSSL_Pub_Exp'First);

      --  Create original data
      for I in Natural range Modulus'Range
      loop
         Plain1 (I) := LSC.Internal.Types.Word32 (I);
      end loop;

      --  Convert modulus, exponent and plaintext to format expected by OpenSSL
      LSC.Internal.Bignum.Native_To_BE
        (Priv_Exp, Priv_Exp'First, Priv_Exp'Last,
         OpenSSL_Priv_Exp, OpenSSL_Priv_Exp'First);

      LSC.Internal.Bignum.Native_To_BE
        (Modulus, Modulus'First, Modulus'Last,
         OpenSSL_Modulus, OpenSSL_Modulus'First);

      LSC.Internal.Bignum.Native_To_BE
        (Plain1, Plain1'First, Plain1'Last,
         OpenSSL_Plain1, OpenSSL_Plain1'First);

      T.Reference_Start := Clock;

      OpenSSL.RSA_Public_Encrypt
        (OpenSSL_Modulus,
         OpenSSL_Pub_Exp,
         OpenSSL_Plain1,
         OpenSSL_Cipher,
         Success_Enc);

      OpenSSL.RSA_Private_Decrypt
        (OpenSSL_Modulus,
         OpenSSL_Pub_Exp,
         OpenSSL_Priv_Exp,
         OpenSSL_Cipher,
         OpenSSL_Plain2,
         Success_Dec);

      T.Reference_Stop := Clock;

      LSC.Internal.Bignum.Native_To_BE
        (OpenSSL_Cipher, OpenSSL_Cipher'First, OpenSSL_Cipher'Last,
         Cipher2, Cipher2'First);

      LSC.Internal.Bignum.Native_To_BE
        (OpenSSL_Plain2, OpenSSL_Plain2'First, OpenSSL_Plain2'Last,
         Plain3, Plain3'First);

      --  Precompute R^2 mod m
      LSC.Internal.Bignum.Size_Square_Mod
        (M       => Modulus,
         M_First => Modulus'First,
         M_Last  => Modulus'Last,
         R       => R,
         R_First => R'First);

      --  Precompute inverse
      M_Inv := LSC.Internal.Bignum.Word_Inverse (Modulus (Modulus'First));

      T.Test_Start := Clock;

      --  Encrypt
      LSC.Internal.Bignum.Mont_Exp_Window
        (A          => Cipher1,
         A_First    => Cipher1'First,
         A_Last     => Cipher1'Last,
         X          => Plain1,
         X_First    => Plain1'First,
         E          => Pub_Exp,
         E_First    => Pub_Exp'First,
         E_Last     => Pub_Exp'Last,
         M          => Modulus,
         M_First    => Modulus'First,
         K          => Window_Size,
         Aux1       => Aux1,
         Aux1_First => Aux1'First,
         Aux2       => Aux2,
         Aux2_First => Aux2'First,
         Aux3       => Aux3,
         Aux3_First => Aux3'First,
         Aux4       => Aux4,
         Aux4_First => Aux4'First,
         R          => R,
         R_First    => R'First,
         M_Inv      => M_Inv);

      --  Decrypt
      LSC.Internal.Bignum.Mont_Exp_Window
        (A          => Plain2,
         A_First    => Plain2'First,
         A_Last     => Plain2'Last,
         X          => Cipher1,
         X_First    => Cipher1'First,
         E          => Priv_Exp,
         E_First    => Priv_Exp'First,
         E_Last     => Priv_Exp'Last,
         M          => Modulus,
         M_First    => Modulus'First,
         K          => Window_Size,
         Aux1       => Aux1,
         Aux1_First => Aux1'First,
         Aux2       => Aux2,
         Aux2_First => Aux2'First,
         Aux3       => Aux3,
         Aux3_First => Aux3'First,
         Aux4       => Aux4,
         Aux4_First => Aux4'First,
         R          => R,
         R_First    => R'First,
         M_Inv      => M_Inv);

      T.Test_Stop := Clock;

      Assert
        (Success_Enc and then Success_Dec and then
         Cipher1 = Cipher2 and then
         Plain1 = Plain2 and then
         Plain2 = Plain3, "Invalid RSA");

   end Benchmark_Bignum_RSA4096;

   ---------------------------------------------------------------------------

   procedure Register_Tests (T : in out Test_Case) is
      package Registration is new
         AUnit.Test_Cases.Specific_Test_Case_Registration (Test_Case);
      use Registration;
   begin
      Register_Wrapper (T, Benchmark_RIPEMD160'Access, "RIPEMD160");
      Register_Wrapper (T, Benchmark_SHA1'Access, "SHA1");
      Register_Wrapper (T, Benchmark_SHA256'Access, "SHA256");
      Register_Wrapper (T, Benchmark_SHA384'Access, "SHA384");
      Register_Wrapper (T, Benchmark_SHA512'Access, "SHA512");
      Register_Wrapper (T, Benchmark_AES128_Decrypt'Access, "AES128 (decrypt)");
      Register_Wrapper (T, Benchmark_AES128_CBC_Decrypt'Access, "AES128 CBC (decrypt)");
      Register_Wrapper (T, Benchmark_AES128_Encrypt'Access, "AES128 (encrypt)");
      Register_Wrapper (T, Benchmark_AES128_CBC_Encrypt'Access, "AES128 CBC (encrypt)");
      Register_Wrapper (T, Benchmark_AES192_Decrypt'Access, "AES192 (decrypt)");
      Register_Wrapper (T, Benchmark_AES192_CBC_Decrypt'Access, "AES192 CBC (decrypt)");
      Register_Wrapper (T, Benchmark_AES192_Encrypt'Access, "AES192 (encrypt)");
      Register_Wrapper (T, Benchmark_AES192_CBC_Encrypt'Access, "AES192 CBC (encrypt)");
      Register_Wrapper (T, Benchmark_AES256_Decrypt'Access, "AES256 (decrypt)");
      Register_Wrapper (T, Benchmark_AES256_CBC_Decrypt'Access, "AES256 CBC (decrypt)");
      Register_Wrapper (T, Benchmark_AES256_Encrypt'Access, "AES256 (encrypt)");
      Register_Wrapper (T, Benchmark_AES256_CBC_Encrypt'Access, "AES256 CBC (encrypt)");
      Register_Wrapper (T, Benchmark_HMAC_RIPEMD160'Access, "HMAC (RIPEMD160)");
      Register_Wrapper (T, Benchmark_HMAC_SHA1'Access, "HMAC (SHA1)");
      Register_Wrapper (T, Benchmark_HMAC_SHA256'Access, "HMAC (SHA256)");
      Register_Wrapper (T, Benchmark_HMAC_SHA384'Access, "HMAC (SHA384)");
      Register_Wrapper (T, Benchmark_HMAC_SHA512'Access, "HMAC (SHA512)");
      Register_Wrapper (T, Benchmark_Bignum_RSA2048'Access, "Bignum (2048)");
      Register_Wrapper (T, Benchmark_Bignum_RSA4096'Access, "Bignum (4096)");
   end Register_Tests;

   ---------------------------------------------------------------------------

   function Name (T : Test_Case) return Test_String is
   begin
      pragma Unreferenced (T);
      return Format ("Benchmark");
   end Name;

end LSC_Internal_Benchmark;
