package body OpenSSL is

   ----------------------------------------------------------------------------
   -- SHA-512
   ----------------------------------------------------------------------------

   procedure SHA384_Context_Init (Context : in out SHA384_Context_Type)
   is
   begin
      OpenSSL.C_SHA384_Init (Context.C_Context'Unrestricted_Access);
   end SHA384_Context_Init;

   ----------------------------------------------------------------------------

   procedure SHA384_Context_Update
      (Context : in out SHA384_Context_Type;
       Block   : in     LSC.SHA2.Block_Type)
   is
   begin
      OpenSSL.C_SHA384_Update (Context.C_Context'Unrestricted_Access,
                               Block'Unrestricted_Access,
                               128);
   end SHA384_Context_Update;

   ----------------------------------------------------------------------------

   procedure SHA384_Context_Finalize
      (Context : in out SHA384_Context_Type;
       Block   : in     LSC.SHA2.Block_Type;
       Length  : in     LSC.SHA2.Block_Length_Type)
   is
   begin
      OpenSSL.C_SHA384_Update (Context.C_Context'Unrestricted_Access,
                               Block'Unrestricted_Access,
                               Interfaces.C.size_t (Length / 8));
      OpenSSL.C_SHA384_Final (Context.Hash'Unrestricted_Access,
                              Context.C_Context'Unrestricted_Access);
   end SHA384_Context_Finalize;

   ----------------------------------------------------------------------------

   function SHA384_Get_Hash (Context : in SHA384_Context_Type)
      return LSC.SHA2.SHA384_Hash_Type
   is
   begin
      return Context.Hash;
   end SHA384_Get_Hash;

   ----------------------------------------------------------------------------
   -- SHA-512
   ----------------------------------------------------------------------------

   procedure SHA512_Context_Init (Context : in out SHA512_Context_Type)
   is
   begin
      OpenSSL.C_SHA512_Init (Context.C_Context'Unrestricted_Access);
   end SHA512_Context_Init;

   ----------------------------------------------------------------------------

   procedure SHA512_Context_Update
      (Context : in out SHA512_Context_Type;
       Block   : in     LSC.SHA2.Block_Type)
   is
   begin
      OpenSSL.C_SHA512_Update (Context.C_Context'Unrestricted_Access,
                               Block'Unrestricted_Access,
                               128);
   end SHA512_Context_Update;

   ----------------------------------------------------------------------------

   procedure SHA512_Context_Finalize
      (Context : in out SHA512_Context_Type;
       Block   : in     LSC.SHA2.Block_Type;
       Length  : in     LSC.SHA2.Block_Length_Type)
   is
   begin
      OpenSSL.C_SHA512_Update (Context.C_Context'Unrestricted_Access,
                               Block'Unrestricted_Access,
                               Interfaces.C.size_t (Length / 8));
      OpenSSL.C_SHA512_Final (Context.Hash'Unrestricted_Access,
                              Context.C_Context'Unrestricted_Access);
   end SHA512_Context_Finalize;

   ----------------------------------------------------------------------------

   function SHA512_Get_Hash (Context : in SHA512_Context_Type)
      return LSC.SHA2.SHA512_Hash_Type
   is
   begin
      return Context.Hash;
   end SHA512_Get_Hash;

   ----------------------------------------------------------------------------
   -- RIPEMD-160
   ----------------------------------------------------------------------------

   procedure RIPEMD160_Context_Init (Context : in out RIPEMD160_Context_Type)
   is
   begin
      OpenSSL.C_RIPEMD160_Init (Context.C_Context'Unrestricted_Access);
   end RIPEMD160_Context_Init;

   ----------------------------------------------------------------------------

   procedure RIPEMD160_Context_Update
      (Context : in out RIPEMD160_Context_Type;
       Block   : in     LSC.RIPEMD160.Block_Type)
   is
   begin
      OpenSSL.C_RIPEMD160_Update (Context.C_Context'Unrestricted_Access,
                                  Block'Unrestricted_Access,
                                  64);
   end RIPEMD160_Context_Update;

   ----------------------------------------------------------------------------

   procedure RIPEMD160_Context_Finalize
      (Context : in out RIPEMD160_Context_Type;
       Block   : in     LSC.RIPEMD160.Block_Type;
       Length  : in     LSC.RIPEMD160.Block_Length_Type)
   is
   begin
      OpenSSL.C_RIPEMD160_Update (Context.C_Context'Unrestricted_Access,
                                  Block'Unrestricted_Access,
                                  Interfaces.C.size_t (Length / 8));
      OpenSSL.C_RIPEMD160_Final (Context.Hash'Unrestricted_Access,
                                 Context.C_Context'Unrestricted_Access);
   end RIPEMD160_Context_Finalize;

   ----------------------------------------------------------------------------

   function RIPEMD160_Get_Hash (Context : in RIPEMD160_Context_Type)
      return LSC.RIPEMD160.Hash_Type
   is
   begin
      return Context.Hash;
   end RIPEMD160_Get_Hash;
end OpenSSL;
