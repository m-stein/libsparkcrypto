-------------------------------------------------------------------------------
-- This file is part of libsparkcrypto.
--
-- Copyright (C) 2010, Alexander Senier
-- Copyright (C) 2010, secunet Security Networks AG
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

with Interfaces;
with LSC.Internal.Byteorder32;
with LSC.Internal.SHA256.Tables;
with LSC.Internal.Pad32;
with LSC.Internal.Debug;
pragma Unreferenced (LSC.Internal.Debug);

package body LSC.Internal.SHA256 is

   function Init_Data_Length return Data_Length is
   begin
      return Data_Length'(0, 0);
   end Init_Data_Length;

   ----------------------------------------------------------------------------

   procedure Add (Item  : in out Data_Length;
                  Value : in     Types.Word32)
     with
         Depends => (Item =>+ Value),
         Inline
   is
   begin
      if Item.LSW > Types.Word32'Last - Value then
         Item.MSW := Item.MSW + 1;
      end if;

      Item.LSW := Item.LSW + Value;
   end Add;

   ----------------------------------------------------------------------------

   function Ch
     (x    : Types.Word32;
      y    : Types.Word32;
      z    : Types.Word32)
      return Types.Word32
     with
         Post => Ch'Result = ((x and y) xor ((not x) and z)),
         Inline
   is
   begin
      return (x and y) xor ((not x) and z);
   end Ch;

   ----------------------------------------------------------------------------

   function Maj
     (x    : Types.Word32;
      y    : Types.Word32;
      z    : Types.Word32)
      return Types.Word32
     with
         Post => Maj'Result = ((x and y) xor (x and z) xor (y and z)),
         Inline
   is
   begin
      return (x and y) xor (x and z) xor (y and z);
   end Maj;

   ----------------------------------------------------------------------------

   function Cap_Sigma_0_256 (x : Types.Word32) return Types.Word32
   is
   begin
      return Interfaces.Rotate_Right (x,  2) xor
             Interfaces.Rotate_Right (x, 13) xor
             Interfaces.Rotate_Right (x, 22);
   end Cap_Sigma_0_256;

   pragma Inline (Cap_Sigma_0_256);

   ----------------------------------------------------------------------------

   function Cap_Sigma_1_256 (x : Types.Word32) return Types.Word32
   is
   begin
      return Interfaces.Rotate_Right (x,  6) xor
             Interfaces.Rotate_Right (x, 11) xor
             Interfaces.Rotate_Right (x, 25);
   end Cap_Sigma_1_256;

   pragma Inline (Cap_Sigma_1_256);

   ----------------------------------------------------------------------------

   function Sigma_0_256 (x : Types.Word32) return Types.Word32
   is
   begin
      return Interfaces.Rotate_Right (x,  7) xor
             Interfaces.Rotate_Right (x, 18) xor
             Interfaces.Shift_Right (x,  3);
   end Sigma_0_256;

   pragma Inline (Sigma_0_256);

   ----------------------------------------------------------------------------

   function Sigma_1_256 (x : Types.Word32) return Types.Word32
   is
   begin
      return Interfaces.Rotate_Right (x, 17) xor
             Interfaces.Rotate_Right (x, 19) xor
             Interfaces.Shift_Right (x, 10);
   end Sigma_1_256;

   pragma Inline (Sigma_1_256);

   ----------------------------------------------------------------------------

   function SHA256_Context_Init return Context_Type is
   begin
      return Context_Type'
        (Length => Init_Data_Length,
         H      => SHA256_Hash_Type'(0 => 16#6a09e667#,
                                     1 => 16#bb67ae85#,
                                     2 => 16#3c6ef372#,
                                     3 => 16#a54ff53a#,
                                     4 => 16#510e527f#,
                                     5 => 16#9b05688c#,
                                     6 => 16#1f83d9ab#,
                                     7 => 16#5be0cd19#),
         W      => Null_Schedule);
   end SHA256_Context_Init;

   ----------------------------------------------------------------------------

   procedure Context_Update_Internal
     (Context : in out Context_Type;
      Block   : in     Block_Type)
     with Depends => (Context =>+ Block)
   is
      a, b, c, d, e, f, g, h : Types.Word32;

      procedure SHA256_Op (r  : in     Schedule_Index;
                           a0 : in     Types.Word32;
                           a1 : in     Types.Word32;
                           a2 : in     Types.Word32;
                           a3 : in out Types.Word32;
                           a4 : in     Types.Word32;
                           a5 : in     Types.Word32;
                           a6 : in     Types.Word32;
                           a7 : in out Types.Word32)
        with
          Global => Context,
          Depends =>
            (a3 =>+ (a4, a5, a6, a7, r, Context),
             a7 => (a0, a1, a2, a4, a5, a6, a7, r, Context))
      is
         T1, T2 : Types.Word32;
      begin

         T1 := a7 + Cap_Sigma_1_256 (a4) + Ch (a4, a5, a6) + Tables.K (r) + Context.W (r);
         T2 := Cap_Sigma_0_256 (a0) + Maj (a0, a1, a2);
         a3 := a3 + T1;
         a7 := T1 + T2;

      end SHA256_Op;

   begin

      pragma Debug (Debug.Put_Line ("BLOCK UPDATE:"));

      -- Print out initial state of H
      pragma Debug (Debug.Put_Line ("SHA-256 initial hash values:"));
      pragma Debug (Debug.Print_Word32_Array (Context.H, 2, Types.Index'Last, True));

      -------------------------------------------
      --  Section 6.3.2 SHA-256 Hash Computations
      -------------------------------------------

      --  1. Prepare the message schedule, Context.W(t):
      for t in Schedule_Index range 0 .. 15
      loop
         Context.W (t) := Byteorder32.Native_To_BE (Block (t));
      end loop;

      for t in Schedule_Index range 16 .. 63
      loop
         Context.W (t) := Sigma_1_256 (Context.W (t - 2)) +
                                       Context.W (t - 7) +
                                       Sigma_0_256 (Context.W (t - 15)) +
                                       Context.W (t - 16);
      end loop;

      pragma Debug (Debug.Put_Line ("Message block:"));
      pragma Debug (Debug.Print_Word32_Array (Context.W, 2, 8, True));

      -- 2. Initialize the eight working variables a, b, c, d, e, f, g, and
      --    h with the (i-1)st hash value:
      a := Context.H (0);
      b := Context.H (1);
      c := Context.H (2);
      d := Context.H (3);
      e := Context.H (4);
      f := Context.H (5);
      g := Context.H (6);
      h := Context.H (7);

      -- 3. For t = 0 to 63:

      SHA256_Op (0, a, b, c, d, e, f, g, h);
      SHA256_Op (1, h, a, b, c, d, e, f, g);
      SHA256_Op (2, g, h, a, b, c, d, e, f);
      SHA256_Op (3, f, g, h, a, b, c, d, e);
      SHA256_Op (4, e, f, g, h, a, b, c, d);
      SHA256_Op (5, d, e, f, g, h, a, b, c);
      SHA256_Op (6, c, d, e, f, g, h, a, b);
      SHA256_Op (7, b, c, d, e, f, g, h, a);

      SHA256_Op  (8, a, b, c, d, e, f, g, h);
      SHA256_Op  (9, h, a, b, c, d, e, f, g);
      SHA256_Op (10, g, h, a, b, c, d, e, f);
      SHA256_Op (11, f, g, h, a, b, c, d, e);
      SHA256_Op (12, e, f, g, h, a, b, c, d);
      SHA256_Op (13, d, e, f, g, h, a, b, c);
      SHA256_Op (14, c, d, e, f, g, h, a, b);
      SHA256_Op (15, b, c, d, e, f, g, h, a);

      SHA256_Op (16, a, b, c, d, e, f, g, h);
      SHA256_Op (17, h, a, b, c, d, e, f, g);
      SHA256_Op (18, g, h, a, b, c, d, e, f);
      SHA256_Op (19, f, g, h, a, b, c, d, e);
      SHA256_Op (20, e, f, g, h, a, b, c, d);
      SHA256_Op (21, d, e, f, g, h, a, b, c);
      SHA256_Op (22, c, d, e, f, g, h, a, b);
      SHA256_Op (23, b, c, d, e, f, g, h, a);

      SHA256_Op (24, a, b, c, d, e, f, g, h);
      SHA256_Op (25, h, a, b, c, d, e, f, g);
      SHA256_Op (26, g, h, a, b, c, d, e, f);
      SHA256_Op (27, f, g, h, a, b, c, d, e);
      SHA256_Op (28, e, f, g, h, a, b, c, d);
      SHA256_Op (29, d, e, f, g, h, a, b, c);
      SHA256_Op (30, c, d, e, f, g, h, a, b);
      SHA256_Op (31, b, c, d, e, f, g, h, a);

      SHA256_Op (32, a, b, c, d, e, f, g, h);
      SHA256_Op (33, h, a, b, c, d, e, f, g);
      SHA256_Op (34, g, h, a, b, c, d, e, f);
      SHA256_Op (35, f, g, h, a, b, c, d, e);
      SHA256_Op (36, e, f, g, h, a, b, c, d);
      SHA256_Op (37, d, e, f, g, h, a, b, c);
      SHA256_Op (38, c, d, e, f, g, h, a, b);
      SHA256_Op (39, b, c, d, e, f, g, h, a);

      SHA256_Op (40, a, b, c, d, e, f, g, h);
      SHA256_Op (41, h, a, b, c, d, e, f, g);
      SHA256_Op (42, g, h, a, b, c, d, e, f);
      SHA256_Op (43, f, g, h, a, b, c, d, e);
      SHA256_Op (44, e, f, g, h, a, b, c, d);
      SHA256_Op (45, d, e, f, g, h, a, b, c);
      SHA256_Op (46, c, d, e, f, g, h, a, b);
      SHA256_Op (47, b, c, d, e, f, g, h, a);

      SHA256_Op (48, a, b, c, d, e, f, g, h);
      SHA256_Op (49, h, a, b, c, d, e, f, g);
      SHA256_Op (50, g, h, a, b, c, d, e, f);
      SHA256_Op (51, f, g, h, a, b, c, d, e);
      SHA256_Op (52, e, f, g, h, a, b, c, d);
      SHA256_Op (53, d, e, f, g, h, a, b, c);
      SHA256_Op (54, c, d, e, f, g, h, a, b);
      SHA256_Op (55, b, c, d, e, f, g, h, a);

      SHA256_Op (56, a, b, c, d, e, f, g, h);
      SHA256_Op (57, h, a, b, c, d, e, f, g);
      SHA256_Op (58, g, h, a, b, c, d, e, f);
      SHA256_Op (59, f, g, h, a, b, c, d, e);
      SHA256_Op (60, e, f, g, h, a, b, c, d);
      SHA256_Op (61, d, e, f, g, h, a, b, c);
      SHA256_Op (62, c, d, e, f, g, h, a, b);
      SHA256_Op (63, b, c, d, e, f, g, h, a);

      -- 4. Compute the i-th intermediate hash value H-i:
      Context.H :=
        SHA256_Hash_Type'
        (0 => a + Context.H (0),
         1 => b + Context.H (1),
         2 => c + Context.H (2),
         3 => d + Context.H (3),
         4 => e + Context.H (4),
         5 => f + Context.H (5),
         6 => g + Context.H (6),
         7 => h + Context.H (7));

      pragma Debug (Debug.Put_Line ("SHA-256 final hash values:"));
      pragma Debug (Debug.Print_Word32_Array (Context.H, 2, Types.Index'Last, True));

   end Context_Update_Internal;

   ----------------------------------------------------------------------------

   procedure Context_Update
     (Context : in out Context_Type;
      Block   : in     Block_Type)
   is
   begin
      Context_Update_Internal (Context, Block);
      Add (Context.Length, 512);
   end Context_Update;

   ----------------------------------------------------------------------------

   procedure Context_Finalize
     (Context : in out Context_Type;
      Block   : in     Block_Type;
      Length  : in     Block_Length_Type)
   is
      Final_Block : Block_Type;
   begin

      pragma Debug (Debug.Put_Line ("FINAL BLOCK:"));

      Final_Block := Block;

      --  Add length of last block to data length.
      Add (Context.Length, Length);

      --  Set trailing '1' marker and zero out rest of the block.
      Pad32.Block_Terminate (Block  => Final_Block,
                             Length => Types.Word64 (Length));

      --  Terminator and length values won't fit into current block.
      if Length >= 448 then
         Context_Update_Internal (Context => Context, Block => Final_Block);
         Final_Block := Null_Block;
      end if;

      --  Set length in final block.
      Final_Block (Block_Type'Last - 1) := Byteorder32.BE_To_Native (Context.Length.MSW);
      Final_Block (Block_Type'Last)     := Byteorder32.BE_To_Native (Context.Length.LSW);

      Context_Update_Internal (Context => Context, Block => Final_Block);

   end Context_Finalize;

   ----------------------------------------------------------------------------

   function SHA256_Get_Hash (Context : Context_Type) return SHA256_Hash_Type is
   begin
      return SHA256_Hash_Type'(0 => Byteorder32.BE_To_Native (Context.H (0)),
                               1 => Byteorder32.BE_To_Native (Context.H (1)),
                               2 => Byteorder32.BE_To_Native (Context.H (2)),
                               3 => Byteorder32.BE_To_Native (Context.H (3)),
                               4 => Byteorder32.BE_To_Native (Context.H (4)),
                               5 => Byteorder32.BE_To_Native (Context.H (5)),
                               6 => Byteorder32.BE_To_Native (Context.H (6)),
                               7 => Byteorder32.BE_To_Native (Context.H (7)));
   end SHA256_Get_Hash;

   ----------------------------------------------------------------------------

   procedure Hash_Context
      (Message : in     Message_Type;
       Length  : in     Message_Index;
       Ctx     : in out Context_Type)
   is
      Dummy       : constant Block_Type := Null_Block;
      Last_Length : Block_Length_Type;
      Last_Block  : Message_Index;
   begin
      Last_Length := Types.Word32 (Length mod Block_Size);
      Last_Block  := Message'First + Length / Block_Size;

      -- handle all blocks, but the last.
      if Last_Block > Message'First then
         for I in Message_Index range Message'First .. Last_Block - 1
         loop
            pragma Loop_Invariant
              (Last_Block - 1 <= Message'Last and
               (if Last_Length /= 0 then Last_Block <= Message'Last) and
               I < Last_Block);
            Context_Update (Ctx, Message (I));
         end loop;
      end if;

      if Last_Length = 0 then
         Context_Finalize (Ctx, Dummy, 0);
      else
         Context_Finalize (Ctx, Message (Last_Block), Last_Length);
      end if;
   end Hash_Context;

   ----------------------------------------------------------------------------

   function Hash
      (Message : Message_Type;
       Length  : Message_Index) return SHA256_Hash_Type
   is
      Ctx : Context_Type;
   begin
      Ctx := SHA256_Context_Init;
      Hash_Context (Message, Length, Ctx);

      return SHA256_Get_Hash (Ctx);
   end Hash;

end LSC.Internal.SHA256;
