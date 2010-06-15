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

package body LSC.Byteorder is

   function Native_To_BE32 (Item : Types.Word32) return Types.Word32
   is
      Result : Types.Word32;
   begin
      --# accept Flow, 22, "Native_Order is a configuration constant.";
      if Native_Order = Little_Endian
      then
         Result := Byteswap.Swap32 (Item);
      else
         Result := Item;
      end if;
      return Result;
   end Native_To_BE32;

   ---------------------------------------------------------------------------

   function Native_To_LE32 (Item : Types.Word32) return Types.Word32
   is
      Result : Types.Word32;
   begin
      --# accept Flow, 22, "Native_Order is a configuration constant.";
      if Native_Order = Big_Endian
      then
         Result := Byteswap.Swap32 (Item);
      else
         Result := Item;
      end if;
      return Result;
   end Native_To_LE32;

   ---------------------------------------------------------------------------

   function BE_To_Native32 (Item : Types.Word32) return Types.Word32
   is
      Result : Types.Word32;
   begin
      --# accept Flow, 22, "Native_Order is a configuration constant.";
      if Native_Order = Little_Endian
      then
         Result := Byteswap.Swap32 (Item);
      else
         Result := Item;
      end if;
      return Result;
   end BE_To_Native32;

   ---------------------------------------------------------------------------

   function LE_To_Native32 (Item : Types.Word32) return Types.Word32
   is
      Result : Types.Word32;
   begin
      --# accept Flow, 22, "Native_Order is a configuration constant.";
      if Native_Order = Big_Endian
      then
         Result := Byteswap.Swap32 (Item);
      else
         Result := Item;
      end if;
      return Result;
   end LE_To_Native32;

   ---------------------------------------------------------------------------

   function Native_To_BE64 (Item : Types.Word64) return Types.Word64
   is
      Result : Types.Word64;
   begin
      --# accept Flow, 22, "Native_Order is a configuration constant.";
      if Native_Order = Little_Endian
      then
         Result := Byteswap.Swap64 (Item);
      else
         Result := Item;
      end if;
      return Result;
   end Native_To_BE64;

   ---------------------------------------------------------------------------

   function Native_To_LE64 (Item : Types.Word64) return Types.Word64
   is
      Result : Types.Word64;
   begin
      --# accept Flow, 22, "Native_Order is a configuration constant.";
      if Native_Order = Big_Endian
      then
         Result := Byteswap.Swap64 (Item);
      else
         Result := Item;
      end if;
      return Result;
   end Native_To_LE64;

   ---------------------------------------------------------------------------

   function BE_To_Native64 (Item : Types.Word64) return Types.Word64
   is
      Result : Types.Word64;
   begin
      --# accept Flow, 22, "Native_Order is a configuration constant.";
      if Native_Order = Little_Endian
      then
         Result := Byteswap.Swap64 (Item);
      else
         Result := Item;
      end if;
      return Result;
   end BE_To_Native64;

   ---------------------------------------------------------------------------

   function LE_To_Native64 (Item : Types.Word64) return Types.Word64
   is
      Result : Types.Word64;
   begin
      --# accept Flow, 22, "Native_Order is a configuration constant.";
      if Native_Order = Big_Endian
      then
         Result := Byteswap.Swap64 (Item);
      else
         Result := Item;
      end if;
      return Result;
   end LE_To_Native64;

end LSC.Byteorder;
