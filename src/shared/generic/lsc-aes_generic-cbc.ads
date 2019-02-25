-------------------------------------------------------------------------------
-- This file is part of libsparkcrypto.
--
-- @author Alexander Senier
-- @date   2019-01-21
--
-- Copyright (C) 2018 Componolit GmbH
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

package LSC.AES_Generic.CBC
is
   generic
      type Plaintext_Index_Type is (<>);
      type Plaintext_Elem_Type is (<>);
      type Plaintext_Type is array (Plaintext_Index_Type range <>) of Plaintext_Elem_Type;
      type Ciphertext_Index_Type is (<>);
      type Ciphertext_Elem_Type is (<>);
      type Ciphertext_Type is array (Ciphertext_Index_Type range <>) of Ciphertext_Elem_Type;
   procedure Decrypt (Ciphertext :     Ciphertext_Type;
                      IV         :     Ciphertext_Type;
                      Key        :     AES_Generic.Dec_Key_Type;
                      Plaintext  : out Plaintext_Type)
   with
      Pre  => Ciphertext'Length > 0 and
              Ciphertext'Length mod 16 = 0 and
              Plaintext'Length >= Ciphertext'Length and
              IV'Length = 16;
   --  Decrypt @Ciphertext to @Plaintext using @IV and @Key in CBC mode

   generic
      type Plaintext_Index_Type is (<>);
      type Plaintext_Elem_Type is (<>);
      type Plaintext_Type is array (Plaintext_Index_Type range <>) of Plaintext_Elem_Type;
      type Ciphertext_Index_Type is (<>);
      type Ciphertext_Elem_Type is (<>);
      type Ciphertext_Type is array (Ciphertext_Index_Type range <>) of Ciphertext_Elem_Type;
   procedure Encrypt (Plaintext  :     Plaintext_Type;
                      IV         :     Ciphertext_Type;
                      Key        :     AES_Generic.Enc_Key_Type;
                      Ciphertext : out Ciphertext_Type)
   with
      Pre  => Plaintext'Length > 0 and
              Plaintext'Length mod 16 = 0 and
              Ciphertext'Length >= Plaintext'Length and
              IV'Length = 16;
   --  Encrypt @Plaintext to @Ciphertext using @IV and @Key in CBC mode

end LSC.AES_Generic.CBC;