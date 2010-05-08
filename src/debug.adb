--  This file is part of the sparkcrypto library.

--  Copyright (C) 2010  secunet Security Networks AG
--  Copyright (C) 2010  Alexander Senier <mail@senier.net>

--  This library  is free software:  you can  redistribute it and/or  modify it
--  under the  terms of the GNU  Lesser General Public License  as published by
--  the Free Software Foundation, either version  3 of the License, or (at your
--  option) any later version.

--  This library is distributed in the hope that it will be useful, but WITHOUT
--  ANY  WARRANTY; without  even  the implied  warranty  of MERCHANTABILITY  or
--  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License
--  for more details.

--  You should  have received a copy  of the GNU Lesser  General Public License
--  along with this library. If not, see <http://www.gnu.org/licenses/>.

package body Debug is

   procedure Put (T : String) is
   begin
      --# accept Flow, 30, T, "Null implementation";
      null;
   end Put;

   procedure Put_Line (T : String) is
   begin
      --# accept Flow, 30, T, "Null implementation";
      null;
   end Put_Line;

   procedure New_Line is
   begin
      null;
   end New_Line;

   procedure Print_Word32 (I : in Types.Word32) is
   begin
      --# accept Flow, 30, I, "Null implementation";
      null;
   end Print_Word32;

   procedure Print_Word64 (I : in Types.Word64) is
   begin
      --# accept Flow, 30, I, "Null implementation";
      null;
   end Print_Word64;

   procedure Print_Hash (H : SHA2.Hash_Type) is
   begin
      --# accept Flow, 30, H, "Null implementation";
      null;
   end Print_Hash;

   procedure Print_Block (B : SHA2.Block_Type) is
   begin
      --# accept Flow, 30, B, "Null implementation";
      null;
   end Print_Block;

end Debug;