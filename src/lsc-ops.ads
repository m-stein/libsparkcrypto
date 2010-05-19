--  This file is part of the sparkcrypto library.
--
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

with LSC.Types;
--# inherit LSC.Types;

package LSC.Ops is

   function Bytes_To_Word32
      (Byte0 : LSC.Types.Byte;
       Byte1 : LSC.Types.Byte;
       Byte2 : LSC.Types.Byte;
       Byte3 : LSC.Types.Byte) return LSC.Types.Word32;

   function Byte0 (Value : LSC.Types.Word32) return LSC.Types.Byte;
   function Byte1 (Value : LSC.Types.Word32) return LSC.Types.Byte;
   function Byte2 (Value : LSC.Types.Word32) return LSC.Types.Byte;
   function Byte3 (Value : LSC.Types.Word32) return LSC.Types.Byte;

end LSC.Ops;
