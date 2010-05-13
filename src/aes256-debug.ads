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

--# inherit AES256;

private package AES256.Debug is

   procedure Print_Schedule (S : AES256.Schedule_Type);
   --# derives null from S;

   procedure Print_Schedule_Index (I : AES256.Schedule_Index);
   --# derives null from I;

   procedure Print_Block (B : AES256.Block_Type);
   --# derives null from B;

   procedure Print_Key (K : AES256.Key_Type);
   --# derives null from K;

   procedure Print_Round (T : String;
                          R : AES256.Schedule_Index;
                          B : AES256.Block_Type);
   --# derives null from T, R, B;

end AES256.Debug;
