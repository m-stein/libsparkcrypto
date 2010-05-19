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

--# inherit LSC.SHA2;

private package LSC.SHA2.Print is

   procedure Put_T (T : SHA2.Schedule_Index);
   --# derives null from T;

   procedure Put_Natural (I : Natural);
   --# derives null from I;

   procedure Put_Line (T : String);
   --# derives null from T;

   procedure Put_State (S : SHA2.State_Type);
   --# derives null from S;

   procedure Put_Hash (H : SHA2.Hash_Type);
   --# derives null from H;

   procedure Put_Schedule (S : SHA2.Schedule_Type);
   --# derives null from S;

end LSC.SHA2.Print;