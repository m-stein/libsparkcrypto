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

separate (Main)
procedure Test_HMAC_SHA512
is
   Message : OpenSSL.SHA512_Message_Type := OpenSSL.SHA512_Message_Type'
      (others => LSC.SHA512.Block_Type'(others => 16#dead_beef_dead_c0de#));

   Key : LSC.SHA512.Block_Type := LSC.SHA512.Block_Type'
      (others => 16#c0de_affe_cafe_babe#);

   H1 : LSC.HMAC_SHA512.Auth_Type;
   H2 : LSC.HMAC_SHA512.Auth_Type;
begin

   S1 := Clock;
   for I in 1 .. 50000
   loop
      H1 := OpenSSL.Authenticate_SHA512 (Key, Message, 10000);
   end loop;
   D1 := Clock - S1;

   S2 := Clock;
   for I in 1 .. 50000
   loop
      H2 := LSC.HMAC_SHA512.Authenticate (Key, Message, 10000);
   end loop;
   D2 := Clock - S2;

   Result ("HMAC_SHA512", H1 = H2, D1, D2);
end Test_HMAC_SHA512;
