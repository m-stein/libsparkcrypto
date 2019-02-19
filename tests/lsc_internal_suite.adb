-------------------------------------------------------------------------------
-- This file is part of libsparkcrypto.
--
-- Copyright (C) 2018, Componolit GmbH
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

with LSC_Internal_Test_AES;
with LSC_Internal_Test_AES_CBC;
with LSC_Internal_Test_SHA1;
with LSC_Internal_Test_SHA2;
with LSC_Internal_Test_RIPEMD160;
with LSC_Internal_Test_HMAC;
with LSC_Internal_Test_Shadow;
with LSC_Internal_Test_Bignum;
with LSC_Internal_Test_EC;
with LSC_Internal_Benchmark;

package body LSC_Internal_Suite is

   use AUnit.Test_Suites;

   -- Statically allocate test suite:
   Result : aliased Test_Suite;

   --  Statically allocate test cases:
   Test_AES       : aliased LSC_Internal_Test_AES.Test_Case;
   Test_AES_CBC   : aliased LSC_Internal_Test_AES_CBC.Test_Case;
   Test_SHA1      : aliased LSC_Internal_Test_SHA1.Test_Case;
   Test_SHA2      : aliased LSC_Internal_Test_SHA2.Test_Case;
   Test_RIPEMD160 : aliased LSC_Internal_Test_RIPEMD160.Test_Case;
   Test_HMAC      : aliased LSC_Internal_Test_HMAC.Test_Case;
   Test_Shadow    : aliased LSC_Internal_Test_Shadow.Test_Case;
   Test_Bignum    : aliased LSC_Internal_Test_Bignum.Test_Case;
   Test_EC        : aliased LSC_Internal_Test_EC.Test_Case;
   Benchmark      : aliased LSC_Internal_Benchmark.Test_Case;

   function Suite return Access_Test_Suite is
   begin
      Add_Test (Result'Access, Test_AES'Access);
      Add_Test (Result'Access, Test_AES_CBC'Access);
      Add_Test (Result'Access, Test_SHA1'Access);
      Add_Test (Result'Access, Test_SHA2'Access);
      Add_Test (Result'Access, Test_RIPEMD160'Access);
      Add_Test (Result'Access, Test_HMAC'Access);
      Add_Test (Result'Access, Test_Shadow'Access);
      Add_Test (Result'Access, Test_Bignum'Access);
      Add_Test (Result'Access, Test_EC'Access);
      Add_Test (Result'Access, Benchmark'Access);
      return Result'Access;
   end Suite;

end LSC_Internal_Suite;