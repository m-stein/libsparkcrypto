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

package body Test is

   procedure Suite (Name : String)
   is
   begin
      IO.New_Line;
      IO.Put (Name);
      IO.Put_Line (":");
   end Suite;

   procedure Run (Message : String;
                  Result  : Boolean)
   is
   begin

      IO.Put ("   ");
      IO.Put (Message);
      IO.Put (": ");
      if Result
      then
         IO.Put_Line ("OK");
      else
         IO.Put_Line ("Failed");
      end if;
   end Run;

end Test;