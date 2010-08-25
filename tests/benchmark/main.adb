-------------------------------------------------------------------------------
-- This file is part of the sparkcrypto library.
--
-- Copyright (C) 2010  Alexander Senier <mail@senier.net>
-- Copyright (C) 2010  secunet Security Networks AG
--
-- libsparkcrypto is  free software; you  can redistribute it and/or  modify it
-- under  terms of  the GNU  General Public  License as  published by  the Free
-- Software  Foundation;  either version  3,  or  (at  your option)  any  later
-- version.  libsparkcrypto  is  distributed  in  the  hope  that  it  will  be
-- useful,  but WITHOUT  ANY WARRANTY;  without  even the  implied warranty  of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
--
-- As a  special exception under  Section 7 of GPL  version 3, you  are granted
-- additional  permissions  described in  the  GCC  Runtime Library  Exception,
-- version 3.1, as published by the Free Software Foundation.
--
-- You should  have received  a copy of  the GNU General  Public License  and a
-- copy  of  the  GCC  Runtime  Library  Exception  along  with  this  program;
-- see  the  files  COPYING3  and COPYING.RUNTIME  respectively.  If  not,  see
-- <http://www.gnu.org/licenses/>.
-------------------------------------------------------------------------------

with LSC.SHA256;
with LSC.SHA512;
with LSC.RIPEMD160;
with LSC.Types;
with LSC.AES;
with LSC.Test;
with LSC.IO;
with LSC.HMAC_SHA256;
with LSC.HMAC_SHA384;
with LSC.HMAC_SHA512;
with LSC.HMAC_RIPEMD160;
with OpenSSL;

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Real_Time; use Ada.Real_Time;

use type LSC.Types.Word32_Array_Type;
use type LSC.Types.Word64_Array_Type;

procedure Main
is
   S1, S2  : Time;
   D1, D2  : Time_Span;

   procedure Result
      (Message   : String;
       Result    : Boolean;
       Duration1 : Time_Span;
       Duration2 : Time_Span)
   is
      Percent : Integer;
   begin
      Put (Message & ": ");
      if Result
      then
         Percent := (Time_Span (100 * Duration1) / Duration2);
         Put_Line (Percent'Img & " %");
      else
         Put_Line ("FAILED");
      end if;
   end Result;

   procedure Test_AES128_Encrypt is separate;
   procedure Test_AES192_Encrypt is separate;
   procedure Test_AES256_Encrypt is separate;
   procedure Test_AES128_Decrypt is separate;
   procedure Test_AES192_Decrypt is separate;
   procedure Test_AES256_Decrypt is separate;
   procedure Test_SHA256 is separate;
   procedure Test_SHA384 is separate;
   procedure Test_SHA512 is separate;
   procedure Test_RIPEMD160 is separate;
   procedure Test_HMAC_SHA256 is separate;
   procedure Test_HMAC_SHA384 is separate;
   procedure Test_HMAC_SHA512 is separate;
   procedure Test_HMAC_RMD160 is separate;

begin

   New_Line;
   Put_Line ("libsparkcrypto benchmarks:");

   Test_AES128_Encrypt;
   Test_AES192_Encrypt;
   Test_AES256_Encrypt;
   Test_AES128_Decrypt;
   Test_AES192_Decrypt;
   Test_AES256_Decrypt;
   Test_SHA256;
   Test_SHA384;
   Test_SHA512;
   Test_RIPEMD160;
   Test_HMAC_SHA256;
   Test_HMAC_SHA384;
   Test_HMAC_SHA512;
   Test_HMAC_RMD160;

end Main;
