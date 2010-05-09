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

package body AES256.Debug is

   procedure Print_Schedule (S : AES256.Schedule_Type)
   is
   begin
      --# accept Flow, 30, S, "Null implementation";
      null;
   end Print_Schedule;

   procedure Print_Schedule_Index (I : AES256.Schedule_Index)
   is
   begin
      --# accept Flow, 30, I, "Null implementation";
      null;
   end Print_Schedule_Index;

end AES256.Debug;