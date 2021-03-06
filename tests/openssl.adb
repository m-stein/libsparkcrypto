-------------------------------------------------------------------------------
--  This file is part of libsparkcrypto.
--
--  Copyright (C) 2010, Alexander Senier
--  Copyright (C) 2010, secunet Security Networks AG
--  All rights reserved.
--
--  Redistribution  and  use  in  source  and  binary  forms,  with  or  without
--  modification, are permitted provided that the following conditions are met:
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
--  THIS SOFTWARE IS PROVIDED BY THE  COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
--  AND ANY  EXPRESS OR IMPLIED WARRANTIES,  INCLUDING, BUT NOT LIMITED  TO, THE
--  IMPLIED WARRANTIES OF  MERCHANTABILITY AND FITNESS FOR  A PARTICULAR PURPOSE
--  ARE  DISCLAIMED. IN  NO EVENT  SHALL  THE COPYRIGHT  HOLDER OR  CONTRIBUTORS
--  BE  LIABLE FOR  ANY  DIRECT, INDIRECT,  INCIDENTAL,  SPECIAL, EXEMPLARY,  OR
--  CONSEQUENTIAL  DAMAGES  (INCLUDING,  BUT  NOT  LIMITED  TO,  PROCUREMENT  OF
--  SUBSTITUTE GOODS  OR SERVICES; LOSS  OF USE,  DATA, OR PROFITS;  OR BUSINESS
--  INTERRUPTION)  HOWEVER CAUSED  AND ON  ANY THEORY  OF LIABILITY,  WHETHER IN
--  CONTRACT,  STRICT LIABILITY,  OR  TORT (INCLUDING  NEGLIGENCE OR  OTHERWISE)
--  ARISING IN ANY WAY  OUT OF THE USE OF THIS SOFTWARE, EVEN  IF ADVISED OF THE
--  POSSIBILITY OF SUCH DAMAGE.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
--  ATTENTION: READ THE WARNING IN THE HEADER OF THE SPEC FILE!
-------------------------------------------------------------------------------
package body OpenSSL is

   ----------------------------------------------------------------------------
   --  AES
   ----------------------------------------------------------------------------

   function Create_AES128_Enc_Context (Key : LSC.Internal.AES.AES128_Key_Type)
      return AES_Enc_Context_Type
   is
      Result : C_Context_Type;
   begin
      C_AES_set_encrypt_key (UserKey => Key'Unrestricted_Access,
                             Bits    => 128,
                             AESKey  => Result'Unrestricted_Access);
      return AES_Enc_Context_Type'(C_Context => Result);
   end Create_AES128_Enc_Context;

   ----------------------------------------------------------------------------

   function Create_AES192_Enc_Context (Key : LSC.Internal.AES.AES192_Key_Type)
       return AES_Enc_Context_Type
   is
      Result : C_Context_Type;
   begin
      C_AES_set_encrypt_key (UserKey => Key'Unrestricted_Access,
                             Bits    => 192,
                             AESKey  => Result'Unrestricted_Access);
      return AES_Enc_Context_Type'(C_Context => Result);
   end Create_AES192_Enc_Context;

   ----------------------------------------------------------------------------

   function Create_AES256_Enc_Context (Key : LSC.Internal.AES.AES256_Key_Type)
      return AES_Enc_Context_Type
   is
      Result : C_Context_Type;
   begin
      C_AES_set_encrypt_key (UserKey => Key'Unrestricted_Access,
                             Bits    => 256,
                             AESKey  => Result'Unrestricted_Access);
      return AES_Enc_Context_Type'(C_Context => Result);
   end Create_AES256_Enc_Context;

   ----------------------------------------------------------------------------

   function Encrypt (Context   : AES_Enc_Context_Type;
                     Plaintext : LSC.Internal.AES.Block_Type) return LSC.Internal.AES.Block_Type
   is
      Result : LSC.Internal.AES.Block_Type;
   begin
      C_AES_encrypt (In_Block  => Plaintext'Unrestricted_Access,
                     Out_Block => Result'Unrestricted_Access,
                     AESKey    => Context.C_Context'Unrestricted_Access);
      return Result;
   end Encrypt;

   ----------------------------------------------------------------------------

   procedure CBC_Encrypt
     (Plaintext  : in     LSC.Internal.AES.Message_Type;
      Ciphertext :    out LSC.Internal.AES.Message_Type;
      Context    : in     AES_Enc_Context_Type;
      IV         : in     LSC.Internal.AES.Block_Type)
   is
      Tmp_IV : LSC.Internal.AES.Block_Type := IV;
   begin
      C_AES_CBC_Encrypt
        (Input  => Plaintext'Address,
         Output => Ciphertext'Address,
         Length => 16 * Plaintext'Length,
         AESKey => Context.C_Context'Unrestricted_Access,
         IV     => Tmp_IV'Unrestricted_Access,
         Enc    => 1);
   end CBC_Encrypt;

   ----------------------------------------------------------------------------

   function Create_AES128_Dec_Context (Key : LSC.Internal.AES.AES128_Key_Type)
      return AES_Dec_Context_Type
   is
      Result : C_Context_Type;
   begin
      C_AES_set_decrypt_key (UserKey => Key'Unrestricted_Access,
                             Bits    => 128,
                             AESKey  => Result'Unrestricted_Access);
      return AES_Dec_Context_Type'(C_Context => Result);
   end Create_AES128_Dec_Context;

   ----------------------------------------------------------------------------

   function Create_AES192_Dec_Context (Key : LSC.Internal.AES.AES192_Key_Type)
       return AES_Dec_Context_Type
   is
      Result : C_Context_Type;
   begin
      C_AES_set_decrypt_key (UserKey => Key'Unrestricted_Access,
                             Bits    => 192,
                             AESKey  => Result'Unrestricted_Access);
      return AES_Dec_Context_Type'(C_Context => Result);
   end Create_AES192_Dec_Context;

   ----------------------------------------------------------------------------

   function Create_AES256_Dec_Context (Key : LSC.Internal.AES.AES256_Key_Type)
      return AES_Dec_Context_Type
   is
      Result : C_Context_Type;
   begin
      C_AES_set_decrypt_key (UserKey => Key'Unrestricted_Access,
                             Bits    => 256,
                             AESKey  => Result'Unrestricted_Access);
      return AES_Dec_Context_Type'(C_Context => Result);
   end Create_AES256_Dec_Context;

   ----------------------------------------------------------------------------

   function Decrypt (Context    : AES_Dec_Context_Type;
                     Ciphertext : LSC.Internal.AES.Block_Type) return LSC.Internal.AES.Block_Type
   is
      Result : LSC.Internal.AES.Block_Type;
   begin
      C_AES_decrypt (In_Block  => Ciphertext'Unrestricted_Access,
                     Out_Block => Result'Unrestricted_Access,
                     AESKey    => Context.C_Context'Unrestricted_Access);
      return Result;
   end Decrypt;

   ----------------------------------------------------------------------------

   procedure CBC_Decrypt
     (Ciphertext : in     LSC.Internal.AES.Message_Type;
      Plaintext  :    out LSC.Internal.AES.Message_Type;
      Context    : in     AES_Dec_Context_Type;
      IV         : in     LSC.Internal.AES.Block_Type)
   is
      Tmp_IV : LSC.Internal.AES.Block_Type := IV;
   begin
      C_AES_CBC_Encrypt
        (Input  => Ciphertext'Address,
         Output => Plaintext'Address,
         Length => 16 * Ciphertext'Length,
         AESKey => Context.C_Context'Unrestricted_Access,
         IV     => Tmp_IV'Unrestricted_Access,
         Enc    => 0);
   end CBC_Decrypt;

   ----------------------------------------------------------------------------
   --  SHA-1
   ----------------------------------------------------------------------------

   procedure SHA1_Context_Init (Context :    out SHA1_Context_Type)
   is
   begin
      OpenSSL.C_SHA1_Init (Context.C_Context'Unrestricted_Access);
   end SHA1_Context_Init;

   ----------------------------------------------------------------------------

   procedure SHA1_Context_Update
     (Context : in out SHA1_Context_Type;
      Block   : in     LSC.Internal.SHA1.Block_Type)
   is
   begin
      OpenSSL.C_SHA1_Update (Context.C_Context'Unrestricted_Access,
                             Block'Unrestricted_Access,
                             64);
   end SHA1_Context_Update;

   ----------------------------------------------------------------------------

   procedure SHA1_Context_Finalize
     (Context : in out SHA1_Context_Type;
      Block   : in     LSC.Internal.SHA1.Block_Type;
      Length  : in     LSC.Internal.SHA1.Block_Length_Type)
   is
   begin
      OpenSSL.C_SHA1_Update (Context.C_Context'Unrestricted_Access,
                             Block'Unrestricted_Access,
                             Interfaces.C.size_t (Length / 8));
      OpenSSL.C_SHA1_Final (Context.Hash'Unrestricted_Access,
                            Context.C_Context'Unrestricted_Access);
   end SHA1_Context_Finalize;

   ----------------------------------------------------------------------------

   function SHA1_Get_Hash
     (Context : in SHA1_Context_Type)
      return LSC.Internal.SHA1.Hash_Type
   is
   begin
      return Context.Hash;
   end SHA1_Get_Hash;

   ----------------------------------------------------------------------------
   --  SHA-256
   ----------------------------------------------------------------------------

   procedure SHA256_Context_Init (Context :    out SHA256_Context_Type)
   is
   begin
      OpenSSL.C_SHA256_Init (Context.C_Context'Unrestricted_Access);
   end SHA256_Context_Init;

   ----------------------------------------------------------------------------

   procedure SHA256_Context_Update
      (Context : in out SHA256_Context_Type;
       Block   : in     LSC.Internal.SHA256.Block_Type)
   is
   begin
      OpenSSL.C_SHA256_Update (Context.C_Context'Unrestricted_Access,
                               Block'Unrestricted_Access,
                               64);
   end SHA256_Context_Update;

   ----------------------------------------------------------------------------

   procedure SHA256_Context_Finalize
      (Context : in out SHA256_Context_Type;
       Block   : in     LSC.Internal.SHA256.Block_Type;
       Length  : in     LSC.Internal.SHA256.Block_Length_Type)
   is
   begin
      OpenSSL.C_SHA256_Update (Context.C_Context'Unrestricted_Access,
                               Block'Unrestricted_Access,
                               Interfaces.C.size_t (Length / 8));
      OpenSSL.C_SHA256_Final (Context.Hash'Unrestricted_Access,
                              Context.C_Context'Unrestricted_Access);
   end SHA256_Context_Finalize;

   ----------------------------------------------------------------------------

   function SHA256_Get_Hash (Context : in SHA256_Context_Type)
      return LSC.Internal.SHA256.SHA256_Hash_Type
   is
   begin
      return Context.Hash;
   end SHA256_Get_Hash;

   ----------------------------------------------------------------------------
   --  SHA-384
   ----------------------------------------------------------------------------

   procedure SHA384_Context_Init (Context :    out SHA384_Context_Type)
   is
   begin
      OpenSSL.C_SHA384_Init (Context.C_Context'Unrestricted_Access);
   end SHA384_Context_Init;

   ----------------------------------------------------------------------------

   procedure SHA384_Context_Update
      (Context : in out SHA384_Context_Type;
       Block   : in     LSC.Internal.SHA512.Block_Type)
   is
   begin
      OpenSSL.C_SHA384_Update (Context.C_Context'Unrestricted_Access,
                               Block'Unrestricted_Access,
                               128);
   end SHA384_Context_Update;

   ----------------------------------------------------------------------------

   procedure SHA384_Context_Finalize
      (Context : in out SHA384_Context_Type;
       Block   : in     LSC.Internal.SHA512.Block_Type;
       Length  : in     LSC.Internal.SHA512.Block_Length_Type)
   is
   begin
      OpenSSL.C_SHA384_Update (Context.C_Context'Unrestricted_Access,
                               Block'Unrestricted_Access,
                               Interfaces.C.size_t (Length / 8));
      OpenSSL.C_SHA384_Final (Context.Hash'Unrestricted_Access,
                              Context.C_Context'Unrestricted_Access);
   end SHA384_Context_Finalize;

   ----------------------------------------------------------------------------

   function SHA384_Get_Hash (Context : in SHA384_Context_Type)
      return LSC.Internal.SHA512.SHA384_Hash_Type
   is
   begin
      return Context.Hash;
   end SHA384_Get_Hash;

   ----------------------------------------------------------------------------
   --  SHA-512
   ----------------------------------------------------------------------------

   procedure SHA512_Context_Init (Context :    out SHA512_Context_Type)
   is
   begin
      OpenSSL.C_SHA512_Init (Context.C_Context'Unrestricted_Access);
   end SHA512_Context_Init;

   ----------------------------------------------------------------------------

   procedure SHA512_Context_Update
      (Context : in out SHA512_Context_Type;
       Block   : in     LSC.Internal.SHA512.Block_Type)
   is
   begin
      OpenSSL.C_SHA512_Update (Context.C_Context'Unrestricted_Access,
                               Block'Unrestricted_Access,
                               128);
   end SHA512_Context_Update;

   ----------------------------------------------------------------------------

   procedure SHA512_Context_Finalize
      (Context : in out SHA512_Context_Type;
       Block   : in     LSC.Internal.SHA512.Block_Type;
       Length  : in     LSC.Internal.SHA512.Block_Length_Type)
   is
   begin
      OpenSSL.C_SHA512_Update (Context.C_Context'Unrestricted_Access,
                               Block'Unrestricted_Access,
                               Interfaces.C.size_t (Length / 8));
      OpenSSL.C_SHA512_Final (Context.Hash'Unrestricted_Access,
                              Context.C_Context'Unrestricted_Access);
   end SHA512_Context_Finalize;

   ----------------------------------------------------------------------------

   function SHA512_Get_Hash (Context : in SHA512_Context_Type)
      return LSC.Internal.SHA512.SHA512_Hash_Type
   is
   begin
      return Context.Hash;
   end SHA512_Get_Hash;

   ----------------------------------------------------------------------------
   --  RIPEMD-160
   ----------------------------------------------------------------------------

   procedure RIPEMD160_Context_Init (Context :    out RIPEMD160_Context_Type)
   is
   begin
      OpenSSL.C_RIPEMD160_Init (Context.C_Context'Unrestricted_Access);
   end RIPEMD160_Context_Init;

   ----------------------------------------------------------------------------

   procedure RIPEMD160_Context_Update
      (Context : in out RIPEMD160_Context_Type;
       Block   : in     LSC.Internal.RIPEMD160.Block_Type)
   is
   begin
      OpenSSL.C_RIPEMD160_Update (Context.C_Context'Unrestricted_Access,
                                  Block'Unrestricted_Access,
                                  64);
   end RIPEMD160_Context_Update;

   ----------------------------------------------------------------------------

   procedure RIPEMD160_Context_Finalize
      (Context : in out RIPEMD160_Context_Type;
       Block   : in     LSC.Internal.RIPEMD160.Block_Type;
       Length  : in     LSC.Internal.RIPEMD160.Block_Length_Type)
   is
   begin
      OpenSSL.C_RIPEMD160_Update (Context.C_Context'Unrestricted_Access,
                                  Block'Unrestricted_Access,
                                  Interfaces.C.size_t (Length / 8));
      OpenSSL.C_RIPEMD160_Final (Context.Hash'Unrestricted_Access,
                                 Context.C_Context'Unrestricted_Access);
   end RIPEMD160_Context_Finalize;

   ----------------------------------------------------------------------------

   function RIPEMD160_Get_Hash (Context : in RIPEMD160_Context_Type)
      return LSC.Internal.RIPEMD160.Hash_Type
   is
   begin
      return Context.Hash;
   end RIPEMD160_Get_Hash;

   ----------------------------------------------------------------------------

   function Authenticate_SHA1
     (Key     : LSC.Internal.SHA1.Block_Type;
      Message : SHA1_Message_Type;
      Length  : LSC.Internal.Types.Word64) return LSC.Internal.SHA1.Hash_Type
   is
      Temp_Digest : LSC.Internal.SHA1.Hash_Type;
   begin
      C_Authenticate_SHA1
        (Key'Unrestricted_Access,
         Message'Unrestricted_Access,
         Length,
         Temp_Digest'Unrestricted_Access);
      return Temp_Digest;
   end Authenticate_SHA1;

   ----------------------------------------------------------------------------

   function Authenticate_SHA256
      (Key     : LSC.Internal.SHA256.Block_Type;
       Message : SHA256_Message_Type;
       Length  : LSC.Internal.Types.Word64) return LSC.Internal.HMAC_SHA256.Auth_Type
   is
      Temp_Digest : LSC.Internal.HMAC_SHA256.Auth_Type;
   begin
      C_Authenticate_SHA256
        (Key'Unrestricted_Access,
         Message'Unrestricted_Access,
         Length,
         Temp_Digest'Unrestricted_Access);
      return Temp_Digest;
   end Authenticate_SHA256;

   ----------------------------------------------------------------------------

   function Authenticate_SHA384
      (Key     : LSC.Internal.SHA512.Block_Type;
       Message : SHA512_Message_Type;
       Length  : LSC.Internal.Types.Word64) return LSC.Internal.HMAC_SHA384.Auth_Type
   is
      Temp_Digest : LSC.Internal.HMAC_SHA384.Auth_Type;
   begin
      C_Authenticate_SHA384
        (Key'Unrestricted_Access,
         Message'Unrestricted_Access,
         Length,
         Temp_Digest'Unrestricted_Access);
      return Temp_Digest;
   end Authenticate_SHA384;

   ----------------------------------------------------------------------------

   function Authenticate_SHA512
      (Key     : LSC.Internal.SHA512.Block_Type;
       Message : SHA512_Message_Type;
       Length  : LSC.Internal.Types.Word64) return LSC.Internal.HMAC_SHA512.Auth_Type
   is
      Temp_Digest : LSC.Internal.HMAC_SHA512.Auth_Type;
   begin
      C_Authenticate_SHA512
        (Key'Unrestricted_Access,
         Message'Unrestricted_Access,
         Length,
         Temp_Digest'Unrestricted_Access);
      return Temp_Digest;
   end Authenticate_SHA512;

   ----------------------------------------------------------------------------

   function Authenticate_RMD160
      (Key     : LSC.Internal.RIPEMD160.Block_Type;
       Message : RMD160_Message_Type;
       Length  : LSC.Internal.Types.Word64) return LSC.Internal.RIPEMD160.Hash_Type
   is
      Temp_Digest : LSC.Internal.RIPEMD160.Hash_Type;
   begin
      C_Authenticate_RMD160
        (Key'Unrestricted_Access,
         Message'Unrestricted_Access,
         Length,
         Temp_Digest'Unrestricted_Access);
      return Temp_Digest;
   end Authenticate_RMD160;

   ----------------------------------------------------------------------------

   procedure RSA_Public_Encrypt
     (M       : in     LSC.Internal.Bignum.Big_Int;
      E       : in     LSC.Internal.Bignum.Big_Int;
      P       : in     LSC.Internal.Bignum.Big_Int;
      C       :    out LSC.Internal.Bignum.Big_Int;
      Success :    out Boolean)
   is
      Result : LSC.Internal.Types.Word64;
   begin
      C := (others => 0);
      C_RSA_Public_Encrypt
        (M        => M'Address,
         M_Length => LSC.Internal.Types.Word64 (4 * M'Length),
         E        => E'Address,
         E_Length => LSC.Internal.Types.Word64 (4 * E'Length),
         P        => P'Address,
         C        => C'Address,
         Result   => Result'Address);
      Success := Result = 0;
   end RSA_Public_Encrypt;

   ----------------------------------------------------------------------------

   procedure RSA_Private_Decrypt
     (M       : in     LSC.Internal.Bignum.Big_Int;
      E       : in     LSC.Internal.Bignum.Big_Int;
      D       : in     LSC.Internal.Bignum.Big_Int;
      C       : in     LSC.Internal.Bignum.Big_Int;
      P       :    out LSC.Internal.Bignum.Big_Int;
      Success :    out Boolean)
   is
      Result : LSC.Internal.Types.Word64;
   begin
      P := (others => 0);
      C_RSA_Private_Decrypt
        (M        => M'Address,
         M_Length => LSC.Internal.Types.Word64 (4 * M'Length),
         E        => E'Address,
         E_Length => LSC.Internal.Types.Word64 (4 * E'Length),
         D        => D'Address,
         D_Length => LSC.Internal.Types.Word64 (4 * D'Length),
         C        => C'Address,
         P        => P'Address,
         Result   => Result'Address);
      Success := Result = 0;
   end RSA_Private_Decrypt;

end OpenSSL;
