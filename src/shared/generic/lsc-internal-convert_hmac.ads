-------------------------------------------------------------------------------
-- This file is part of libsparkcrypto.
--
-- @author Alexander Senier
-- @date   2019-02-28
--
-- Copyright (C) 2019 Componolit GmbH
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

package LSC.Internal.Convert_HMAC
is
   generic
      Block_Len : Natural;
      Hash_Len : Natural;
      type Key_Index_Type is (<>);
      type Key_Elem_Type is (<>);
      type Key_Type is array (Key_Index_Type range <>) of Key_Elem_Type;
      type Message_Index_Type is (<>);
      type Message_Elem_Type is (<>);
      type Message_Type is array (Message_Index_Type range <>) of Message_Elem_Type;
      type Hash_Index_Type is (<>);
      type Hash_Elem_Type is (<>);
      type Hash_Type is array (Hash_Index_Type) of Hash_Elem_Type;
      type Internal_Context_Type is private;
      type Internal_Block_Type is private;
      type Internal_Block_Length_Type is (<>);
      type Internal_Hash_Type is private;

      with function Context_Init (Block : Internal_Block_Type) return Internal_Context_Type is <>;

      with procedure Context_Update (Context : in out Internal_Context_Type;
                                     Block   :        Internal_Block_Type) is <>;

      with procedure Context_Finalize (Context : in out Internal_Context_Type;
                                       Block   :        Internal_Block_Type;
                                       Length  :        Internal_Block_Length_Type) is <>;

      with function Get_Auth (Context : Internal_Context_Type) return Internal_Hash_Type is <>;

      with function Hash_Key (Key : Key_Type) return Key_Type;

   function HMAC_Generic
     (Key        : Key_Type;
      Message    : Message_Type) return Hash_Type;

end LSC.Internal.Convert_HMAC;
