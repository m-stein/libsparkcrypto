-------------------------------------------------------------------------------
-- This file is part of libsparkcrypto.
--
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

with LSC.AES;
--# inherit
--#    LSC.AES,
--#    LSC.Ops32;

-------------------------------------------------------------------------------
-- The AES-CBC cipher mode
--
-- <ul>
-- <li>
-- <a href="http://csrc.nist.gov/publications/nistpubs/800-38a/sp800-38a.pdf">
-- Morris Dworkin, Recommendation for Block Cipher Modes of Operation -
-- Methods and Techniques, NIST Special Publication 800-38A, 2001 Edition
-- National Institute of Standards and Technology, U.S. Department of
-- Commerce, December 2001 </a>
-- </li>
-- </ul>
-------------------------------------------------------------------------------
package LSC.AES.CBC is

   -- Encrypt @Length@ elements of the @Plaintext@ array using the AES context
   -- @Context@ and the initialization vector @IV@. The result is placed into
   -- @Ciphertext@.
   pragma Warnings (Off, """Ciphertext"" might not be initialized in ""Encrypt""");
   procedure Encrypt (Context    : in     AES.AES_Enc_Context;
                      IV         : in     AES.Block_Type;
                      Plaintext  : in     AES.Message_Type;
                      Length     : in     AES.Message_Index;
                      Ciphertext :    out AES.Message_Type);
   --# derives
   --#    Ciphertext from Context, IV, Plaintext, Length;
   --# pre
   --#    Plaintext'First = Ciphertext'First and
   --#    Plaintext'Last  = Ciphertext'Last and
   --#    Plaintext'First + Length - 1 in Plaintext'Range and
   --#    Plaintext'First + Length - 1 in AES.Message_Index and
   --#    Ciphertext'First + Length - 1 in Ciphertext'Range and
   --#    Ciphertext'First + Length - 1 in AES.Message_Index;
   pragma Warnings (On, """Ciphertext"" might not be initialized in ""Encrypt""");

   -- Decrypt @Length@ elements of the @Ciphertext@ array using the AES context
   -- @Context@ and the initialization vector @IV@. The result is placed into
   -- @Plaintext@.
   pragma Warnings (Off, """Plaintext"" might not be initialized in ""Decrypt""");
   procedure Decrypt (Context    : in     AES.AES_Dec_Context;
                      IV         : in     AES.Block_Type;
                      Ciphertext : in     AES.Message_Type;
                      Length     : in     AES.Message_Index;
                      Plaintext  :    out AES.Message_Type);
   --# derives
   --#    Plaintext from Context, IV, Ciphertext, Length;
   --# pre
   --#    Plaintext'First = Ciphertext'First and
   --#    Plaintext'Last  = Ciphertext'Last and
   --#    Plaintext'First + Length - 1 in Plaintext'Range and
   --#    Plaintext'First + Length - 1 in AES.Message_Index and
   --#    Ciphertext'First + Length - 1 in Ciphertext'Range and
   --#    Ciphertext'First + Length - 1 in AES.Message_Index;
   pragma Warnings (On, """Plaintext"" might not be initialized in ""Decrypt""");

end LSC.AES.CBC;
