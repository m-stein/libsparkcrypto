-------------------------------------------------------------------------------
-- This file is part of libsparkcrypto.
--
-- @author Alexander Senier
-- @date   2019-01-24
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

with LSC.Internal.HMAC_SHA1;

package body LSC.SHA1.HMAC is

   -----------------
   -- HMAC_SHA1 --
   -----------------

   function HMAC
     (Key       : LSC.Types.Bytes;
      Message   : LSC.Types.Bytes;
      Length    : LSC.Types.Natural_Index := 20) return LSC.Types.Bytes
   is
      use type Internal.SHA1.Block_Length_Type;

      Temp          : SHA1_Block_Type := (others => 0);
      Full_Blocks   : constant Natural := Message'Length / SHA1_Block_Len;
      Partial_Bytes : constant Natural := Message'Length - Full_Blocks * SHA1_Block_Len;

      Context  : Internal.HMAC_SHA1.Context_Type;
      Full_Key : SHA1.SHA1_Block_Type := (others => 0);
   begin

      if Key'Length <= SHA1_Block_Len
      then
         Full_Key (Full_Key'First .. Full_Key'First + Key'Length - 1) := Key;
      else
         Full_Key (Full_Key'First .. Full_Key'First + SHA1_Hash_Len - 1) := LSC.SHA1.Hash (Key);
      end if;

      Context := Internal.HMAC_SHA1.Context_Init (To_Internal (Full_Key));

      for I in 0 .. Full_Blocks - 1
      loop
         Internal.HMAC_SHA1.Context_Update
            (Context => Context,
             Block   => To_Internal (Message (Message'First + I * SHA1_Block_Len ..
                                              Message'First + I * SHA1_Block_Len + SHA1_Block_Len - 1)));
      end loop;

      Temp (Temp'First .. Temp'First + Partial_Bytes - 1) :=
         Message (Message'First + SHA1_Block_Len * Full_Blocks ..
                  Message'First + SHA1_Block_Len * Full_Blocks + Partial_Bytes - 1);

      Internal.HMAC_SHA1.Context_Finalize
         (Context => Context,
          Block   => To_Internal (Temp),
          Length  => 8 * Internal.SHA1.Block_Length_Type (Partial_Bytes));

      return To_Public (Internal.HMAC_SHA1.Get_Auth (Context)) (1 .. Length);

   end HMAC;

end LSC.SHA1.HMAC;