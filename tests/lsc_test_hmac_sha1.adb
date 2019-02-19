------------------------------------------------------------------------------- -- This file is part of libsparkcrypto.
--
-- Copyright (C) 2018 Componolit GmbH
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

with AUnit.Assertions; use AUnit.Assertions;
with Util; use Util;
with LSC.SHA1.HMAC;
with LSC.Types;

use LSC;

package body LSC_Test_HMAC_SHA1 is

   procedure Test_HMAC (Key     : String;
                        Msg     : String;
                        Mac     : String;
                        Textkey : Boolean := False;
                        Textmsg : Boolean := False)
   is
      use type LSC.Types.Bytes;

      Converted_Key : LSC.Types.Bytes := (if Textkey then T2B (Key) else S2B (Key));
      Converted_Msg : LSC.Types.Bytes := (if Textmsg then T2B (Msg) else S2B (Msg));
      Converted_Mac : LSC.Types.Bytes := S2B (Mac);

      Result : LSC.Types.Bytes :=
         LSC.SHA1.HMAC.HMAC (Key       => Converted_Key,
                             Message   => Converted_Msg,
                             Length    => Converted_Mac'Length);
   begin
      Assert (Result = Converted_Mac, "Invalid HMAC: got " & B2S (Result) & ", expected " & Mac);
   end Test_HMAC;

   ---------------------------------------------------------------------------
   -- RFC 2202 Test vectors
   ---------------------------------------------------------------------------

   procedure Test_HMAC_RFC (T : in out Test_Cases.Test_Case'Class)
   is
   begin
      Test_HMAC (Key => "0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b",
                 Msg => "Hi There",
                 Mac => "b617318655057264e28bc0b6fb378c8ef146be00",
                 Textmsg => True);
      Test_HMAC (Key => "Jefe",
                 Msg => "what do ya want for nothing?",
                 Mac => "effcdf6ae5eb2fa2d27416d5f184df9c259a7c79",
                 Textmsg => True, Textkey => True);
      Test_HMAC (Key => "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
                 Msg => "dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd",
                 Mac => "125d7342b9ac11cd91a39af48aa17b4f63f175d3");
      Test_HMAC (Key => "0102030405060708090a0b0c0d0e0f10111213141516171819",
                 Msg => "cdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcd",
                 Mac => "4c9007f4026250c6bc8414f9bf50c86c2d7235da");
      Test_HMAC (Key => "0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c",
                 Msg => "Test With Truncation",
                 Mac => "4c1a03424b55e07fe7f27be1d58bb9324a9a5a04",
                 Textmsg => True);
      Test_HMAC (Key => "0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c",
                 Msg => "Test With Truncation",
                 Mac => "4c1a03424b55e07fe7f27be1",
                 Textmsg => True);
      Test_HMAC (Key => "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" &
                        "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
                 Msg => "Test Using Larger Than Block-Size Key - Hash Key First",
                 Mac => "aa4ae5e15272d00e95705637ce8a3b55ed402112",
                 Textmsg => True);
      Test_HMAC (Key => "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" &
                        "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
                 Msg => "Test Using Larger Than Block-Size Key and Larger Than One Block-Size Data",
                 Mac => "e8e99d0f45237d786d6bbaa7965c7808bbff1a91",
                 Textmsg => True);
   end Test_HMAC_RFC ;

   ---------------------------------------------------------------------------
   -- NIST test vectors are from
   --    CAVP Testing: Keyed-Hash Message Authentication Code (HMAC)
   --    https://csrc.nist.gov/CSRC/media/Projects/Cryptographic-Algorithm-Validation-Program/documents/mac/hmactestvectors.zip
   ---------------------------------------------------------------------------

   procedure Test_HMAC_NIST (T : in out Test_Cases.Test_Case'Class)
   is
   begin
      Test_HMAC
        (Key => "82f3b69a1bff4de15c33",
         Msg => "fcd6d98bef45ed6850806e96f255fa0c8114b72873abe8f43c10bea7c1df706f10458e6d4e1c9201f057b8492fa10fe4b541d0fc9d41ef839acff1bc76e3fdfebf2235b5bd0347a9a6303e83152f9f8db941b1b94a8a1ce5c273b55dc94d99a171377969234134e7dad1ab4c8e46d18df4dc016764cf95a11ac4b491a2646be1",
         Mac => "1ba0e66cf72efc349207");
      Test_HMAC
        (Key => "4766e6fe5dffc98a5c50",
         Msg => "d68b828a153f5198c005ee36c0af2ff92e84907517f01d9b7c7993469df5c21078fa356a8c9715ece2414be94e10e547f32cbb8d0582523ed3bb0066046e51722094aa44533d2c876e82db402fbb00a6c2f2cc3487973dfc1674463e81e42a39d9402941f39b5e126bafe864ea1648c0a5be0a912697a87e4f8eabf79cbf130e",
         Mac => "007e4504041a12f9e345");
      Test_HMAC
        (Key => "0f942d98a5c406155967",
         Msg => "f84d0d813d2e9e779e8570bddbdf6fdc6baade5acb3c4cde1618c494d66d45d319e071fec88b89a8354699fbf325f05aea42d345aabc737d00ff1c69c746aeb9015f514927ae6548bd75b8992853fc79c40a78633285fd30ef191c832b0b9664d852142b019f18a05d9b3460246f7a83218a337b099ed43f0bec2daaa8c2e41d",
         Mac => "c19d05a808054b8039f9");
      Test_HMAC
        (Key => "78cb194a958fc1b95e35",
         Msg => "d6eb23c5ea87fd67b943928be0521823dc508acb2ad5f0fdac49e0844ffa4533eb6b5fd66bf00b692d774588aca9eb275c32c383d55cc05834e38155be051bcdc7d818afd3e0c0b8fae197e791f2263206d3fe770c80fbb5f806c67c6b969da232d857386a81a2bce8289090d85652aba3dc438f1769287bc25bb5e19ed6541a",
         Mac => "539d5cbb60739e152196");
      Test_HMAC
        (Key => "2baa6731c367e0f818ab",
         Msg => "a64ec0d93360976b75f50ea532c3d501464a392c00aba572c9bd6977065ebb294007fbf282a43c3203a2ffec054941c0fd4cb919f49e5ba72d88201008f909e2261d62cdce30440f90955d2f2822f3eea5bf277bca2f77e6b42d87d7bdbb2180a1b77ad0dfafb7e962f6afd561f7f37484ca0cb948050316a4d52735ed4d0ae9",
         Mac => "2ddc8c4803e5a4c7871c");
      Test_HMAC
        (Key => "c1f4f1ac1adf93df6e58",
         Msg => "5f458657da5aec73d8aa5e348bedc6af487341593a0a741256222362912fff02514fc09e222d74d9ab251792e0a9636579e3e975a29b6169f45c3fb5a4d2871bfa77e171056ff0a48eafe0fd4a653ea353940d62d9ff16aa15497fdb7f5a9fbf41051158ebe707dd6892e1ff31ebff70c0d0d3a648fe3adda3320c5b8c8ff1f7",
         Mac => "c1ebf896bd26a30cf668");
      Test_HMAC
        (Key => "5de237ba1edadf54d566",
         Msg => "20100ed997ab74370607aeeb0bd2f64f6a56c7040d64fd8a498a380d638c8182531230f3c79f0c176bc2b52668903feb2a51201b677a4ce55ddc9eca5b1a7aaf8260b131cd52a4384f43adcfbca8ba332bcc3b291ac53f95b3a6d9494ef6c91b3661583ab0ae84c239f15d8d1002af4df42de1d72f2b1dc2d351b2314408b6ed",
         Mac => "8a3e105bffc04ba113cd");
      Test_HMAC
        (Key => "ed00f3c4c227d07cf2d1",
         Msg => "3223744302f481dd32a9d4d1ceaf72229b45f413a1e82d3ce70f0dde7e19c574c0842c8ada5f62d28802b37520fcbea7d24dd67e2ed6a804e60d1e8bd6f58440414eea035e08c97613fee95400e18105bf72a16f6af5cd0e5ee2ea473fdd5ff93de8745695d8fdf15a053d1775460563eb1d1c8d5e2ee383d7f639bbc2b99dc7",
         Mac => "4104ef3c144bcfaf8dd3");
      Test_HMAC
        (Key => "3b6af34ae3ea52d3962d",
         Msg => "fb091ddd95b100dfcf892d78e5e770d3a37b8c3885df803c1d6f0935b55b68f136fb65a84862942ebb35d76d26be2413cd3c8988c87d6d2362af189dc07476c6c33417762eb77bc70cf38d814c226dd6af187250e4d47007f1553617d4af5b516a5d3b3191d93c10896a569ba13dd2840fb851781f0b115090086c8b3a34a1fc",
         Mac => "838ba0117e413095d056");
      Test_HMAC
        (Key => "6445f6d884fbd57a1eec",
         Msg => "97f2769dc081f1fd7138ad61bd30743cd81a4565cf22a41a761a3544a2d489fc99cf384fc716303eb3664c09318f29aed81c35acb636080c43c6f8a294dae791d14a600de99be36584237c403a6e9a2602e11f43ed9db46814a75f53ce45573027ab17608ed6b178ceb9658d409772af3eb02cb3da1f4f36d00393debadd80e3",
         Mac => "cdcff19dc81026983e6c");
      Test_HMAC
        (Key => "b9ec31346806acaa9221",
         Msg => "76a69cdd9ff87ee6b07ffe6d496c54560de1e9f64c061acbe059386a5445d3b84cf7385d206d3876cbcf2b8a040335c0aa7cc84f65526a358b98b92c40eaacdae2451b48a41b829578a702ec337fa8b3eb68f205a46d8f632c3367a64487db3800394e84712de4ab81af89791d0736979a4d6f02517f11bb8dd14ac1a844e93c",
         Mac => "f069430eb49866d7d39b");
      Test_HMAC
        (Key => "518a96ff0a44f95d97ee",
         Msg => "3658212a14b65ac3bd9e3d9039c631a94bb43c4e493877852a3abf05e1b5ae53ea04c92b225dfb21db9b43883040a99396ba76bab4e5a45f75d294b25bc7ffd216862f3555d26f49dc30c05bd6ebcdb96d5a2113996598273546139e588d7030e267ba0f551f9c83e7e51cd1d5cf8662f91da5219fc13925951fa6908111eab7",
         Mac => "0f4fae1d2b5960a54b82");
      Test_HMAC
        (Key => "a79032a4f7f740f6d13e",
         Msg => "fcd6d3ab67574d8f0bbf5ad14937966dbd4386a928e62a53ad0dd14a412b31405d20b7bdf55f1c67ae5039824cf31cb369c75b096deaa83dba81a639275afcd8b0d0a7ed6cef9486bfd96e72d068b5003d15100a0e19e432e8d2256c83676cbd5eaf4a42b24fdd73a423a0a9bee087dea0f74cb4f3bc03b99fc7f5ea3e9aab76",
         Mac => "7d809c2533c47f832046");
      Test_HMAC
        (Key => "ab6b1fd8231147512309",
         Msg => "c8f16efe636581b6ab7ab7f39426bd033ddccb8ec50d1b3160ef9f69aa7df3b33bbf91f17b4b4410b70cdfe875422e6305ca2de259a078dc17a203c8eb960b3e226f4c5975cc755f22c2d9a442db67ab565edc8f23d137a1c0bd6d53edb15f55a68909fdf8f0fcec14240eefa2fa50235721405dcaaa40c883c847d055d5d73f",
         Mac => "0c7799c513f4a3308de3");
      Test_HMAC
        (Key => "d7f2be75aaebb90d87a8",
         Msg => "cad534c86629fc600b38138a7f3e1a701bc4bd1f865f96dac39a4eb46e31065e4280f53ddf3a52bfca5e74f0b667384802c4a3c78287c8458261ec0308cee9855a8dd0a4c053d2df8bc061f2569292aa8c19c6f72beb8943c7d8ba02d120ed8a19e40d2592db4665554621b8e926f13cc2ac6fd507f1a17c99e700da5090d915",
         Mac => "00e416c156dc85d4d47d");
      Test_HMAC
        (Key => "1379a7afcc0905a5fc81",
         Msg => "96fa5619fac648843db788cb8e90dc6ffd6efe1332abf0815f0390ee73f56c7f916cd70cc09f3d23e436b350edaed29b4efec653b07ba20ae8f9f6e12733a406716def7a5157d518ca359fd3903db63f7940b8532e8dcb6d26133296d5c51e072043c6ed15b6b96ad9fb73dce1052f61657cfd9b12aa14b000986995e374818d",
         Mac => "42537b22520a085577587616");
      Test_HMAC
        (Key => "80a0db49d039b316ae12",
         Msg => "91f8ec848d6f811431cbdeee150b93af6f678be99c903f81fc38295503d57c228da212a672e7a6015b7b4361d487fcdea28cdea356a8234f2215a89becf2a23ca1468c0bcc42646367c616caf02739d4c030f945996654767e908afac777ce8074eb42fbc2062201fcb53f719473b0597258c4178c533bbeb7b4b5bbbced6ab8",
         Mac => "ecae138322d2d4086aa2bec6");
      Test_HMAC
        (Key => "261812249e1338ac5a22",
         Msg => "5a529114ba6bdab69bada5e8916fb6eb222c71256f919dd117d369f65846ac95772c712762cab34795c265ab3a9cb65894a692169dfe6c22eeed3b24e076c260f12f1530695059b23d0acbbe331a041b479d7bf24d264b82d90e36165c0bea348f048418152453615c2ede09c410289a03ba329fc830c2599ede63b4132dad79",
         Mac => "2fe2bd1355a64e4661a6567a");
      Test_HMAC
        (Key => "07a27c1b24094dd9a0b9",
         Msg => "f6d9565ef97ea11748689e263f52b4af880ff5c8ed1295226a34a1ec87b2edf4e5754f1016970abcb1228d04a61b5ea5d0bf516fc90cfded02837048132d22694fdc285e9cb3aaff82e897d181c9972aa8fd4296630d8f7a95238ff7e6115b115f944b1134da6827e04324547765498738523007621d33104a9a64c1a9668036",
         Mac => "144d3a67685bf4ac70bb7fe6");
      Test_HMAC
        (Key => "aeb526731e1d0ca809f6",
         Msg => "68de2a68bd4215ac21bfe2b6f0d26ffd90d4ffc9f972dd47745e43dda24479bbc10041b32b0e734a1f41e50fc4b88d2b6b0fea3a15d29f5935376280b70c141340ee31b3b8bc6b5a064b92a71a5bb77631ca91b45408207222cb8f37d0045f9b6e11c2116c3445055c44b227f9a23506696fbde0bffca5b8c48294aaf714a27c",
         Mac => "c3b94fdb9a6bc9b8e0b7ecb4");
      Test_HMAC
        (Key => "bce413c5612019be937e",
         Msg => "e1db8f7bcc0e5c22eea3e8dce39ac250c8681d3095f8c861adf0605cb435c4d4a1b1c99914542fbce958d4f40dca28409046e1cefc02f01ce60db35dc2d96c1efcf8f2294423a6a92980a990e9254c3687d8c8421f1830ce7762a3c6d6adc691193771f40383a933d5a2cf791eb31679d5a63b56a54570c08874996197b7ba77",
         Mac => "2eca333903bf60931eb08ba7");
      Test_HMAC
        (Key => "10fd56ddc8f64b9fd800",
         Msg => "285d7249ef30bf4b6e5f6bdc3cba5570c77f115de0d08aee7a63ecb2ae7cc11a03185a43ed6b7011938d0b7dd571a3308e1685501601799a0ceaa2b152b6a5b558a50e189ecdefad74c7c90205a8b0f09332ab70044c5ab09eb0db670fe4ed65b06b566e0a3c83489a736f13d147c6d95f3c4966b199745ab81d5e7cedeee251",
         Mac => "04614d9e215e11546ef411dd");
      Test_HMAC
        (Key => "8b09ea6af3ed29288222",
         Msg => "2b7e03680c9ca6c759b6929383cadf567e4e38dd7216313cb477db12f4ad970eb87a27b209100b576b310a7213950f15558c36b95ce4273a1d0da3238d7b5c2c124c0a01382bbb45a6746ad75098d454eec487ddacbd3c1a230f667e88660bcd233cd3dc03b45f99f1c6db4aa29dd71a313d52d1cc6918e3adc44fac4b364cfa",
         Mac => "f5ec42b8e5e3ef658223c8a1");
      Test_HMAC
        (Key => "71ab12ca4795505deadd",
         Msg => "5988c794c1f1e85d23d65be040c0129bb8a6bbccd86c3b1eb3a9588774adb571f2c3041885b37733198b77d6809f99970dcfcef05e08dae4790e07e51b781af64cfc860d37ece0bb3901930e3858d5b736bad96825204680fd76e9ea0da0a6428ebbb53a7ea50b3dacbf15520ff1ac425bef46fdd6bb693a686c665ef22d439f",
         Mac => "a055bb1256afef8fac818a39");
      Test_HMAC
        (Key => "5f24aa8bbc1eca3eab79",
         Msg => "e8bfc5c09ec4807319d8f7369556e7654e981639e8c5dd3f0feae3085b4d2b2276fe514880ae10d6b2c4088042aebe428775e59a5e95dcf6cc0b7768e5af02a1ecc4831dbbce409b65a381d01bc5975c4cef1dfd10ee7e03c7b2b804fda55fd0923ce4a717cb17aa7a9deb90e644799ae52e48c9c879cc4e48082c426dd74997",
         Mac => "449a3eaf1aaeedc860a7c522");
      Test_HMAC
        (Key => "be881a061074ed05e5ba",
         Msg => "7d70cff8df77770eaf0ce671b7a15daf5bdd75482ae15812b3cf30dc9a8de052ebc6f321ad32d15bbb18391ccf11eb6ee00ea56aae9c51a09b677db9bcfd0b5b30d52a4db09085dc687eba7d05640db3107d5e337abe5847785eec709196fd4ff4a65dc51018f95a5f4850db82242a47933186edb7cfd4cef2bd644840df1ff6",
         Mac => "d991f360f28b18086fc552f6");
      Test_HMAC
        (Key => "67f385228039427df681",
         Msg => "f9598e9f4ece159beb897317f625a6a708e9aaeb8e9df706709c4c52f12bab53d709a4e9cb48d7c9025ab52d1d6f86cb4effb004bda2365f2a287f35d3e659ae984e3dec5dc3d585b0abbb37abc584d71cbcfd8be4fdb4399dc6ba3f8080a865854fe00fcbe715b83ba10e9b69cea6b3ba4b18e6cc56797e129f86d8bfa2a060",
         Mac => "3f99eb6518dcdcfb45eda5e8");
      Test_HMAC
        (Key => "ed01edde5f8bee443346",
         Msg => "0f80ccfe5ade386b40e43f48136aedbe69849330274b761edee1c44a5bafcc1979f16d3b3a75cf8e169f524093b1c4351649d7a8f92cd214dd41865542e1840a554e8d3f08804a4968283df02ceff8d489fe8d094ec445052cf395bc55cc4d094a9d1350ed881062de85e9a004aaf1646aab9d9c4d9d38b873ffd7c7befa90dc",
         Mac => "e4183c3f9245e63ac093e070");
      Test_HMAC
        (Key => "ab692b9e0d9cc9632754",
         Msg => "49867dfd015a50df8c676141eeef02fa2c347515bb25028d393d47555ba9d09b27a9e74e6338adde4def6a438c272240675e69e935dc776314957febde523d19590ccf66ae98c5ed1d8a7b6eee53a798abac2e888c383c8d3364932e9993236e4978db4eccc2c09464ff3ccbfdbab88b60e76dfaaa827693fc722a2675b3aa20",
         Mac => "6a31ddbafa486d1a847e0b1a");
      Test_HMAC
        (Key => "2541c892495452ed89dc",
         Msg => "204cdf0f384280e3d55f8dd010e88666080d2d722a1ce7cfaff5647f65be82fab3d86fc6d7110e48731b9dda483d941e4148d091b3cdf063e38d0086c9315505133bb7976d3dc6740048966738a89d24cbcecfddf78e07100b8ba9a328ef8532495fffa8812e6d0c84d0c19e69926823ae89727d7dc8f27e2dd6a8fe0c60dd2b",
         Mac => "e2cfa49f38958405705dc320");
      Test_HMAC
        (Key => "f5731a6e8925f74306fa",
         Msg => "44c7cc06ad290f3a54a970b640014cb5d1e6182352459901cdcd570c23ad4f995b9fe8c43b2528c9151228b2e44dc53398d299d2adf92a4a02fb6032e9b23dda7aa0c8762e334a7ea947bd54d6ed8228396b52198184779c5df93c22914fa2f549d35463addcdd1fb55019e43f69e95b5fb92b3ff66ceabf86ced124440de6b3",
         Mac => "73b083d8be0d19ee7a697f9e5d76362f");
      Test_HMAC
        (Key => "290566d777b0eee984fa",
         Msg => "787fdaa90a2de3937e7942e6711f165a89b9e077fe322cab597d749a7c8741b5e36a930e29e3836ace0627983730b602f63eec824cfcb077ece0f51702f9de0774222529687bbdb5061ab68b7ffd62c74e43b696be9cf249acff85a88e9b2a89b40f58a1ceddd999af1cb864506e61d11832045c5afb3a4a2040ebf527556f64",
         Mac => "d72b370a1d8290105173c83aeedb8358");
      Test_HMAC
        (Key => "a7e54ce234b0d5c839b8",
         Msg => "f9a9c16e3a4beff0d36430c0e7e1d6bd68349498d240d8dc19755a2cdf3cf5cceb95b764d7fe340008981f5ae4851b5c3e94cee1152037bc7f3542fbe0f59a6d5f3abf619b7d58b199f7caff0205093f8bd1af75b42f4bc0b5c5fb98b56f3d543ee202efee8f040b6fca5a36a92b496d35345ede1535b9f2a36dac8bc872858b",
         Mac => "657db872e6e9aefcc3d69110c7591057");
      Test_HMAC
        (Key => "2918c7779c43fdf21748",
         Msg => "b949df3b02871bea0976873a9c76942ac934ce63ac2956d2856492970d8a231e0b1b178b22f6605ced2085494ec1986f026f68ae79aff750e5b92feb927cd08875e2ad04075518b754829b544e5de910686513076029ffdb5c0b179e39443ef22028086e5aab2a4465252f2147526d55229d3834099e55bc12e1b178ace953a3",
         Mac => "7bc8883375527df5ac60fe47357e105e");
      Test_HMAC
        (Key => "9e8c665ba53854f0fd27",
         Msg => "850d673723789c780040620ad945ece61850a94f41efc64c8c81f45bd48d6b64af582eecdfb6918be920f9a00307e4433368297bb6a180b19f834465c0a87820cd0609aabfc5527c774ee578a4a589d8e6f87f6534780ae97b672ee68772b78827427dd98c4ee734f3f3aefc84c6e38d79293473821c6bdb68563746f1952f85",
         Mac => "805a8f3cbb5ce17139cf8bb03db6b9b4");
      Test_HMAC
        (Key => "41164988752465a8f929",
         Msg => "b4c30b451325a9621e258a5d91de6dcb421cfe7957c1a7f5b667aa50bd466d23345814d07fbc550a185988983dc3fe55e662947cfad18822c2848b049eae1783f76102ed74f754fe71b256a7ad9feb0d42c023d5db690e9f21ebced07670f095e626fd255aa04b460f791912473adbfb3f7dd30d6053e173b9e49c3dad55a160",
         Mac => "b9b6e8e09db8509ac5a6609ad5e6390b");
      Test_HMAC
        (Key => "ea66bf3a628dd1a968c9",
         Msg => "487ee933a49275727c8e36588e4c68c295a5516ab441c85b18aef8a9dab0625e22d821b792587291e216731ec7ff2bdc1a9ecbc836ed33cfa26bb885f06e2519e4bbff89d9540e12619118eb2c72f0322b34b027f422429869ae259c94c06d84d64e0c0f412d51dd4227ae26834dbeac0f8e86eeb889fc9fb6a0c556904e4387",
         Mac => "571b3401f273a16d9d6011993c78bcfc");
      Test_HMAC
        (Key => "14f43e5424ac9aeb97e7",
         Msg => "9c3a8524f8d6d9ec907be803baefee0aa08b74ad4ff60f860a334a3ee4dee1f68eb230e56d4fea42ef3a0e642026172878727493f7f237b875f211dc33787ed9b5ca3dc0d43003c20ffb705122c64282dafcc9b6279b9b79733788aa3241d0ddba8994fd55028b3695c5f611e859d6e16c325c5f0577a191ac0997f00ac040c9",
         Mac => "6c82c5f72dba335ff85181131dbeb990");
      Test_HMAC
        (Key => "6251c2a2976b8757adca",
         Msg => "f1f9c895ab63fcdd69aed763d998a788e92ddb5294477313fc56b545ba5d22b9723da8f1aa3619cadcabdc5dc925e328119bdc6901f1accbacbe19443d52c63e8bf865f5ee78282052e078d38984eaa4e6446f0d070dcb11f2a34822649dab4365b1676a20311128f2d6148bc1bda6448faffa054ea5b72df68baaa7d645b70f",
         Mac => "9502475fa252e5bf4318e451c7f5fe41");
      Test_HMAC
        (Key => "036fc94fafab92ba5539",
         Msg => "5b1a6754c3c30cc29d041779325922781454897c9c3f7cc69703521e3d49201863de8b96f15cda8e9507500eb9f5b87db37241233ca28cec2468046844876e17b307c0e43ddb37ef10c0a48fb96807984fd85ed9ee0fbfe967e8a524364188f0b55db0458f874a6c76f8bc0619fb3651504f89a79acd3d47ca4add58fdbf962b",
         Mac => "736c3332227a1b48acce71465f5726cb");
      Test_HMAC
        (Key => "c07d47559b6759f09651",
         Msg => "434a42273f11fc06bc8eed402450f1915399d7e0a71c12205605b174053a929696e0d2794122872de62db204a17f6ff3a0626f3a31b3a8471fe84bd83f52f761469e2caddda202c7f8571b1b6321d6d99d57c59aeaff6246a4d9fd35d2a0f994fc8c380b3d1bd49c991110cf91bd8e0cf57fc248fa87a6e48cdfafd1e5ac00f9",
         Mac => "66af7ccfa98bcb8d01ead88d046f1038");
      Test_HMAC
        (Key => "a32e28d4b458ceb7cb13",
         Msg => "f753f3e9b4bd1895a259492ba160713f00ac8e24dbbfab0da7070e720b61b2b6f1dbf806debe99847eccdfa584c615d7b1313c68315affa32e98e93ca0d1d6ee623fa7628b743a53fb9c9af0340372816cd7c84ee02ee7bc6a4a9dba561ca75b72086ac464e8e4494053e1d35a1f728559249b9f8d434ca283a892b5d64b0f47",
         Mac => "2993b746cb98445019cb1ed31ed34070");
      Test_HMAC
        (Key => "9fc05ef49579aaef45c0",
         Msg => "c5ff34dd398c10fc020277ab85050c51a1c4d238887e9b34cd46c386be031dfff3ba2e6927109922470adb0ac918389f3f52f5672c01c88f16618dd1dca53a9b4a3c156deb5325821e9be6b46c4c419a196abaf3f947ec47854932cb2eeda886f20c52b22c5d9a65b03c007017a90d87589488a39958eda544851b3c5ce24d08",
         Mac => "287a4765a91fe81c21c4593f985a1253");
      Test_HMAC
        (Key => "fe5df14e5888fad138ea",
         Msg => "5e09b42139c3e0c709527f4f86d73697aabcdbec1d518accf1b7f6f08ffefe8af18a81cb12bb72a8a3cd2fde00fc0e3362ec39ff5649bdec6eaaddfa36bcacc6699cdb0b6584cf69ddaaf665ce655cb2b49279affd364e30be65b081a562e3a82f076aeb1a671e921eb37eeed85a469a07744301fa61652049ad168ec437cab9",
         Mac => "a8483672c40305d7630f3e86b80fa4b0");
      Test_HMAC
        (Key => "6c56890c603bd3833d21",
         Msg => "6ed7bb6653ef66ce21b7ba0ee616d07114c64d9228642b158ac3bc94b486ebdc97eec65a3af039d0a58b1c4cfd58715bf063e67a5439a2cd0a423d14295110da587ab0ef7c24b519945ec007e077bc8649c863f8fdd504015a9584830d0da4cd7b24810f60b26111b5daac25d89a395be7a0cbf36c5fdc18406399cba9e12d1d",
         Mac => "a7df6225fc8a9bc8b91e4c39eef870eb");
      Test_HMAC
        (Key => "59785928d72516e31272",
         Msg => "a3ce8899df1022e8d2d539b47bf0e309c66f84095e21438ec355bf119ce5fdcb4e73a619cdf36f25b369d8c38ff419997f0c59830108223606e31223483fd39edeaa4d3f0d21198862d239c9fd26074130ff6c86493f5227ab895c8f244bd42c7afce5d147a20a590798c68e708e964902d124dadecdbda9dbd0051ed710e9bf",
         Mac => "3c8162589aafaee024fc9a5ca50dd2336fe3eb28");
      Test_HMAC
        (Key => "c52109c9d0da9258eb73",
         Msg => "52b113614b80b970510f65a25d46edc023d9c7b8e7ca7c41923059c205366870ad669fb7572856dc4685ffe0833111a775c9455ab1590509132121950e99c5cd40b2a8d74a5f85d2de54cfb91a0da18a1413f4a8b67b147eccaf55665b7101c9341c9687ca2d2e9941033ff5c7e384b1273f3b6c9b3891eae2615bfe93c606ad",
         Mac => "2fecb466bc920f610e3eae9949e00f454a714ab5");
      Test_HMAC
        (Key => "aa6197d4afd5eef5187a",
         Msg => "9f3360cf8f5465c7d24d7cbd7bef00315cd4f4ac29f245f6db714e8853baa14440d1056442e4bbb1502406f557d3eab2239e3314832eb925a8fae340cf5f6ac820f25f19d51570bf9ec867e744c2f3128dc1ab11611e502d2aa452a681a2965f063f77d78f0e0b5b86e2a77a8ce4a5ba62e264890aea91762918a5a1b0acaf70",
         Mac => "3745829991354a1eb42277bb9aff04ab2abcaa47");
      Test_HMAC
        (Key => "9e0be94ed707458d5cec",
         Msg => "f5a07e3741f03174c6efcb1f9f186d1f233b367073c56e814f4204db2e203b048db6a0a387853fe4a6bd161ef903cab46671993942de90d71f60fef1e5102807250d3edaa9c48ed1506ef89c19d9a2177d6ced710266a78d0d6682a8f730c43d64ae4125d03586036b0a58df27255d110f341861dae31b6cc05b774a8c08786d",
         Mac => "e7c051682dfbbdecc828606868a8fe2eb85919ba");
      Test_HMAC
        (Key => "65e06954b0350fb3db19",
         Msg => "da82641c0e59bfabc0618cd5cfcec107050ca4c1ed4b3b3fe93b04587f14e7a6f4da69e71cdf22a37089711061556e32ec1c20466f96f161bb1c5e556ab2f3d4734477d8fb3064416e059ac0cf8a53f54c035ad416af784d6f952f2c0581ab3e7e49f6b554546bcde35d6db0c07559974d47b8338aa0ba4b2e2fe0a6f789f82b",
         Mac => "60d775c440e378a5b3df018edb08c33c063bd8a5");
      Test_HMAC
        (Key => "e89defd40777fe173167",
         Msg => "1a40e896d0c0c13e7824c3ef86e02355feb629ea887ce4d2c71f1d02e7e889a875fe42c7742d7822ade5645c46867e5d96daf0f838e34aca5ed87765686af0aeb64b2f83baf167a1519872c553860b1268923db31ee71bc13906b2674b0a3c4484309710ca96f5830c43d472d468313c1ce5f864630fc07f00b1b551b551d533",
         Mac => "3fdaec4c28dd5758d937efb8cd4ada0cd40a5d13");
      Test_HMAC
        (Key => "1501b98cd2b030d62660",
         Msg => "5935a870229c7251fcd0c5c6956144f251ab2a39d74de951d0dc119cebd872b525de854947200828b013e99b546765f9053c7175f293593a6d02a7baf1ad46426371e7d29862a42d1878e32c21857e57ef6a21b63b8bf3e502807867870eb63c9b5596b61c4a8e88bc687d2003a3d637989e01a6bc1dfe7b17bd4c4cb7e309cb",
         Mac => "c3b30827b4e2bba31b6fc0985fa597eb4896c7a2");
      Test_HMAC
        (Key => "bc28be9d8fbb1d766360",
         Msg => "eb5de69eb1371bfce00ab629a1362f0d4885af7a71f9c90f4ec9655d3fa6fc49a3420bb1ef13c153fd55fbeaa64e739992d5348d4f1552dfa18fd7b7195e00b7e9bfaa97f7d0070c309895ef1f48519bbec028978c55ae75dfd212f97cbc527e65dbab96f2f554f123dd6b8035ad30d9734f71de4f424599b19afd6b8f495866",
         Mac => "d7264b214307520629ee5e76aa4a8dda4b556b3a");
      Test_HMAC
        (Key => "aff7d836880232f8132d",
         Msg => "10ca186baa79d9029eb618a2e5a636b9893b30e20b062258034c0ab1065bcfc9cc1e82fc92f0e398beae2791c210f8774239bea6798c1dbdd9c2be51f13953e2948fd50d387010049cac623cae8dc065ab67f99f88703feb91d2e3df50ff609fb0459b0862a2692e80d9520970c5956b0cee6b35ff5a90cb72a600c5e955fee8",
         Mac => "42ddd9b92c2a45420a770b9727bf53dcffc84d20");
      Test_HMAC
        (Key => "efe1c65a8a230e96cfa6",
         Msg => "5369745bbccbba88780ed2e2cc2d57e2591d02b5aa0cd59d0ae79995981e8b349dab53d31c5135f2ab218bd88243737ad2f3c59e58ca4840313f2535f06d9b0eee17f53fe1e9b981b000237486add1892676c01f7e5e77ec7e67829f2a5422c3eeb343e7321baefc2fb380fe01f3dbd7fdafdb804451cc6998669a1b6f5c881c",
         Mac => "b099c135065fb0c4c71a4fcb37a95b13cff95437");
      Test_HMAC
        (Key => "4fb2514d3d73b4770a69",
         Msg => "a413ed98dd6e0901b1074381e1a90d59fbb60e2282bd6706494f3a2f200f6d80b209ab83ae45aca3259bb79c34c8652fe2c2a71a4b490a47ffbf3a44a539c5f3e4d622838350f29eced085e43c07a099507a7e9abd1d1496cd249a7a0316462d00235b7ea3b7625b744fb743438c48fd0c859a8b1e620d5a7c2760bb84cd7797",
         Mac => "d8fdc66e0c97c0738f236f3dde60af8ac6c3d29a");
      Test_HMAC
        (Key => "1b6c5146ea28dca9f6a4",
         Msg => "25aee305cda093a71094bc5ca6f570fbd67fcb4239f3d724c00fad64f8bddd638d8b10370e5becfcef5b386fd43841b90d8f7c885ca56c64ff57c641ea54d4505589171b76dd30d1901f01de2c3c0fbfa6b62a15ec5151f88310d08dcb5fabdb83923fda8f8e27cdf9c65dd2376aa1b8acda1f1071614c875420117321482bab",
         Mac => "be13212ac81902215c85a7697a2d1870ef74f9ac");
      Test_HMAC
        (Key => "2d544e003b09cde4a4c7",
         Msg => "9d31b168ce6ec3184d7c36243acb4e1404d81dfd82f73f603f4fc84f15267bd1fd5f3d882540c9914379a4ac2a62549d9a85cdd25d5c2c458f5ca7a43e32c4b0334ccae30e9b75559997eee05684fa825af472045e8ef3d9140dd649b78c63cfe60041bfb206312bf6dffd08e7b8aa8deb2ff5dcaf14fee4736c3e86a9bcbef6",
         Mac => "c87995813b3156fd712c511c328bace2d05cab41");
      Test_HMAC
        (Key => "1b5cddff531babb51b4c",
         Msg => "a785aba75e6829f93f7a141c715763b64effeed00ce131899d394c0bd39c4fbfc8d1b5bd7de32e87c174a2f6555472744d53016cb95373ff85a1b4f99e85bc035617121a0a558f3f02736570987260d89df46b43f84f55d490e0d5fa6da2cca01afecba44de5d58bc91d667384d8b348058b343b11fd6070869fb8f7871b06fe",
         Mac => "57e9692b230b55a8a206ca48838d8d1f920202b6");
      Test_HMAC
        (Key => "8d8d15d8a9579adb2d62",
         Msg => "edb2ba099961d38fd0a0a6a235d61271cb4d493b64d9de135cbb1fe086c4a4a767be280da2079817b47f6a35e1a4307f6efc6d3e11b4a7aea686bd0223e07ba9ce426cd0aee7ef283fa98de96a1f8a17b308ba04b5ec9616cb008fca114ba3f98b072d5aa34a0149d9e5b8c6b68c49c10138da9536cad5d234f13d3f364d431f",
         Mac => "0c662e4793938cc37f3d51d2b40548ec55914f0d");
      Test_HMAC
        (Key => "191a700f3dc560a589f9c2ca784e970cb1e552a0e6b3df54fc1ce3c56cc446d2",
         Msg => "1948c7120a0618c544a39e5957408b89220ae398ec053039b00978adb70a6c2b6c9ce2846db58507deb5cba202a5284b0cbc829e3228e4c8040b76a3fcc3ad22566ebff021ad5a5497a99558aa54272adff2d6c25fd733c54c7285aa518a031b7dc8469e5176fd741786e3c176d6eeee44b2c94c9b9b85fa2f468c08dee8d6dc",
         Mac => "402493fac26c2454d0cb");
      Test_HMAC
        (Key => "dcb463a13ae337414151a31aa0c3e8bab3ee781b9f3aaa869dc5b1b196abcf2b",
         Msg => "44c9bf3ae8f14cc9d6935deda3c24de69c67f0885a87c89996c47c7b3e27850ac71c2bc8c6beb038ba55cb872c1d5871fb4a4d63f148f0dd9947471b55f7d0f4ab907302e016b503c8db2e7fdc453dac8dd1fa8ed8586c621b92fd3d27d82af1962e7f305f80c3f4a72c701ddac1665cfb06df51383fa6f0c2ab8429db51fbc8",
         Mac => "b96de3a219d76614aaa4");
      Test_HMAC
        (Key => "93e7402cb2b1b594670e656a6ca4ef247231ac09b7cce194d76e3919e4b072aa",
         Msg => "cb2a072d74a5749481030ee46edce28c471ef412c8a4814ac40b87cbc3c188a3ef5e8a4a313862d59731326cf9d431fedca1aa3396a448a3b34d9045987baf2a66da766b216fa36012716212695b13f3273f4ecd3b5d24f9ebf4a8d17658af67f845d3788d73be9bb96aa5be089812d3f1a1e7c700f6a0b435a9d857a7800ec4",
         Mac => "2eb0b56949f78f796b9b");
      Test_HMAC
        (Key => "ac286e206d88a3c00e6705df211b5ead6a693625445351874131790911037ec9",
         Msg => "c7f4612dc47f7ce6b499af0a51e4a3ecb2ef40251cb420351c65436dd268040c90a04ba8a4ee05cf71f7d1efc528fc7366f8b02fee6d68fed9e2a7a9dd07ea0b7a29db73d1b4c74ab9f652f610256afd4fa4796e6182df7db6449f6d93e458b3ac197858f4d9ac9fb41c9be8dae4d3d4947a03aa1efa6cf9d911927f9c06374a",
         Mac => "5cee7667d0a29278aea8");
      Test_HMAC
        (Key => "d50ff2c5448b5c2b695f61dc55de55ee96f7bbe57067ae856a2d80e50d3ea0c5",
         Msg => "4c259ed53a1faa09d9cf2a1454cc2e5acfb3ab8893bfc3ca6b9a473f4d737baa3d51196a6fa798acac28addff6dc13686f74889777db18da150d9d31982c87e27ed1d96e94a074c35f1f98b3bbc8a8a5c25c2d8bef7b1e1483725f222854877ed54ce6cbf131c7b8bb5bf27ae9b5757a8f14a44a43c75fde7f7093f9471203e5",
         Mac => "476d8d8db76e87df0a3f");
      Test_HMAC
        (Key => "607e645e1bd7fcefa0e34602d34471dd71173130ff1c59530017acd06b76f021",
         Msg => "1b8747af6d82c61f98ccc3d79c7acebe18bd1fb5b0ba1f15b1952b58f8cf941610d3ea349acb7a58f2b8159f0fc21393abcc9857a44c1625a35a13fbfb072d90d4ef5b8d881275fa4ddff7f6159202acb2c0a3823e305893baedd060f599f3c2af042224fffec0eef269f1447592a1f175c1c99e440eed483f77eaf1ae30ee95",
         Mac => "3bddf9f7384c84b3a66d");
      Test_HMAC
        (Key => "ba60ee3734a54ae42cfeb678233ecafd8d55c783ca742865577279cd466f6c7a",
         Msg => "4617b323bc286d7680df7eddc101aecfa46c6dcc394367a1ae4b5ae8c29524ce7d5e21191e33b369565922bdb36ba73a5f45c3280a21d53e2500ec1f514cda2417bb8a5cd97693d1087b0c0d983fa3ddb198e955a8dbf0142d4118cac69026f77cf796f5d3393338000ee4d557c6c941032f865bf9b9dfad2fd886ef08aa30cd",
         Mac => "c4b0bc18c2784c858754");
      Test_HMAC
        (Key => "861ae84f596bd23cd37970454e8908686022111154b546e1da84faaefdbcabcb",
         Msg => "a0cfcc6559f2bdc8d0efe0519e8d311d3af585bfbf666d90ef2b5d4678ca0ec9777f20423be804744b02194faa5415c2596aa7d21e855be98491bd702357c19f21f46294f98a8aa37b3532ee1541ca35509adbef9d83eb99528ba14ef0bd2998a718da861c3f16fe6971725565ba171d276b693ec5c9e6496102500867650e5a",
         Mac => "e42a3482a658c651f55c");
      Test_HMAC
        (Key => "304e23c570eb7887270d73abba9c3268d0ae42aafb9e62c09a5e8954fe0e2aa1",
         Msg => "2fa33c03ada40c598f8800e017dc802a1c6a3ff0ff5ecb58e1a7637713a00815cef0d6b125af95c537ca8c4ca9a89580540d77e83a3f6f92bf68109e163c4efcf9dbd5759df99ff0e53cc5eed6e595584bb3e67ae904a84f563ebfffa66d12a6162ede57fdcb5161ffa754d084dda837682434adf5f69d160ef118a4ac7d7c9d",
         Mac => "d623d5ce7f0e22c269af");
      Test_HMAC
        (Key => "cb3c6fb3fcd464d5d2dcebac4fa41cba7a60706d9c888ba1af7e586714725b05",
         Msg => "0f546834a313fe3981ef450f3e3b16bc184e3d6bdad57e65006ed63c1c72024978114659fda567a45340f9ff4a87e15279c4124b25369a5464ace2c381523151a3ca73ceaa7e39135a350037bbe5b606bfc87aae26b2a4bc9fa205473097706bd7a578fa72477c6ddcf7e12159fc9fc03484fffca6f2a384fa79c630efeac57f",
         Mac => "6cc56c226b22110fb13d");
      Test_HMAC
        (Key => "d50df8aba7273e6427ea6bc0a4fdd4d5b0364f336cc696b906b1edae7f82050d",
         Msg => "6fb3ec66f9eb070a719bebbe708b93a65b201b78e2d26d8cccdf1c33f741904a9ade640fce000c334d04bb30795683dca09dbf3e7e32aea103d760e857a6d6211c47655df3665bbe4164e5d1334d301eff0bcffe6dd95dad97fa63a0ecaa7b197b55b6f86f073cd4d524324aa659e19501d2145fb8adc1d70eafec04bf36c959",
         Mac => "51ae4aaf0de1921b08cb");
      Test_HMAC
        (Key => "1daebe36007d26b988f8c4fcaa0b5a07658ef6ff528325927d98649673f4d7ec",
         Msg => "1d7f6833333d6f99cc4de86dcb1a668af36966074c31d4adc9acd0ae27aeb19318364a77a1426d73c1e8ae5953a369a535eb07b0aa087c27fd2714bc68ae701b33cdcb202055834707ced464bec4e6943b610a73fd41408fa881fe1def192cebb66c7396781eb7fde726e2f5d324e43f4df4f8b70c8328cd10e113398498eeeb",
         Mac => "a03712aad2fc0e59732d");
      Test_HMAC
        (Key => "fdefd6dbd43cb817b132754633c0ce724be5572e4e732b7d4813ddef9489b20d",
         Msg => "3f5fe1a8a13c8357149f68bce47360bd6e73c98932ec4a7d2ac4c5495bbb864ea9f1c14befa93b394f4c4773c7b1f41a059b85b87d832123b898cca5ef059659d87212d8c0cd0a15da4a7186d7a89985b6b7a7f5de1743286a429400c4cc6b5575eabe973b3259b55ca1d03d3be2b8c429cd16887d2f1854e7c903a4019b6d0a",
         Mac => "af6a6235395d057c6d2a");
      Test_HMAC
        (Key => "e32e6acc16d4f6ed9cc3e23ac65a259c65704a3f8437c598576687a76e97d079",
         Msg => "a04d563eec5c909dee3f6fa8133c70f862d46333b9f5cade59718273a4afa5b426a1ae3ed3f5de618f90df2ff438a8d34f90a025eb4a067b939890c152e352cc7dc0e2ebf320babfa4c6dd4d50ffbe52918d5dd61ce4b30444995039c017435bad943a6cd743ea5f34cbb12ab1f97a1c31b1e271d32b9924745c0a0476b13e0a",
         Mac => "190e04e5dfa9eab70cce");
      Test_HMAC
        (Key => "128ffb7d52b710de97ee921cc9d2bc5e0750d3a2e10dfc49c80550d6c27332f3",
         Msg => "bec8d88f65e49567f23cc953d9ca9bad9a5ab34f38334c55edf98a251cd20ead87c8c9ecc26f0db4e8c7eaae8c63b79ef2cbefe87f203f546ffedc0ec6a61af1895d3b042d0f8445503897a6a705fc5638b60141c946c4da984e8e184c2762be2c4ed6e08f0d22a39358774412f6925cd2e19062fcee0471d0b0474b969a0f9f",
         Mac => "2394aef32f606989812a");
      Test_HMAC
        (Key => "a12794057de3b3ea426fbe0195ee17b4873ef7e6ba87b22bc6143c38da62ec98",
         Msg => "d199875bb7071c434ab236e6d10f8405978fca259f7c34939424eaa6ff3ae444bd7900a7af8a5161b328ba9ed382bcaabde18db3738a6acf44e62d41fbe022f8568f1758ba15b23d24c7083d638e6a2e858c82e88f03a04c71734e8638032a8e8622f5f53f6ee7de86d5454be8fa369ad6dad34f59af7d13011573fd1f6ba311",
         Mac => "445aa92b032c6b65b28a6541");
      Test_HMAC
        (Key => "2a432b462ebb78835008b4aa8a92b40f6fe9dc53a963352ea507c06c8da90a36",
         Msg => "ac76a7db964e9fad2f98c18c06f929f23b6217ee35ef4525920f771764e653a39aef73cdbce6b9c0dce5e20fc9cd5e4085e75f8bf9cb31dfe881c92622e7a0cafa52c278f9782124d48e304d9cadad82357abe250906406ffdf35cb4a5d95be8b3e7bb63b6ce82e101dad2cde862bebf33635c43cc681bdcbbad574854832b06",
         Mac => "2f8e18b75cb37402d6e87355");
      Test_HMAC
        (Key => "232eabc478501f246e73e76bf0227e0356a4161f97687540baa702fe8e442005",
         Msg => "bf465c887060c762cccd43e4a65c76e9fd685f44e7fdea03c83dc2f5c702676983c5803901bf7207ea4d31c7f399577d9c7773481d8da3a09db765dca6aaaaf7d6d72c93d792023e917371f59dfc06e6fd7de17a0b355493b0baad13d69b4f9d2043089fd8209e902905ab768ecdabac8a4254e29a3d2665680e42a1411d7fe4",
         Mac => "9dc9ffa7894d69c67295c994");
      Test_HMAC
        (Key => "aae20e01f6185d8073f40fd7648098fcfaf3dd8b6c7becb14a39ea480e8d4c43",
         Msg => "635a508c6c44c1eb78e3dbf5961acab6ee7d9b92a8aa473609dcedcedfbd5f78207ce0f9ce202cb01d1cb9c8d8233db1013d70d0b81b13755da7310ef9e0a59bdae5dc627e4fdce4b3c4850ffbca17b535d8f53d7ab3a99946f82778d8f456bcdbbccc2e457ad9708006c834c8b661acd476b341b81b10880af4587243a27bc3",
         Mac => "a246956f07f6af8830fcd392");
      Test_HMAC
        (Key => "58d259d3651b6533f98cd0f7da9cc4f3a251bc02cd063bed116bbe8feecdef37",
         Msg => "6349e3265d2630d1e14bea680d342ce9f76aefb789027f3d8f6630d50e584ce8d73351565d745918c47ada243a8a8f908a16b6fbee3f7c292598b6edc62dd14cd4c40cdf9262e4799911d00a27e12fc3ba2d7f7bde1fcf5243767794128706e081827c89a6f7ba3c889936e37c41f3caaf36b100ffab61010f89db919a6fd3eb",
         Mac => "cbdb6ff2298283b4ddec7526");
      Test_HMAC
        (Key => "e0421039b649a0d72d2b5dba7aa02ef7f1f83303bd0110bdd32b89af29ea5091",
         Msg => "64f3d0ce82097d36385b6717fe155d0fc5ed85bf80a1fed9e3a1c37a6b08d3bb9ed18f839448639fb6bea814c681c9b3200ca5ef3f7a35ec82416fd8301c6a7ebb49c21841f53e6558f5b0fc0bb61de020771e549db586f18ae745f5f76c8dde41c2333892f857b3a7664778d69ba1bd4f97b897a23b391081fd0f7ac7e08303",
         Mac => "d7fa45de6ac34e2d3ddeeb97");
      Test_HMAC
        (Key => "59b818b12c95be441ff52d8bd19286300f8cb877e25ea4cfcb117fa74db07782",
         Msg => "9c84d18b6ec339247482cc3ee52a1bbd6bd4ae918216912d211c103a9dfbbe8dca43bc5763d3379cacf233e7559b873ba217294cc9d2acef9c6707d067fd98631cd6691dad25b1e3ba209ec36c5751e2a1442bb5492347740f0447cc3d1e54d5d96660431460aee0e635953af2078198af813a33c9b269a3c51b5898e506f9ca",
         Mac => "7fed72bdb85fbd6fd73f9656");
      Test_HMAC
        (Key => "4def685532999b6352a6741ba47bd2aa393961e12ae4267ecfc558ad310c72ce",
         Msg => "8436228556a7569274bb14ad6271abfb82391e809363cb3877d84a63390898204e23753d1b8c0a4eb88bcffcf442aca099e25f11f11e1db988e07cef343b908153a2548f54574ca0792569efda522d06aed00f8ec6b321665ae8f0f20823acb61a19892308f064b03df3aa2d1e8b7654496af9a21a0a1f6574566f15bea734e7",
         Mac => "1dd37b69db9cf4a7494697f1");
      Test_HMAC
        (Key => "a3e983e3e959ad38b9bc4b4516589b263ad2c141884e5c84c2d65dee7c001951",
         Msg => "e01e4133819800b30445984a5f12d6e3e1e29e1bc6d428a209c569e37917cee70fb030767f4505800dd8d3bca27feb8f1f68532ff11a0408e6fd555f3e1db835062ba46ea1c5d232a8f6ac94f4010371f85a009b54f65d37a8c4d464a67cd81e6c978461109ed1917ca80b197c1f865315c28da819f09bf8f823ce3bd9bb9869",
         Mac => "24a2f45f719e993e63adcf23");
      Test_HMAC
        (Key => "b1b6d5e0b9b1efb608912da48d561f4489102abaa09f399631beb0fce340a202",
         Msg => "99d4482daecfeeb8d44226a39f85b42f9513fdc2d798c698044c3eb55a803f1e1e76d1483e76f0d1361e8f6e30fadc256f55c6bced4ebc71432eb8ebcaf87d7100421d5a2d44bdc4462f9c8911c0526f8a14569f86bec35996175ce52ed5cdcd06df3449c160dffbcd1a57dc8afe9e77aef9b655e81062b8c3af318cce3eb79a",
         Mac => "cd4057acd7ab2b1909ade91e");
      Test_HMAC
        (Key => "c913fe12cb76e574a23bf46c9032105848ce2c71f61e6d5880ff8cf20b917d76",
         Msg => "d83c04027297bacaa0ba8bedb834169fea05aef6c60e00fcfec5f6036e2ddc385906c27bf640216e2bb6c1cc9819d9fdd72a79e7022d2506769ac2bfd715b7f155a04cce2d1055e972bd158f0d7e5d5b03d5f405f6663b7befae11335af1f5bf52746aa21feda062fd3850de1f4be8e2f46ce8f9a9a28c82ef69ab06fea9dfc9",
         Mac => "0695b866fc28c2a3390e8449");
      Test_HMAC
        (Key => "d3dded60911343bca3af35d2dccbca9d2344b60c74b4819e27a0e62f75f37a12",
         Msg => "0e9b073a31c8fd215af1d8d0ce54ac9ae109036e1794250988b7966a898adf8688cd913e387c888eefa46d074c767e7f1c9992077ec5571d468edf23a07d5b10f665266613f405648889ad7c4e458507ae65ae385ecf414eedead70e60b34f711e0ecb9a0959fc0aee47a0171fec489a5e145fe9fdd968054475871413544311",
         Mac => "1b0dd1dec270305c1a669ca8");
      Test_HMAC
        (Key => "04d31106098fbda19af28e84339c736eec54e5859d9f288f4591ce64ade47ea3",
         Msg => "86c7c82bba165b31ad74d92ba22a3bbff926807e5396f414f7b6b2c275e6680f89005aba41e8aaf26265d6c9092f82e78e49787bad90ed78e89506fd27a89a14a2353aa000546e91c09b425ad93601a59d3a4145e3371f6c650dcc1e670049e59a0e6ec73f7f31758fbf25c55b694162f0a4e3c23db2145938c60e0d7d16fce9",
         Mac => "8e2916ef6b7bb91c15901210");
      Test_HMAC
        (Key => "addde2c62bfa0722f73b99add65f2b3c9bfdc93c4b1839ec7ff380ca0a26a94a",
         Msg => "a64ad96be224dceef6563f18c63fb7555ad926933f8e1cb02a4d9e2edfdc272e5170ed9c0b7b65a7cec509747cbe5913341320b2bf7ff8102be41035b59a2d61ed06ef42146f5669c90e84ffe564c5b4a3d1ccf90461406f71e9779fa25381ebc03668c4c6aab61e2d5a3821c8da0222ed3bb3d1d5ddfab4458559d46eaf29b6",
         Mac => "1930cb1a51265b09b0aaba99");
      Test_HMAC
        (Key => "ab40bb089199ccc0ea49c6f5216280f5dd3eff7c771f8f7bb1121217a51999f5",
         Msg => "22eeed3b24e076c260f12f1530695059b23d0acbbe331a041b479d7bf24d264b82d90e36165c0bea348f048418152453615c2ede09c410289a03ba329fc830c2599ede63b4132dad791a53c6c5af6f29bab9d5a67434a6aa3f8fa5c107534559100607c9e74f0292985bc3e4217e5864271ea82ce8cd061371b5052f10398d99",
         Mac => "e1c43cb277d8c07146fbc6e1");
      Test_HMAC
        (Key => "58102423a4168fa60a5aa7f79092d52326c98e22ee5f3dffdb527d397dbb8c68",
         Msg => "480be758a9b7ba9af001bf21db00c451cfd66f06c9d8d5d698ef47974a3d6f21e4049d5556c45b5fada447378b13226ed4af2427ab6692649ddb93831b0b40082e30fa9c66e60056148c403ab8ed6effbd1f541664ac69e7fff0a45e5fc292a68f57a734c362d2088b80532f4cd4d18df1eea7d9def280e925f62330fdab9085",
         Mac => "4c41bea823ee6791e83636bf752c1240");
      Test_HMAC
        (Key => "816aa4c3ee066310ac1e6666cf830c375355c3c8ba18cfe1f50a48c988b46272",
         Msg => "220248f5e6d7a49335b3f91374f18bb8b0ff5e8b9a5853f3cfb293855d78301d837a0a2eb9e4f056f06c08361bd07180ee802651e69726c28910d2baef379606815dcbab01d0dc7acb0ba8e65a2928130da0522f2b2b3d05260885cf1c64f14ca3145313c685b0274bf6a1cb38e4f99895c6a8cc72fbe0e52c01766fede78a1a",
         Mac => "17cb2e9e98b748b5ae0f7078ea5519e5");
      Test_HMAC
        (Key => "edbc48ed948cccc421efc7a6475a2dc2479dd9996f5e2f10e0c600c3957aad9d",
         Msg => "6dcc3949424fefabd4b3b7b4cbd098a677878101640380ec2f3f34d699c8855ddac5926f3834ebafd776011ad30edbea8ca60aba4152deece119da481db266e5c28bc44d461045dca029bd695d043429f116decf4b5c4ef8ace7e6c7b89792ccce27b62b956964fad7d3d3ea933b0c2a4ddfe788a9a836da38b0409c920171da",
         Mac => "9005e6ded766f31ca4277bb116c483cc");
      Test_HMAC
        (Key => "420e70ecc3cdaffb726a183c793845315f730fa4dac9fe46e4180397107a6a05",
         Msg => "f53ee3e2ce4467de8b3b30aece9404dc90aed0675b3f8454baf62465ef5f1c29e306d53563df85b088e54b1577027b344b2f377a50dc3f737292098df5d7151f66527ba9d12fc65e34c504df34761e4a0fd76673d2116f71cc88215d42ba0c566469fdc880fccfee762384966cba9525c2f085da48a8bc57af1f935d3ecfacd7",
         Mac => "9a148fc9f2372f9c07c328e832b96430");
      Test_HMAC
        (Key => "78b8b8aa70fcb2b0cbe835941275a5405cef6d8013aae759f6f17c9d643f0cbc",
         Msg => "538e379b06f1d89a9ea978a8f17ecd6f8a22d1d15a1418e4aac5603b54fa6a68337108bed8c7785c7e99f06740ea7a968ac402f4ce22ade1780e6d5a2307d37b0da52442c880ae96334d5c88a94a89d878dd12bb9577afdb8ebf83a0bfedf1aec973b2af40e32452a40de5939367a13e3cb328ae17dbc4dbd420c99491736d08",
         Mac => "85543d27b8a34ed9e222172ce308c672");
      Test_HMAC
        (Key => "aa01f699da8d42261e3b04ba1389d2631e985fdba28a4c0a762e40cb96df3af3",
         Msg => "426090153dd06665123aa375cb992e221cdd03068b827aa7d367cced8bded3da03ff11756f43f407474e588aed0b4e5f91fe1c3f52d68574a5424a49fb06f0bf9e4ec481dc421d1a68dae166fdf44a4644a4ea98f8cbed6748eb9f5e7d392e83dcf4b022cef667063e8944ef437bab41ff7576fac7883ce68309d316589f138e",
         Mac => "d9f1dbeb901ac73bab9b5d40065c21e6");
      Test_HMAC
        (Key => "6733498582e94a58cef983b1f52f215da1612e8e48f605814aa9095d398b965f",
         Msg => "3c17d3274495dcc86f2722398db60237fc70fc0e63b30aa4a32c30b90b40556dccaa5103ac6647e4fece35e7d104c9cf688f7716ea49c8e95b78f573cb3bb45ecd2852972b330252d8d1754f265eaa5b39bc0819bc3eaa02d2c4faab5027814629d7fd6c2ac2b41ae77809f9f58d4de2593fd7a1415957f9f25867e902cb632e",
         Mac => "adbffa3c88f82e0991fe2128ba2798a6");
      Test_HMAC
        (Key => "3a239ff156058ea4ff05e0f672b7ecb5d106fad5d31e9d6fb989430a84970a1a",
         Msg => "4ae231eafe77a158c2472143faf169db29bf2b53c3288d8b3c9added65778095f85e2cb471ab58362041f0a27d874c42bbb06385a0403ca193cba67cf70029cdb7e73c7e2267b856fa0b8dd4c706b45e7174659b0ee2891df911724324f7ca5daf07c912b9b2abff762e62a1817688757492975db7185c4695f3a90895634b8d",
         Mac => "9411d3cf30e359f33328f80a07b7ba6d");
      Test_HMAC
        (Key => "a3abb893aa5f82c4a8ef754460628af6b75af02168f45b72f8f09e45ed127c20",
         Msg => "00bf40f1efb6484fb6f9fcff80510bc8817959cde43a98ca04d5189bdea1e0fec7f5fd995a481a3fb597516fe508411d9ecc61b52f49935eb679fd7c908d147814d7f9c381e6091834f3b0021f7c7d9f762e7ca3ab08c09f9dbe3f840d5be363512bdd764cd83d649dd3bfc117f5e8d47167529e3fbf4517216b86bb3b537445",
         Mac => "79fffaa6767b3bacde8078aabcfbda9b");
      Test_HMAC
        (Key => "c3070d79ebe3c6a98ac13e50ae4710e602485a68a04329fb272c31d30d6fc253",
         Msg => "fb9cfb8a89761e4c02117be850006b26aede2a205f342d459f9cb6a4da27a5681cfd919ec943173f8e42726a97c54cf102c2d417943d1198ab6a76ea7412b6c35e37dadbcffb90f315bec6169f87771f6da5c57bc59649302827a71e84dd6585ab94fdc80466307180ce9e74d00d94b8d6cd25d359057c16fc1c70c9715159b7",
         Mac => "8aef0e90bd29fd1ad4d80c37e070dbf7");
      Test_HMAC
        (Key => "a9d599a9d003686e2a3b2a27407644b73bc4d7c7ef3ee75d193cbdb0e5c8893b",
         Msg => "e7462835e38509f5bee74c3133482ad4d7fb7ddcfb18c754d2177682d79e66616998a852b887820ee51bb6df65030710a703faa1f647da40a0f7fe75580b4f1dd9610419cc0cb047ecf07fb1688cbc058816974694cd26c0f28ba9418e9912867fc8c5f4e7bd9c891a8d2e11038a519dc45cdd319d53b3bd0ffbfe4e41f1b986",
         Mac => "11ddc4d89e463be1338373f0a1cb22f8");
      Test_HMAC
        (Key => "8ef73e17f2dc9e063230a3352fe5c549c1fd526c43f90f57539522b0d3b22f97",
         Msg => "757d2b41484741e4f9a9fc4c30fc633d31be09c856362715bd5bed603ef31a42a0f8cb320c3f904bc15cc5500ac020ed6d24863f262b2397d442b97b71cb38ee877c90f2a101c34a00e93e8490bf69371b777d8abb0d96f59568094cc484f7f994d02288f1d5006a1f190ef2ab4367a4a17f95afff24a7b86a9583d920657eea",
         Mac => "7a5efb96b080064a05fd021e31f1dbc1");
      Test_HMAC
        (Key => "a535c38a4f69ccbc134306f5f158019b7c79992625e462e9bcba4a2f34b4798a",
         Msg => "71db63e8b1392644e6fcf7c3d81a03a7518290f4d30048768a61d40580d7ad08109f2f389de0f0a784d74f004e3150102bb8a7859c3212f66f86ec24f02100805e989bed9c8fe5c629d9702352e11258a648f0bfabcfdcb8cf78e1eda1e81bdb4110cc8e150cadabbe4b82b44bf1f188ac799429699f4dc2947ddae9fcf4a921",
         Mac => "c070e020d56f7e294f10fd586bc3e063");
      Test_HMAC
        (Key => "2b3a5890de01a30f88d4f7eaaf702f6129a5e7718dfe8f9ce7a4bfe8b080ca2a",
         Msg => "179645a0885bf0f1deb9f6c105bdbf2bbdf728e6ed81786c3a3e955bd960781ba12ddec1650240338098068db186f8c42a07f58ae3fee7713437f652a3f0fcf0fb9839d99ed6498d1bcd52e2039f82a7f92fb988092c82313b4b48b767d3c7334a5fc0b0dadff147d7e14488a30f471c53f8dca9061332f67500f350cc12bf2c",
         Mac => "3d866bc71d43209d97bb596fa59460c4");
      Test_HMAC
        (Key => "c05d6b83a27ef65cef5571222d24adbcc18958640548bc959a4baa2b00e7b0c6",
         Msg => "b20f96997b0603a0bb860070369885f3bb1908939f6195fd6b232124d2941c89e6d045bb8b79c2192ba170dfabea78619eeb2391b9d6efc78758e2c25ec11eea9265b6d7e842c0174ee3ab2cc984d3d5ae76538f15c51a5a8b1942c007da9d14209790f87ca924218c135a5f76adbfd7538241939b76413edd2ce928b426c091",
         Mac => "15eec3c6d6f4e7f2b1426d01259ae8b6");
      Test_HMAC
        (Key => "895868f19695c1f5a26d8ae339c567e5ab43b0fcc8056050e9922ec53010f9ce",
         Msg => "883e6ca2b19ef54640bb8333f85a9380e17211f6ee3d1dc7dc8f0e7c5d67b73076c3eafc26b93bb248c406ceba5cb4a9bfc939f0a238e1559d0f4d84f87eb85975568050ec1fe13d3365033d405237ec92827dd8cd124b36a4fa89d4fb9de04f4d9f34864cf76f4ec8458168d265a5b02144e596b5f2e0d2b9f9cb54aeeeb67a",
         Mac => "374c88f4480f5e8aaa9f448b777557c50065e9ac");
      Test_HMAC
        (Key => "950fb0cde30f34f597af5caa2b16fc86a5c3ef065d36ffdd06ec048eec915039",
         Msg => "e463626506144cece55dfb7aa22eb21ea3a4277d892c211762ea45cc205c2d9e4b3abbb8f2a1adb0e77171092cf43afca8c053771edeb467602bd333c0ffbc88c80d645c2b8a3a2dfa92008a1bc7d9d5f83ba34774908634235dcd91bad4f5b3c4a2045997171ded8787500759f0b633fbdcbef47289c2091348deeef62301a6",
         Mac => "8c90480ea6414553df17e53cf96dcb166b94be35");
      Test_HMAC
        (Key => "a31acd1af261a1e7f751140a580b91d476792a9f96e1dd013fba1645e2bf761b",
         Msg => "6cd70039a77e420d999b57caaeb53aceddbab11739447faac31adb3583fa22f3d796c9d00adc95ce287a0ea711a231b4cd0a650d1f38b0f25dfc2b697e3eb32975f9e2b7be883dcf3621af052f9f37acc484ddf76a3eea5ec8a95843c9d688d6ef0b3336ea0aa3d96996232d3034b47f6a2f011d41de95b7ad294c0b894a07c2",
         Mac => "1b6a55344a48f62f8b351c69acb3a33b4c57c024");
      Test_HMAC
        (Key => "8ddf3be2ab49f11f12f392a09f5b72fcddec1e186dd3e49aab0e95a08ec589b1",
         Msg => "8a2db96a4df188ec323ef6eaa7d58b56216b0097beb5013929c231e3be8d6f89eed358e2e5220c1d6b3335d0087946316cfa01880d5e3ce41245e40d70de42bb53b67d05bfcd611c77ef5e391e41d4d49c1b8e17c3158c92336505307a68ac6a807e33ba231b0d531e1b790f2f56bca97975ad2c270477ab52c89b33245234fe",
         Mac => "7652e4b24051283af4caf67079955373f6604c9a");
      Test_HMAC
        (Key => "90aea6f7c6c3815718ba1959ececaf53128020b7039a51e766d0cf4bd9deb7a2",
         Msg => "1e691365ad90646031e01e737cb3c65a665409621d05ad86bd47c9d721553121f8f235cb1b648bff1ec1890b24699707f8d4e5b85a8e59b5977fccc85d707597cccba584d0a2b5d1aff33d08de2b879a19e844c6b2037dbc2acecc03fe9acb18c37dcd587552cc1f0d00a33251007d5af0198e52ce6e01e39dbb314eaddc1bea",
         Mac => "8a536922cc905ed4c321180ebbf4f000e2a809fc");
      Test_HMAC
        (Key => "5e6a489725810a85fe4505fab03d3b3c78771075e913b759f701ea084e0ade36",
         Msg => "212a0448f4b39f0d22f9a0d5a42066167056368b9c668272c78a6bf8b58184f239e2d9cd58b030c8ab2e8e6005f5fd0c56438d2bcf96993b477a4b4bde9f62b3e02e3302ec5dee3855422336c8e485722f98edefd68ba26dcc9bd7dd8d6b7517ddb61bcff7e363c5e7da683d351785afc3fc5fbff86c256f1e951694090d4487",
         Mac => "9e35e4bc678997c18bfb39568e1f77cc49ad153e");
      Test_HMAC
        (Key => "618406f43dd79acd2cd384b3d12709e43d267d76febf63ed58afd60dd2f528ed",
         Msg => "2d9313691868161ff609b6f0b094317198dd94cb41fb2e62930744b41e200683afb2c23621f8587d76c0ee34276fe48ab7440a628ee111f9050740c9bea168ae36041a489d7517a0e5eb080e1917705af0a2de21a2b6677afabf53daac731735ea10846632e43dd16a136e472e95bb2a697e77d12282172d99b8e6ad939efa60",
         Mac => "46d9d7c519e520029320b48451faed81f9112f44");
      Test_HMAC
        (Key => "ad445da48d46abfef103f9c6c5473444ffbbae90275cc4a8162bbec0fe26f6d9",
         Msg => "81c94be426eaf01864e813a03e4674491b61516bc95d8a77c15f03d0adfc4adc27f27a5ac4165ff6518eda1a5c408708f78a9e26b834179804a312148d4f75f21a77d78387139da40c0a6293c2a59d0162437d68504f189ed970c5abb9ffc6d8e1be2b0877c7f24b1dc273b1765bfc5ce6f4b8d99a96d5b1c92ee53a39f685b3",
         Mac => "91bc355fb0221825307af876d11404b473222d5a");
      Test_HMAC
        (Key => "05905a6ecb1679364090c9510f06fb3c0e09321b21fe0aad5cb9d980674e3561",
         Msg => "b34e5b0832128d3a8794c2ab447132857ac0a83475f6d96ea607f470e1ce7a8bc9af50e0887b1368c393ab37cc5123011aa3b7ddf7f92f4979626c6eb3f141a62c66843c910a6473a6dbfcc982e9297cfc00994e6187258568a8613767b271c4c6bb1ea4b48929631ab3dee9cd03edff081f760f1968632b5a23fa5163d7b2ee",
         Mac => "f76d200078fb5b3d3aacc3d90efd4edc5612a777");
      Test_HMAC
        (Key => "3e9eebe9add8e8315892c6b3bbeb77abf60dcdae1961e2839fffb73538691b66",
         Msg => "f184d3809b13c417e06c7ed51d89e79c026fbfbbf1022662a61d5e5a1de2d3f2b04f583d8112b47a179f5dd44c7f834c66eb50f384996f5c3cd6cb5182d599c5cb47980a732b97445ce8391ed999f5bbcaa860f0089eafb0033977c7a9c0b8cb8a931a503a06765cf76f981b8c7e44d375cd761944b8ee46446fec255b4939ee",
         Mac => "99fbfd85069f25da97f9621fff93ea599f61d0c2");
      Test_HMAC
        (Key => "c116c698b12c153b57c9d57d4eeb97f7dd8eff14cc2a2dbd767e7c35208c6f41",
         Msg => "bc74041ea20c9b7489dce3ba9e279c00c124b6bf94b90cbfd2864f37e3254037adb02343ac8470404545cb955723368a145b86f30f00131395fbb4bb4151ebb2cba45c5921fd848fb9c8a7d325200aa8e84d633e888b8e4ee40d8146c84282a6bf5798aa28fd3f298c6c5fbd2fa87f24e50336e627e3e33866c59e219f826fdb",
         Mac => "8da25f1b52990f59dad1405161c54eb148f002fb");
      Test_HMAC
        (Key => "ff73004a8aa629ca5c72414ea652a6533fd282e847a492650af12c5926ed80c4",
         Msg => "2f42a2ad39f842c355d46670455817e689ddd9e7e8d8e12b4d5b8302d4dfea3a25400b430109db911af2c04228a7460139cb142a483d1e2e129a1c3a25033a133a201145c464d67cc993d132f182118add1f5f7cb9b0703315605fb3f0f75abf16e99bfaad92994c0ac08087c972df4b1cdfa12763ba3f00fdb534b75e44b006",
         Mac => "ed84ee8c4d99c5dbe7a253be436ac0c4e4b5e0bc");
      Test_HMAC
        (Key => "bedb392f8a77a470858a9c366b7255f3b25c9a5d10b76d793de9eef8fa407ec7",
         Msg => "eeb955b959c48f359e05da6fe4992c907c1c0134671c007818cedb547a00772c354f4da12e9a10ad4cb78fef8264de430a80b096ee7b08f9cd0b11f3dc20491c2b1be5e72a3a72c06b57b857a9d3e33b0acde5aaa19716a8376a1d4e4b5814655783e733558dfd95824f1b4e62ce859f046a6618875971addd54c90ccf901e2e",
         Mac => "7ab9416ae1d32bbbd13277aeda805d66b006461e");
      Test_HMAC
        (Key => "863bbe40cb6694f736b532b95e38fbabe0e49c15f7dc42c54def09ae1161b7d5",
         Msg => "1552df9bae4fc97985bcf7d5fa01799332423bff194a2a61a7c298d263a7e24d26fb500922ba3c06220f77e613c8e8ffc40876aeea3b29ee674f8b29cc22554e1c364723d3ac58dd26700fee8db1311e7f949cdd7c2973d7519e7bca98b2c5947e6d8e91c90e6323194689926da39b17ea4f7533d8fa5145ee15305ccf417c4a",
         Mac => "ccf2155306cf89a73f55a0560d32337e266432af");
      Test_HMAC
        (Key => "b476d28aeb5fac74fcf4cdb1ab00a38571231db06624b4586588ac436a649749",
         Msg => "4d4481936f523035b921005101ba206b85f55e272ea49016160e32d0479f5043c6dda74ad09e07826378fb59007aac67b0190302456d0e0ce29ea510bd994d8d24075c92be7f5e8b14fab85b4f888bab4342db81ad80f114b94cfddfc81600f46fa9e993c35dfefbd48e7e80774e85de49572fcdf04300d5a4008464ef7e321e",
         Mac => "65437f28501640304b1ff95db6a6437cac37d10a");
      Test_HMAC
        (Key => "268b0e1f110052aaa2eee327e34ab349029806daf702306867a7a03bc8351d8ac7ba50eee6b783166a77a8bd749e9dd96e05ae15a8c55c8243925c894f4be325",
         Msg => "7c881de00388a00f8ceea887b8e87ef7ceb23ea05dad950623b0caeb2ea2fb7d4149aacf795d788630e12fd522b306abce61212a203e585c4cb53921fdde506caf4fa6af5935879450a388ee6829c9ef5ca9789b7066967c545efe984cdaa3a08e43196aeb3757a1b2dcbbbcd2744e2c3e324ada964cd9d00352203663be7c81",
         Mac => "e06c086d3434d79595d3");
      Test_HMAC
        (Key => "77c192472253685d52a6fc393bb7a9d5bd73f5af2b6e742050d7eae9b4acb00f1b2a59ea4f8894781fe454f7a87e2fb2d324041b1fede11aa12a24a5499ae091",
         Msg => "837dc190bf0a96d9c7879d8d998c5c21a263475180bc9c700ca28cfc98ae9b75757b496fb959f2e73e46f3d3ee1a0efc3e011010f92eb0f33fcebb57cd3b6e8c7f73239912c8318b2fd90d0da5c0b539f78d4eae16f40be36f4252bb28951a59a74d983555be1a6fa127336447e81880d2ef4a535f7475e6a5e6984f32256783",
         Mac => "2d0f6c935a06d9d48e10");
      Test_HMAC
        (Key => "79a557102517e406b26557d026cf06429a5be840ecc0f0c9b38399357860c3ba23ebbd35b377a3273237eafee8a33997d01d7a0048d532820cea0ddf65d2bed8",
         Msg => "d60812433098c44623159153de7cd2721b349f685c43388a74c2a3d04a8e972ada4199177c61657369d78f907ba26a8934cc29d3029d4415c1101e3a8283e4c48bb2b8639fe60fc67f6a57b1b03fde507f10efcb43683e1ae223851b962370e1f144b74f1f9189e66cb831dc05bbf46e03e93877a50dec40dde5239a0fd5022a",
         Mac => "6cdbed1cff27b79ac20b");
      Test_HMAC
        (Key => "3a4182af8c3914d1df57b6321fa5dec68748ad746e0369bb64fc2d9b7dc3dfb3ed9063a7d5cc0ec45dd35ee703f9e89a33cb9181179701f5b02e55ee26e81426",
         Msg => "a16b3fdcaa7eb6a2135159aa6948c6a8dce747519f9f54cb92e759621f8fb97c615112cf8caac3d189e8ab70e0833404dbb09082e93443f24076e223c6d91a9d3248f3d76e1356aa40f9ce062a868be48f9fac7b165bbeb754147fe7a5bee8b65a786b5c1a617a1582ad48d20ff8d32f3ed922a6f1bbcb0215e8b91682e72cae",
         Mac => "bb7654e63c2ef4313c63");
      Test_HMAC
        (Key => "3510c8f6da91371b5c81468b714d05284becdad01d5a2476dc481f784312082c19f181bcb6723635c426c1da439bcbbecf8c74922655f5bbe5a984a892877962",
         Msg => "04e4798b90beaee2ecca6a4c1463ad9c1f9661e0718332e731059f00fe955105dd6bac9876e7a5ad8130d3497b1bc8889d4ea1e50ea5dcb658d46af6194e0547fb66c437e5b4edc373bb0a1aa4c83fa3d31dda40e94f2cd5d0ed98042b62e93b441de8f145ef2f2cacb43847f935b9f2a94d347a684bc94b839850b39c9aa4e8",
         Mac => "df4a9f32c2b911138a7d");
      Test_HMAC
        (Key => "23904039640d48e163676d16198884a825604ba86329a1cdc0f0f6164d5100b19282af1c2493648a7af35e88fc3774e05d170abe2bb93e11a4336234cc4bafce",
         Msg => "2d201194f73a9ca6e44834d8a44aa948287d1536062c647020c9140d813c3a5e877bc622475b07f92da6721ce36d9f4a749f9406b2db46ffd5835dd0641238e959af31cd8002227f20462836dd9fa658ddae8da62a63dbb45713629d67cbcbf4eae3dafe69d6f41e0451de905a89c75aa9d28980366e2c78f0a2abdd500ffb68",
         Mac => "9238de28fd468cc27d76");
      Test_HMAC
        (Key => "d4471c7f6186e8c0ed3dfa2b0ef2cd184d6041c0921ea5fddc7c155135ae062ae62c1f64e7584b1099610c74b76812528ae20c6e5d3ebe4a31c75334b2cbf582",
         Msg => "1b3b012e5a3147207350e981c05f20f268b4792078f986a23630d325b2f51bc69d03bcbf5efa694663601fb2b5e55ae0d0eb88d5b145bea4303faa9290dfc979556bd96a552b92961270916f47d6950ac1c5edc8703e3135bed431301ff82b4dea7a4177674d29da298b27009eb83839e44b9041de6a471d88f6504687c7aa09",
         Mac => "65d6db01f95625fcb481");
      Test_HMAC
        (Key => "de6cc5a186dc79b9e21b0578b5ac6e2440a115e713162d7522fe72ee1b221806f7660263d04e3547f2c28c6e340ead3a892d3b0dd2474ef6f678209135d30928",
         Msg => "f80c55de4b5ad74e4f8dc14b6a45c019e1826654ed66d9d5123dcddaacbaaf60cb8323d440f1b1ebf810bbcf89eeb37b0b128b68294a6c6977aaaad307d1f8e2376ed858cc03566745e9f6d16995eb4e2319892e8fedfd3f55f03cf136aa39b8e4d45bb2171a2e8add1f599c31c2d05ad0a04aee48d9f6215218697b61cddbab",
         Mac => "c4953ddadc2acf38e677");
      Test_HMAC
        (Key => "8989b2299f9db5a5df0253a97b775c94e8e9195ad698e1cd6576e71b96cf5698ff2fa0bec4811272c274ad890d23318b9df47ab744c00f47e335f9f5de79d1bd",
         Msg => "9f65a426106db99dcb2130be14839241d4a92c8becc108d2c9521b8238c5c0df7c2365ec9f20848c0559d6e847dac3103ee31ce55dec0c3644e64c2993c497ddfc3a5e4d9dc4bc788cebacbfb3c47a8edeb9773e128bf13a219862617b5ae8ac4731f511b26248a7875f1c0a01499f01ddb3a55eb2a99e2685f0c5f298909b95",
         Mac => "616a0dfee4c59643e047");
      Test_HMAC
        (Key => "8f55e53e046e6d6d64c4468d44aa49a4e07742dd04d8f4812c6b5e22ea893d1a8863d234ee50e5a8c7650a4de047230ad03d268dde8921401ff97b79dfb97cf2",
         Msg => "5f172973852b947ad8406fe004de6e94127c7fe2e9f3658c1433a21dc5359b7a1a31f7baa01048371624ede5731737e32a21ca50ac7e46602e2027afada1ead5307b723a4e7ba92cef736a2e57309f9360aba64c0683faff29ab0f598f607da4295f619c9754007eed95ae63b810efcc3c83db7e00ebc7908d3e21c2725c9c10",
         Mac => "145ce9119643c0c9c23a");
      Test_HMAC
        (Key => "d5bbd2a2a536e6204259cbc2aa7e88452ffc2a5270485cb8876038fa84695d091b964252994dcafb1c85186a0473a408a5658e443eee33da2f43ff5566e582d2",
         Msg => "e84dc3e5a3e9c59b8d4c80fee20b43f388c935d5fd5ce9b98f2b32f7cbda39e6372acce6441af9a47e53dc9906c2b5d442873dfad30e3b8bc77b5266104c1d9035397e31485f32df189ea91fa7401529dfdbc2ec8078a5525df437c5c8a784f24b447ecd990098d5c3f79099afcb8c7bc78e69b4eee25098b85e8a1bda349595",
         Mac => "0f6585d0203aedecad76");
      Test_HMAC
        (Key => "4c34132786865ebba9bd1aa5d2d3675637744f7e5e619e8a8e16f36b84ab189a66f88f59fdfc6d3b1e806ce669f73b1837a918e8cd10a14fd682e7e61011c5f1",
         Msg => "aaa05c3e8c3337306abc752b9b044dd7349c9604da693749d461dfea648ff6ff585dd3d3dc122f8b929ad908e586ac0e9a53bfa5a7efdbbf4979321c51484d6bbe3047b2910039efdd4ff5001e79f7c0cbe498732f88856474ae70cc01f705f606a120a154063da6736530daeee51636f2d78b35173c1d7e7e8701c31ca405e9",
         Mac => "fd4032c4adf2a19e69e5");
      Test_HMAC
        (Key => "d7931174ea188b2c8a1f045978346592014283a1d20f992c0e06f5959e39f11ec9a6255104b9db9f0b13c347308ae979f371e3bbd4194f8d65977d48a3c8684c",
         Msg => "c8dc1345a06e53e6d7b7eef4519d82a43f1977cde9e8e242ac84a95e3e52e9e03a1d94f9d8c35fa4fb2edb367286e13677a5346e7ccc62422894eb419c27a5fafaaf5f11280fc592d1d28484ad60aec203785f066cdaa147d9448d45d7a0b362127cbcb318ba4e57608930078b94afefe97940bc3f7c66f7c87dd6917927dabf",
         Mac => "8e99a60f575dff478d99");
      Test_HMAC
        (Key => "454262ab05cca57ff00f12d653f08a5e2e441e324493c6b86e1b56c93418af139e4332bc48997b48b55d4bbde560c5052a80de93376f0f4a7ab64c9aacf93aec",
         Msg => "77c192472253685d52a6fc393bb7a9d5bd73f5af2b6e742050d7eae9b4acb00f1b2a59ea4f8894781fe454f7a87e2fb2d324041b1fede11aa12a24a5499ae09166dd82a76c2bb4fbf546817907adbac195139935480fa54f7f15d53994a5f89761c254a702a68e8dddb4cae8e0ae12a90a28fc252d3d8769f28047cd1d35c2cc",
         Mac => "d52b5f1b01dc36d76d8e");
      Test_HMAC
        (Key => "66ecea6ce6274578ae5283c8de9576f5865a38c321b9ca3d5f33fb0828a48bf1dd7391c8e10c1a71589013382eca69655b666e10665d7f3728b4e40ed366f796",
         Msg => "2272579ca6eb22dc3f558314c47c2ef8ab4d678a7d8017e0877a1f28d371ece956d14b8c6bde7f1a809b92470febe8b0d1f71a612ecf019af75410d35755e7fd07f8260bc25c7fb1f97c106bc757efc2274e06cb65cd21f0d22d45f2bcd9442f9db08e2193ab4a2810c0a589d3066ab61719d4d00ac0a06a80cd6590e9452807",
         Mac => "6ece755234adba6cd01a");
      Test_HMAC
        (Key => "b244d305bfd534de7b05b66cda0b7bd3c2414956b5364611b0feffea53cdafc541c5bff7ca0b89fdc820616fc66fd62f682235e6073a4fb19bdf7c17def4e03f",
         Msg => "f54c5e14a29abb699fea3504f4b9a077bd40a4dd72a61cb56c75bdf0a54bf848c0d221d449f1d0d93d4488e4cdca96155fde3cbed6690f2d13559ec5bb4554543b83a0a00a3952432ee549b902074bb8361c34bf17d053f211701125729ed337704822a16edb0a4e7bb3bfae1cd787064be3d30abf45afad6eac5d3851be3d99",
         Mac => "e685c26a4ef766a1ac244bf7");
      Test_HMAC
        (Key => "f3cb2cbaafe6281ebb546af88c052e6658a58407cd7ba30502918052ae159f3198ff29f94ef440151a6a8f50320e25502f62835fc0abf372a00a1c63c5e9d482",
         Msg => "8f636070d8c5c1f979734ae36acfe63f0c0817531a3f8de1dde9f7ada0751939642e1ed3d56230d17cc4471c350f3eebe4ec2cd16416f1fac0bc0fb2a627bc26189c356f658454cc58ca652faf8536fcced76d0db5141ef930279d964d3291bc13754a4c71715571754d4d26bf78f3f93490810ef7833c6695f449617fe0c182",
         Mac => "3bf0f6f4ac757afb9deafdb3");
      Test_HMAC
        (Key => "5ed96404ce1f0ae00c32ada5f605c10253d5de41135f211bd84fd0d1b6fb3c783751ec94a30ef7e97e32b28e51b08b43ae6935046e5b06df3d169d025970c718",
         Msg => "a89bbaa86a339951ddcd37799e21b5d1688e4abedbc72daf7cc9b5adfe10be34c00a504196cc7baccc0485b8682e48e9b00bd515ec4f5dbe6d9a529fceaac9857acf23606e9fec9a41ea03a761f1fbde9fd2c287ee4780356790c25691aed808e0d27b2e7b15b4c34269f96f10d098583dcc593b68165ebb73924ff9ce83b464",
         Mac => "a8028cb31b89d1e668eb4196");
      Test_HMAC
        (Key => "c92660b2f009f47d3589c74e22daca9f60d0147fcea28e7cd0eff0c5eafeec908d4aa8ba303e72ada33db087a0e51579a4951b6cfc2cadeb2314233d4b8074d1",
         Msg => "46252e54907ec102948e8233e7254a6ad0fe414250aa00025fcaf272798100ed59296db80545fe920ab75f8c0934c21b72f4c96c90aea6f7c6c3815718ba1959ececaf53128020b7039a51e766d0cf4bd9deb7a2ed9ad495722a0892f674edd788d6bbcdc2176d98069e1fec07e2bb228b22d48b7056d204ed6550ca1b98c290",
         Mac => "515a7febe556a317919eb3dc");
      Test_HMAC
        (Key => "2ab04d9a3af659171d80653a1f7ab9bc64863e6ccf0f882523d913fd68ddcdc09155d59d5b13831e7816a85eed5f1776b9016438b778eb20c53b14872695d61a",
         Msg => "8d5044a308c18e305d0a13bda0c69555bdfa93c9549bc053c751b37a917be035d973c75346136b1a1678062f6a05fbb6e4ab0cb97468cdce6f0e58f4e24643bf25d4cfb5b31d62f738e63824ec5e557a205fbe3e16f1e85e16107156beaf0e509afcc58ff5e65c0deedc1163ced88bea989d1120e23dfa4de4dd6466cfbc2931",
         Mac => "a3bc85d2694d7868120934ce");
      Test_HMAC
        (Key => "2c66bc60707a1da0c194e5422ba022acd049a0058a0fb2e9d2992e61e14cba12141c46b495a2dac6386f9280a3a1e70ab2b42feb1a9a67c44c0d313e9c241941",
         Msg => "f39dcfd65ab7d025bbea7aa405f6d64a22aec28f7c64937fc0a2ff0de21b3ba961e06015ccd71374856a65a4c57cf8cde0a1643aca8ed868dace055dcfb7373b119dc5153945ac01d29c776f61a962b9a4c1befb18fa9724bde2954d1d70204a8b3ac77fa9e9e3f52dea77aee4675b35f7769a786d9018daf1447885d52c3cfd",
         Mac => "03368545751957bda8ff9db3");
      Test_HMAC
        (Key => "67856f8f84dba19cb38a23b0efad6eed229c536f45753f81c8fbbe1134a43e620fed160100f1c6fa333a804bffd7e899c6ae19221d14e8f32d9b6c5b592bbe9f",
         Msg => "a18a27748ef39b49be984e8d18520110008bc8a1d5aeb424bedcaee5a7e1a62c8666ee12e367e09297e8c7e3d4e4fd056587509b379daaf81949f27cc0fa2d210e9be951940adbfb55ccc7e5ccffa044318ff18af9ad7b7f9c7d1f939a0fff72c091e1daa7c3d4a97fab153b0a8933f2eb0d721621c86de0cfe100d13e096548",
         Mac => "e2ac4a0e354277a62cc82573");
      Test_HMAC
        (Key => "cde363485e01d4d36242665f35a6e910b991fd9041211c05adbfdb40d6f46c372c7e68b69da4cb51b9c6419d1438a0a0ec51b5850cbe4394f01c49622ac78445",
         Msg => "9eeb079c552e421f703085b9b275d5b05c0c922efe14f2e78c7faefbb416fb1e6fbdbcf6d7f9f6c438af8447692f0cde5d7031ecf59d0a8018d1d3360620e358e9d6de49ae032c241237aaa0008a9f371adff187966a99f84b70549f0b4e9b6234bdd65d8254cd85274f5f8b1e8e7604bce13ac6888285954ce397ff6caa0c84",
         Mac => "31a0920da97a3e94b151bfc8");
      Test_HMAC
        (Key => "74c6bd81ed71bebacf5f7263cad715951c690afe4cd127e41b1e5468b813540833cde26834a60052ed5a8cfb4d68148876bbebd0728a7c64217ddfcd7611aa14",
         Msg => "b8ec3714f0f54c83d7e1e5e187b110d0abbaddf1ec4a71a9ac8e5625f7b3159bb64c07d326f468e78934ad471ca717ff485b893d1c7b970dfb2bdf6892b49c6d0de178ee8ba9a22ecf0d21e938446895f3162ae86f866f9a11b3e86c2a007f692673336c065b23e21036e8d1c4d1281a13b168fbccb222d757ee183aa5e0e718",
         Mac => "ea5be261fbfdf4e083358099");
      Test_HMAC
        (Key => "18f10073e71422a3d223c1a95fdfa6f3d5c27172f0e4ec9ed91f99bb55718d5b3da381252e2827d48148ba837e7ed927cc1e955d2c3ac96668c7aa6f85fc9e16",
         Msg => "bdff024f5c8c625bf0e557c138e02f1fa7329bf70b846d616ccaa1fc37d09a2a9c15af7d34dde66ce782ff4b0d0bb57ad3ff40dce07c1e8a398313c962966f3ac7858f515a85a6087c82bed521b6f9d92f7b1d5a285d4f7309741f0a72f1c50306f6aab315ab2b98798e9947bd0a84a5854c395a29528983a444cca7ad0826ed",
         Mac => "96f596dc5ce8952cb2b0f914");
      Test_HMAC
        (Key => "fd4e7dfc0c21461f69fb237fa283378413f1e5d25db7e613146798f6b8d19977e76b9562d0f75c12eb5f387fe8e47d78e577612ce3670eef7b3df63bcde567f5",
         Msg => "8d8094c0736564175a29e567309809ea14e090745e8e2904dfb9da996a7da14792ac5c89b6bfe6d93b13837e19527ea6992e10b45d5684dba0a299ecbf91286cf8f606ea72ee2c8f7e1515f71dfa683fc2d0d760596647bb875931f53488480447c85c8ab0d97e62ac996579447810e0172cad1f5aa6bacb1d446a5bd0484a37",
         Mac => "ab8810c9a05afb0169fd36df");
      Test_HMAC
        (Key => "0293926e81c051a6c0945d2594644b824c100c368a85634751869c245ead7cd0bcac744393d9190e41ead93dabfce681d5db778fb17d30c335cfde09b0b568fd",
         Msg => "69969242b77bb69e8d7d63bb08d63ebe8be96a460778f4447a176f0db6e1dbad6469cc7e48f4c8fac7e5f0cea678e22f14b3df71eb9a29d633a3afa4e869ec7afca40de3a059522cc04eb673ccc1d201be59ffda595dbb91ae244e61e5cdad7a3a309e9946131ddb80a2fed30319d5da92c413a6d929711ff584926d3773e356",
         Mac => "078437f1a1089c5724eebf2e");
      Test_HMAC
        (Key => "75dfc0b734046aa2ef9d82f7596269e100793e5223f853a2c3a5e179fc00faee9683c0f0d828d5e59c2c1292a9127c3b3cec730be8d62db6a0c3635c137c4ab1",
         Msg => "e68ccc21d4d7e9155773e9d612813f99baf6d72c3336562cf6e5a478b6f9a8e543145234ae12df41aedd587c42895c9d989d20942eaeb4bf3733886040942e4e138461ebdc9147558af9f3e178c02ec54dff7714217f48f0e1869bfbf4f1ad0e1e83022ea57da9bbb36fc1ebfc4d3c77a0c5e39453d09a25bb88e62f1939ac8d",
         Mac => "a1147bb0ba909865a46b4720");
      Test_HMAC
        (Key => "8af2e72ed2ad3be1e81a21e6fcbddff62d45385bf061ed60b6d58306c9cd47f8777190c173b9443d78839d4d2fe32dcf53ba20ce138ac2f5b888414a87f3b319",
         Msg => "657fcef962db04bd269ae5fef2cbd5e6558d072946d235e8706394d4cd250796769a926fbaaa121b6da42cfc82808474dd672f9362756af252bd8cded78d39b9ddf4d99e24824844934fcf25d03e54df0d83cdda2563fb2be73b54b8b1c4419d429589cfc9ea0dff41a3b7c20190adee8febca47b6264e5bd8e8d4aa8552850a",
         Mac => "6eb55c6365a8957cf579ca2f");
      Test_HMAC
        (Key => "81b7e464796841368cda2cf7048055643e8d38dea614abb3e36db39f4eda9c93a96a49b40e1ec8a7254b290c9a3f9148ce278a88cd319d0381ed237f25f95816",
         Msg => "422e4cbdbcb7128f1966ef7432049d13a407cb27c8b4b7cbe686fff4a5d3b53fc6adb1ed12072b2b91188997fd05750176ba336e771831630956e06037a1c3aac106c64d1592d0627ab89b8e8ff2c4cbf4ab1e6b475d4c5a52f78fa38281dc359b0232e8aba22abb3d0cd05fce16b1fa85a435251ec92f362830b3c570bb2869",
         Mac => "9609b20113e61797397a428f");
      Test_HMAC
        (Key => "8eccd467d875839cb4b0a0170a976f6056876859fb242f69d99dc6da2132028068f33b9cfbca48ff73bbaa73896b08562bdfdc88cf876b88077bfad955043fab",
         Msg => "a67b1dc3633d30c4ef2bf3185fd44865d2af5e72015cdf8c182e6b28c5e746c98ec24d2467b72f8284fad9676cc532714f570982993d4b22c7d07a1e79ff5a75c94eee75dc1fa222b630cad753664b30f3c99826b5cfe17c67dd875b9d0bd2390028e6ffe9fef36a2fd6adb13d3ffc69670cf4a67e9c0764a15e7925579315db",
         Mac => "f35a4323cab7ade7168c8b9f7276744e");
      Test_HMAC
        (Key => "b488332a10f2bc7d9042a1933da85dcc892504be3ea8d57bb5780f1648d1076309d276ffb5971790e3a2724e817ff2c381a73eced0a6c6ee88799cbd663a86bb",
         Msg => "a9174a67603a4d5fbaa8cfb562f07393abadbc80d1b57231829347a29c38ba6639ed3c3ce98c91e23ef07a2e8eaa915af4f574a098ed250630fbb17cc7941024bd234df11043e773d93276f11a8291b9b612f0b4c13dce3dfa5191339643ad4d40a1c6ae5dc715ba94560c278ee23d57faeb78e5d50f337ee87d2ff292ad598a",
         Mac => "59a116a249eacaffc54498957787f8f4");
      Test_HMAC
        (Key => "9dcb2ac482979d2b4f69b86154a66286c10a73dd5e8f0ecf7d9031332e2e8accb1f38d1331b5c337afbd65633c29293f6b8f5cb906e33105009b59e2ab10d320",
         Msg => "5c97f13331db20f6351f9aef4e0b7c9c92a2cabf476903a80ecbf8b65bbcdd1c289da1e1eb5f7b2bc5ecc6bcfcc20ebdabe16bbab8e80def077b19c2ede7b490e8095cac8d6c7fa5c1b146c82c34b2e6ebeceb588593d53f2107e310f6f1305102a4cc9dff4853ee9337c51cc7a791a0ba8af39e97b28023c43900ab5c207be6",
         Mac => "86d4b3a747285f26530e364b659a3c15");
      Test_HMAC
        (Key => "5f360b2be1b1d9473ec74ffe0bca455c7150cfb2d33e0645b1250c43cdd24afb8c20fc4c9e11f05ee11d8a9183ca0cb3687d1476cb90672127a4ec855839fc33",
         Msg => "179645a0885bf0f1deb9f6c105bdbf2bbdf728e6ed81786c3a3e955bd960781ba12ddec1650240338098068db186f8c42a07f58ae3fee7713437f652a3f0fcf0fb9839d99ed6498d1bcd52e2039f82a7f92fb988092c82313b4b48b767d3c7334a5fc0b0dadff147d7e14488a30f471c53f8dca9061332f67500f350cc12bf2c",
         Mac => "924243335c2eebd348ea23efcb442cc3");
      Test_HMAC
        (Key => "c05d6b83a27ef65cef5571222d24adbcc18958640548bc959a4baa2b00e7b0c66361926fb8b1f87e098565ba0d8968c3fce616ada108b7eeb1a5c07a5bfb022c",
         Msg => "a782b87323a0ec6abd8f27e50e976184847e166a04a001f1d442289cb923184e5c5472b9f24aa6181c32ff210c84e035eadb4ddb7604ac6cee54cd10323f29e82627678d587225bae3dff445931aa454498ec3cda17a600ed34714dfd71944a4cda4a0d89b41efb6d8400f39e9803747693e8029cf2ba43f4ac105f2f0d6f1e9",
         Mac => "c05fea12c1594631fa9a5b7e35cc74e0");
      Test_HMAC
        (Key => "2af1053d2cca20406b7814ab9013677feeaeb773ade5fb2d27b50bb892916333e0b123c6e3ae5bdbb54c868a579654549831ad1538eaf2344e91861de70a8df1",
         Msg => "f7a519f3b5ae6fd988eae92a9bdfbecf81e7b405d73ee50e2559c32606795ab98981d5d3d60444d815a39c758b96ffd606883e1a7ca89d04effdd6f393f960143352f0d6d10d419e8ddc11bdc8a96c9f88732c441e59c1f407f42e2f11ea54e4bec073e3edf0ee93b73c4ee898418a90cf4f866d0778d94836e7d3c4c674bf90",
         Mac => "34515b41c4af316223ae43e6869a38c1");
      Test_HMAC
        (Key => "9c9445d7df7eab77c9a5c7afbd2f38707d26efb89d1d415938173afce1a43565dc4da9f98f32467d33f24120cfcbecbc67038959708660f388d00f7d640d2225",
         Msg => "2fb3b04e1f5e7fade5abfb52efe19edd2ebc80181a657b85f7a18d3957497fede1fac453500da4a6bfca9a8523d8fa0119f8d6f5e2f42396abd1184a124cd7bee7854f322ff561186fa541de27a220089cac0881da2e0733fa738fd5a1161d04c9ba1996c4fcfd2b7da6ba04022558193f3edc650cfc6e856bedbb810a8e99ea",
         Mac => "8bbe93e9a0e39128595251c7a0504f10");
      Test_HMAC
        (Key => "64169fd4b7ba1e5a62412b8719a2b622d5031aa777cee7f5ae06e4471adc5465b27d791c632f57ebf99cbaff436d7a62721bfe6fc302ff895eb88e0c7d9c5984",
         Msg => "7f7577736313f725fb872d0703a3759c422a55db25e34ae0a7ebc8e2734f7c654ddad4b1ae2cc182ae0cbc01270007f3181a35314714ec582ba0eac108f946b45cbef8d87a009cee759a73bf3fc0ab5312dbe0640f94e212262fb9d9351be6bf74c7ecd210b70fd116d65c2a930ee924fa165e5ec58bb4785f433d1042dee5f0",
         Mac => "b3d266e44d21fea613913002229b7994");
      Test_HMAC
        (Key => "c49505be68196bf7b874b25353de09d677a847856a1477d5186a9464fd4891e7453a9c63328aa4a1bf5a19dc83eff3bcd750f5883b103397f668d207fd890fb2",
         Msg => "cad04d5a15ec41e28c9944fd13bafcc52f54aa86c5420d17252a846b46af726353e8e6e667117c3496817e772cdc4f9c398a0a604d6866ae80bddd28b56f0d0420775e190692e539c43988c213d463708a2b6b75651d51cc8494aacab7b84cf63863fb1a79d5459a20aaaa05500900ea2b1d16ed95c998193a973278d2f2f8e1",
         Mac => "45d9e3d8155dd1d7aac1faa36827402d");
      Test_HMAC
        (Key => "5a905c63f9660429ac7b7be84766c71ba5a443458fea9fe3e0ba289fe73549c60d3052fcb889792f6fbb1fc93eb1542a5cd89c550b78f3e9c04410548430e743",
         Msg => "55ceb7328ec045967807a80790b5f55b2a66aa1f6d2edc2c9fd0927ba3316c3bbf0c8820a3e6a5fda7458995551da1af278be86891c509cd4252c8a9a8769e9cb2f1a36dd9e9b2a16124c74ddc7aab28f18ad4e45bad86bf34283f5574a652b8b5e5d2c239afb1aa2d0c29d62fb65bf00fcd373cd2cc9b29fdbcbf2610a7d0b6",
         Mac => "f5d0c72599bd5f8323a599ca7d2d54f1");
      Test_HMAC
        (Key => "c9b74b2ba807d65ae62728882a32c4c0a0b2d9019fb50ced8a2477c5f451f29507cf91ac26866e4fd106a8afc91cab1875a3b26a859d8bcdd5839aa194d921b4",
         Msg => "de66e519983ba074220640d09848cf606f6f959c4e588de61f11156e67e3e953d290520b13d99b04ea43c58b861b7cee0eb849dd7b000816a82e9d42acd2e3196718e5cd5b4e51a6bda129e9cc27bcff6223d5d3c984327ccfae371c1d7de408c487052919a2a8a2c3a7d4b2127578dc9338a246e1ebf160bd1b4dc561eed566",
         Mac => "2c77d71152e343414dab1c83fc5f6429");
      Test_HMAC
        (Key => "3af349f3647218e4be26fa863ac71381b64fccaa7e66761e121e308e2ae00ad9f8a76ae0ad6baf963ee115566861d87af2279d2932bf0d70d2bbc394d4a768a7",
         Msg => "aca7f7f326453435b2ec9e17f0c8823f3cdab1cb8d4783429df61cca4b59ee9c3d8b7fb6c99c6dcf1629af907e2f1d01372033423337127b4409c715845ed02bf43edc3b634fd322925e1647953b08167ccacdb0335752e0a72a8d522a5b06ff19e896ecbc056e146db35ca2fd944a6453fe087d564e4b5a0e7ff5e705fb9602",
         Mac => "ddc60e14dc64399f48c2629cd9ef9551");
      Test_HMAC
        (Key => "23d992873b968a5106f95b3693e230420ae819d993a80ba8735d29db78b2419098d49a8cd5caed2d6409b1a00d439b54d58166afdb71d0ff8001e5b3ca2c7fcb",
         Msg => "13475d77c30210f6beedff5c38b926803e950da0a54f55a540bc90a8565b56b6523595d0bd0728366aa3abe6f0948e5f5d0169aa29d48f9b691ae65545adf60cac113f0f479dd005abdb1576d231f18eccc00c1eb28c6fe4dcdd4e0c53e624f689a5063a480a30eae95be517c6d77696f29aa00327c01a07ffcd6fd7674d0afd",
         Mac => "2c47a1dfc80df9195ccac2b006904088");
      Test_HMAC
        (Key => "2e4a7b49eb4ff970dc932c156e9a1a7be9616217009c6ff2a742f14f244b8e8e69b9d450a1d573dc09bba9c10118fdbd633330de132a71e7d77ed0f569d2f562",
         Msg => "3c5a85e4d4ccc1b8ff94c7c7af3031136b58e1c7452994790c83baacc2b086995046412f794ee3580da5e47e5fa3504ef8fb1abb8de2b2462f74d97dc253b5c2b091204edfd04676e0a76f2c694819c805604a090a3f2456cb39ba4a104c2270c303cc4bec99119ae0620fd9b467b50bf8501ab7a2881331499b041a94e3f62a",
         Mac => "f253721edace08cccce596b231bdef4b");
      Test_HMAC
        (Key => "bbfc60ad853142be6f602fd1eef95f882f478915aaad0ea0fa2f75e8ec33172ed6891b4f2aaaa5304a3d4b5e9ee0c9f6e524f5c3c8d9f5a7b58daf3cea4f81ba",
         Msg => "0e16a3bf115933403b178eb58a604ee203393afc54a61060b80882851ba97e2f7f96b2e69ead50a7d0f60ed930377282fac24cbb389284629e96150eb24d5a48309389f8acbb7d1d79ddb8c1ca71a82d171d2959c2cc4ca6fb0056cfe1690c1de9b62edb84ab420afc7492569f39784820f2d9bc3a7df09696ed4db1ef261d18",
         Mac => "32e3a37e8ca379cd7b604840059480d6");
      Test_HMAC
        (Key => "b9575f4d5ecc0f4f62e4a0556bb89464ba97d4570e55acd4c5e5177e452a3d6c9a0b3adb60c6211fe48640e08637a6826299e3e52f930f4f66cb0ea6a77311e3",
         Msg => "8c8387f4ae2ca1a6dd13d29e93580b1cdf6268da66cf589ca8b1ff0884f7d8b8fe299f8e41596e47e0562653612210e4fca6c446a0a54a6e37ef80d52bd7bb8729e6b17625d197159ea98622235223c316367fd5b03a3c8145f2f210c910d00094238757627e63379e75bbb3e0d08ce1b47961309d7876fc59211c60678c5f4c",
         Mac => "15af23331648171499b58042dbe7b2d5df72d152");
      Test_HMAC
        (Key => "d291adbf05b06596c2f36f41a8cd8070370c42f687b8a6cc3a3e7b59afcd40f07801369b0fbfba17c460d21ffa1106ee937971ffa99d17177f017985b71067a8",
         Msg => "50bcdf31389eadac5bb8197ee949f2864ede284c07d039a0b40eed7e6f1c43355d5cabc8828d7595da918a34a5735aa202a8159fbf951e547052bd39beae14360273540913eb30e75ba29266316e8d9a63ad947e11cee996c21357d3b19424b7688842b990c0c5eb08749ada344275b698740bb3a58282aed2d72514efd85d00",
         Mac => "5f7a57d42e3ebbcb85b08565304dab941d6234f3");
      Test_HMAC
        (Key => "902c2af0d13fb353f14a93eaba7e8a8f768eccacb264ef954114071b840e105ee9978ce2b27a6ce5f8fa34f0ef0c5bad6bc3f0f8a30c8438359b43f06b256491",
         Msg => "65bf93633e3a4cf878ddb21a5aa2672fbec644fc6bcc4ec59ec6e5b5ead03f8042dd154655b69cbb1a3fb785abfc6be556d5939af116d5026fbad483b1e9a7299ebf8b90764fd40563e82ae85297f15400ec09035801b86bfcb9e42d224686b0a1ee5b094b0edd1f7e5f710cf678e2c6e5940efe4696df486e4a7d7de4eec25d",
         Mac => "5921643e2713d10428843447df91f482f3922aeb");
      Test_HMAC
        (Key => "b9f4ccde4dbc27f1e6bb0fc9e854aa084249029cf32eaadacd1ea5d178ac83d8bb1ccd6af7d4a334f40da46be0ce0e63951b265e1b6adba26e56a6ce8197b46d",
         Msg => "cf7210d4240cbba95a8635c1c37ef8bc4bbef2dbfdb32e16c922b0688416a16e301dac307eb3a73f91ff760005bd2c47307c7427a7093009042b5ffce790444c3b08c556bbf1119ab4f285120cedd1c3832e569139e9d35771e34137946ffb2f799c22ede3ad40e54bc92ba0e0f42d57cd3e61c0ba3a602895b21dc292990e3f",
         Mac => "3f74a3b2a77c173b8b6e20c2ededffd43103e4f6");
      Test_HMAC
        (Key => "a1aa034687ddffdd659326c6d11f58f1451f8524c4996da8c04aaa433c3af1662e9495a627b54c70358336f909001b75551ff58978d6ae025d742ac7a035880c",
         Msg => "5d118ebeeb1a9774901045f4af19392c0a3f641b351618934b9e653ddf6aa2dd35024ad7b2870af39295175dd96dc5f08c5456b320360fa4338f92b57a8c6715fb6ddcb07c2d0ff93b6549e7df6e8d3dafc5710f02b42d82f62ff2d365fd7d9b1518eb512f55cf10f347829aa961ba9edb5c5e36c1d899b4fd462e9e89050bf7",
         Mac => "3b0ce0fd9eed9287527edb23c0ceaaee4026b570");
      Test_HMAC
        (Key => "8fc7e719ff492846f151bdc5f6f6ed15a6452442ef42e806ac2a0f3479fb2f56c63657952be4fcdafbd736331c322d78162ccd2e6910c2ab2488a07bb31c6103",
         Msg => "155f60ad0a95bddede2a10f0c8447acd23a541f37b768062e8431db99a48fc9cb6eb72586189fdca1975327d4c3ef6122331f1e59f1f40ede8616ae4e21896a800b9fbe25dca97e509e624d9a007481822050cd8fe598f0b7027fc830d7cb95a9dd4e19128dff5f75484ce4cee27d6a7c6277815c0abd583289fb9de46f9cd78",
         Mac => "c6c30cc650546dee441ad83d2c01b0bb50319da0");
      Test_HMAC
        (Key => "cd7fd6beaf8ecdada5a4dfb800617e9b5b83bf23215a0340507cd65c7cb917eb16515a43ee658aaef7acd3be4a67bee16e979e35d76d2c9eac026e15ce48dd43",
         Msg => "a5bddb41035156670818c030d2893f7eca39a429795de6a19e8aced57dc0f35379a7e9b0e518b62a18df858cbfc09f5278b8960e9c84c30a5b68f32f0f295e25ca5bd9bc31e34c8b8eb465d720dc8eb6b6c41d737cb3cb35149568dce8fbcd2cbf62112d8fb800d1921cc8d89ce6f6f1ace7a122c1f2e569ef9a94a4b13e27ae",
         Mac => "3e87e626a2014346f4d3b545f0c47043a657c82f");
      Test_HMAC
        (Key => "5657c22933cb8f8ee35b3ab821ab6b01ef8554252b1ee4a3639b3d66ead369a52b5748083eb0cd0cb9e76aa8c94bc931816ebd7b717178417b81fec6e2a2dabd",
         Msg => "3280224a9c75f01da9fd8bef8b925a1b7e901604ac8cd0064ee836ad15a41225c87713f22e1fd0e12ef50a3f35c43148d8db2ae2bb61508cb1e9b9912446ba81b8a1ade12bc9f12280c933d05cc0ec0cb0ed2b3c980a950183dbaa6a95064a67492577805b1a5cc6e5a28e0ac82e934e4deea1790c2ea74f0de5929f2e8bc9be",
         Mac => "46251e1b289f217c0b1f0f7dfd988aa62425efc6");
      Test_HMAC
        (Key => "589e1c67214c34f4380e1bfa3629ce139b297b3fb8318bd9cc90e0ca6d945bfc29a3a2126e872056a70a4df2a8c32f644c2f212c5c04d3c7b3c192e1a08ac9c7",
         Msg => "012870169ad72eb37a51b676597a2a8c0104464fb33fe6bdc632c82891ea922e8b1217ecb1c4d66f289fc36b241a4b30081792d9cfbcffc7aa7efa4eea7ef4ad2119a84484baa10194f3fd1cfecd7004bf5c8c998b963f9b70659d62b7fadfd00b65ac85dd6298510676ebefae3ba3f06df8bcf5b175ae21600e38cebe055c7f",
         Mac => "79cd6dd6ad3d3aaf11617b0a9303ed3645ab71b2");
      Test_HMAC
        (Key => "95ece1c8ae5e94d16ec9983b1089a37395ad5b1d660916c13c87e4c13dbecf8f68c6611c324a679471def5487a93aaec86c935025b4518962884ac2cb04e66f7",
         Msg => "4432f43f1b00d306dfab2c2a2409d049e1c30e897450d42ce62418657124766a3f5e1bcb75f7e1027064bb4b4edd54b6b10ff37abf12a28c6e9a8f70fe71b250c725b04b34fe000f10324caa005c1a9d512bab32f4572310c7daeb0d175c544362ef7d6661fc7655457da5ee426d69274a7dfe5a1b09a1e17b4af4e3c2cda36d",
         Mac => "cdae582296f2c18e05c47a2c3885b24e4976fd00");
      Test_HMAC
        (Key => "91650ed89aaa63a8fd43907daaf3985c6404ee02c23b92777a0b7de6de093faca7a0e7aff20623f1886ea8656280d4016d0692148ae87fdad95a4b4d3754613f",
         Msg => "7ac33ace5b4a6a3292b72d0dd4bdf853509d9bdf87a5bc155ef684c6718b9853ab774b16146e12fde9873878f240d29610c3f66b166828b4d97a15be8b3e848344318916e292fb421320296eb025c9c44db331930e2ecaf1bc0ac1a417d6ff436e7a5c986ebd0f49380a69b7b673c4272ef6b62017ff8a132c2ff042c05cf3da",
         Mac => "d985cf29d85533af9b58113d7153732678830390");
      Test_HMAC
        (Key => "caa2f077c0bde9e98c2f54a98caba4a9f95de80e742bfe92e23b03267ab50ddb1cca1d02e5f54f92008054cbbf4b2219eac9ea3b574b4ba4ba81c522bf3d70bd",
         Msg => "f4d7a8f73898fe68c398588dfe2e019231131e194517908cce121bb2491ec781a1038634f9f3189da5782cbb79aac88f47a5ea2ca33a700ee9e535ac82ff7d5062359327d539b0947cb71fca928b9f9a74310989617d32267e8c139b1dfa27813e5515f956d28ff8503f7ae2d2394f5bc19fc15a0747a07e94effda6a2768fbc",
         Mac => "790315ef7d9441b0ea3382471dd217dde2143788");
      Test_HMAC
        (Key => "ac049e1a39d6039ce480416f058e06995b54a23c4d26696b76cc583c6130fc1f915a906ec59e66457a148893b0499e71f13412b3906c73bd2f98179983260546",
         Msg => "504ccaaaf09c8e8a0c567ab7f1a1eca78ebfedced9e3b7126e43757e796f493ad7e193bb78d57137085b825cceaaf041d4b7ad9d4806fc3722c0349d0707c0196d866be1014cdb8e45da5acf7e7add5fcdd33e349cbbcdfa3b4c07bfcb3aa5f05c63d98452a8d4770dfc8b7ac9babbe9c23c2afd9ca93143030e774c8fb1ffa6",
         Mac => "2258ded89a07b87e3397aa8a033f151e3c1a23a3");
      Test_HMAC
        (Key => "82c16c68eca59a92986938366de60c16f60c98bd66d43e10d975a826dcdb67593055da9dcb8e521120be73d4a021de1a81a90d7fbef07d9b5f7013d6faf6b97d",
         Msg => "7416ef51d9ee9710b83b2f0bba9345aa7cb4f4ab8f7308bac4f66242a6239f824758f4e3405d5c89f397f628137ea819675109adca087ec1778aa3928320ecd3ab298cfd501095e7c07c6196b7c6325626b0150932540cc0805a6b88b06e838727f17e4712ef8a51a7523afeae55288a413be06ad040f9df68d085cc34f7acc5",
         Mac => "43673696e3003a2a06ab0f4bf07870fca1b51415");
      Test_HMAC
        (Key => "e262a7385aa3282c5d4298376acd1b7b6c978b029a0c75ac9c41656cefd064b48ae2be2ec28d09ad6b616263403dfa548567d20aeadcc28bb3e5c08816eb5fd7",
         Msg => "0c6908b5053e858bd901c18bfe5f85e73328301465a5b6c2d42de91172f3f7028b22342bab2c1ab0bd5e8e6e70b96579dffd27c970061330fc5b638f3105d14a359d59f98ca941613c2957a22f6c7ab1d8285b091aca859e650b9b1322c4e12c5103fe86705e01869f87a18f0321c97868d2543d2a9a15f455631a030bd93191",
         Mac => "449121a13d619ca26cfd574204fc9643df12cc8b");
      Test_HMAC
        (Key => "150d3aa309a3669af99a70f2cec52d3da16b1c137ff7466269f268059f2f54981f45958b68425276839e75ac446e0b13cedaee3355d1a28c28fc7e2deef00c822fa7b26e1731",
         Msg => "07355ac818ce6b46d34163aeec45ab172d4b850b0dbb42e68381b67f1cc8e90a4c050f3d0138bab27e6f4f8d678bb65e184656493b7541649a8bab60315fa16c882ff85640e483f3eb9789c2215575ccd01fd0ced3356d9ac695e3bb19be405864b9fc5bfa5a2cd1c1c4f894412b4f28fadedae4fb842e52b0a545d8fc6d2f97",
         Mac => "c73d3cf2bd6c5c9dcb91");
      Test_HMAC
        (Key => "c9c8b891b82567757dbf1a15b317628d98c486dbbe5ed4e6049a35bfc5b604264f182050973240e72ba8875367b55938eccb6c3f4e79221a0d9216c2c78cf403ab268f3b314d",
         Msg => "17925952af30959b1a5a136ff11b3de10db6e4cee19f31080dcbdeb43129a5f1ff71f9bb951cf50e09b3924e454d1ce61554e7307e873e9552459cf501081f48b23039869202a9c56cf0a9a17b1a69e17c16bd5806ec12081e65a78e0786faba5757807d50e998086c96c2323a8b0c1a6984ce0e22d797ac9cb46747eaab1f8d",
         Mac => "3b89bc8d9f3fbedb86a8");
      Test_HMAC
        (Key => "f3ca2dbf8a94697d351f5f18320749aeae13e6d57e15cd980f1201bda0a3c54aae9bb247b0ea06c405c23f1e2bf8e97f31acb4a46f2cc9e374165e6c40bd88cfb4ce51be4634",
         Msg => "00bd47d752532988758406e3cf718baf9bb9ed1be09a80fe9f59866351e4444591b75c9715fc5688e2f68004c09ff87eec9007ed0e22b0146ad389075aebcaebfc5fa4fd28f5d4d6a5a977ed9c4f205d4c7b28e8009e453c3e715e7642979ee5ab7ec8107386cafa246594a449ca2ad42340f8159e5567ff83fcadb8ef31e9bb",
         Mac => "d6d0b96cfd9fcbacd20a");
      Test_HMAC
        (Key => "e552f4fff6f6bbd14ec50aee19491452ac917aa36a835a1fe87488d34ff61b0d02f12c1581f6da188ecf91658e5b8ddc319999a255021d1a281c57118d4ce939c2eb94d93f9d",
         Msg => "ca7e275113faea9fa709a4ff193bb035ae1985a5c9c3d316a6d8cfb74b96ca5fbc4309196fcbd1e0ffaac1a7240c659de33307ae021ac84dbf58f071c24683dd4f6415a5c0f9deee33fa11f5802d6a536e8e067f26f27894e7ea1954fcea9f6debabf2fcf0cd3b50a9c13df013e6e8dfb5f22b1e1b940b738658f269e2ca4998",
         Mac => "4fa9b60a5cde90c2c0a5");
      Test_HMAC
        (Key => "9d4219ed569eb35a9f5513eb1b938842371a995856da49b82bc299eb65d74f339283f67c3d2f268f5a140589e54d0e8bc53111b4f6e17b4ce71dd842215c96d92a1b0c9ea975",
         Msg => "f211cbcbf3f7a9c489ebe8f76922fad5cd3d0fa66b6e9fd0a4dd4256ff4ac89fd5f386794eb8ee5d8c7d63f525d04bdbd7cb65a4773c5c1d2b049dd4d9bd66dadfa020c805a5ef00afeb8735585b412e3b896ec653daeb3886ecf6991e323fa678df42c00006d5355dfffdc1e80c0655633cd316e89072a91f5df3aeb4f17b8a",
         Mac => "b621d1fa15d9345096b2");
      Test_HMAC
        (Key => "4e1acb25c41216f48b66627320abc5f5e0dd1a7427f548cbbab9c82562d861b6da3636a9eb850359d615a4c3f2edd73c961a425f3947b84ad88eb80a998e3653adbe9e747a00",
         Msg => "dc59a9d3b6d846f0c7b2ce52eba31d3bf192915e4c7260e70b662fbc0c28e0026cababe441ff708f8c764b8169056a0489ec1bf5e29929caa5ca69d471f390c0c6df4764bc9982b9f58d0d23d0eb67f9df4cd4419c98aebb5727fc22732646aed23da7dd8e6e2373ea413bbf881ebf21dcfae4c9e03696c109c30f2e7a8ba9d3",
         Mac => "5686971a145ca79e0b63");
      Test_HMAC
        (Key => "4f047d37c653ac9434b9ac3e79628864179aee4f448ee0443d57adacdc3420726d17f7adbe64967f75f5fd3ca661f8cfa57e955a1924db1d5234b999ddd93df5550e07a07b61",
         Msg => "62e2a73bc77ac85b1aa812463dce29a097cf3c6973d98b76a28226226817f74196300255f388ec05e00cbaca3c32dcec868c6aad419dadc39debe10c5355397ed1a7245d976ccfb0e104ebf586f6b014208722926d8b9307f57b69d2edc8210b5c6f94b97cce794563b52c2fe2c1ae00aee5ec80bd4a4428f35945dafe16b6d0",
         Mac => "8ca1bbe34502616b975d");
      Test_HMAC
        (Key => "22329812517b7a7a31d3cbbe04c3004e07e65a36a34abca4e71abaa4367af22f3db39f6428906b1516088585ca1cf470a3032b4cce85ddcfbaa512b1cc827bb3557f02e0c1a2",
         Msg => "34576ce2cbe2173bf40de23050851aed2fe7341f5678b34f00154d6e226d49b1f36d2b9facfc93688ce963782021204cc1269b845ebcd03a7ce60e937a1058931a8e0c363d45c2bceea87744a2e7eb9cbe6247585a640321450e0750499110bcb0a156cf06266ce0213467bc5f3d42862f8581c2d3d715ac647780ce165739d1",
         Mac => "970c9b7981a9b706806d");
      Test_HMAC
        (Key => "09e5e326d7c2b5b17381094933ea11a5030c36d9b8390d7ba15187045f44687af7d2fa4c2695027ef542f3058c2c62754b09bad917f931e2f2c4fa45cf63bc5ea4c34419c0c5",
         Msg => "c8ce9813cc18ff5ac309ea9e2a79e5091387a258d2814ae1fa0511d488660dc15d51485af2b1147b47cf9e671cbec65564f62e2bf73f918987d15709d5b966c5247e3a1aee0538acd7b23faadfd08154db3391ba261bbcc6945c9d7ca7bcec81069d97da2adc14f75bf8f5f0db77bd0e6185f28dc8df73a009ef0cb6673848fc",
         Mac => "fb8e0cd4a7656f1aa4da");
      Test_HMAC
        (Key => "25ff10f4312ecc23b4af653fef943c7272f9847031d1f959dae5cfe16619e9aeeff14c02c155d399b39124d5b8a0e218b1aa257185cb277c74164083a8da14e90d230bc96384",
         Msg => "c4c45cc235592317741f8ee232cffc52e9cdd87d6f66c9bacc56284b498eb740c93490975cea5ba81253c4c10dd32d0dda979fba02d6075adb569f8aa431aad2d1d964cda45a398afddf35317378bceaa31a7bfac8e89e2f8db0437f1fb92fec85bcc0ab34302384decac77c8c4512b2ec5f5287ec24f601876efe72dfadb054",
         Mac => "dc82b94bb291d36a94a6");
      Test_HMAC
        (Key => "81168b80d79f8ddecbd9e411cc41a22eb02b63b304be3bb5a140ed3b80945ee5d00049d1453433beb288a272da868a5a84a80871cd625262c263eff12e192397b173ae6c12ea",
         Msg => "2c869831696381346890bd7be46d798e15dd5c8879fa6b6dd4072abe76a5044bbc4aed49d9f046a4d60a0197d8bc0579a24bd4da5ad36bce90386a897c5e742c879dd9df0e6f7220626ccd5a13798aba6e3c053e44d3360fedc5d5108d38c1b79665a21c8e4acd4f139e69ef1c0ad0f8819638ddbe6293d7f496b47c309bb293",
         Mac => "e61320faa6b1a7b6796d");
      Test_HMAC
        (Key => "c6c9fd575759c0f6010ecb932fb29559b5dc24c36e09d35423ee5289af0dee0c6187132aa2310f87d8e918108a2b9132c4df8949bd75855cb7347f0727cf2eb8163a881fc7bb",
         Msg => "008cfd9f494b35d937ef3e1d8dbf95015f1284bdd206ff822375cd0deb25e87ba13f255f60031712eab9314aeeeb2cee86d1a829040d16beee99d59b47fd9bb010c517010f32d5facf306103e888af558057ba0c12bf6c7d6fdcbec902f920b357041baedf40353aed3a157105fee7dd568a028d8583c868ac27cec1a3833e2b",
         Mac => "490d70fc32e3c5f6c17b");
      Test_HMAC
        (Key => "560d76c1bdde2e56ff54567df6713e4e243c1a42f7fe62fd4bb1786a31b68c0defc6bd95482b80b1fd30462593d6591d57c807c1a0910309540d08d3ad1dbf333d9fe30a309e",
         Msg => "07128bc2e31dcb22aa5b9f3ed1b852041d36f022168f59cab91c95b26df56760385a25a43351c6663b913da1ea9f06b0c537fec9b7ed77c7bf148c2ce5dfb26672c69051602b11fe103eb7b33b1e32322b41313e2b15785c3ce732d7090589061d1f75d154f3d1728f2ab479ac7cfe13b61b318b584f8311985d31bbc2ae15c9",
         Mac => "e271addca04e8f983680");
      Test_HMAC
        (Key => "a193b558891e947e0ee76f912ad51c607cdb59ffe033052143e790c9b696b022c07555aaf994e096d4638f73bd743c096482488458b3d2d6d71a2c57e5808fae9b640df5c240",
         Msg => "58dbed97e835ff418e9b06c0943d43e2e3727edf23504b8b24798cd07d37375c73cc59971c035bd8c40b84d88f85c06760dca05dfad5a1d46567b19494ccefcf44d8b30f278ace6c42e1130293f016a2f83533c84c27d2cdd30eea5ed817c42d94a802e652f1df65d1c4b826eaa6ccfd72264007626d66e035173e1692413dde",
         Mac => "e2280710a35f000d2ca5");
      Test_HMAC
        (Key => "dc986d3d92368e2a19f49b6e537aaf845acbce31716c79c43ac8809d29d318ec38ee2dbbdc0bfa2f3811d60a91825175035b7ffd723b94dbc3c8b1784b4efe3087aaf9560e67",
         Msg => "10ae29e78abbd1c4ba1a24bc417b6122f5e9b87628fdb0382e51c6fa193856b9c7acbf6d1f88c3df97f82cbbf92db5e6685527119ecac38f7789e063b3e7d59ef77f19e8166fa95c8fc4aa9957325015d809feb53964af9be0a39440351cfec2a90e7f7ff8d64ce2aa66e67de0f2fa584dec858983333b0570882ab628419bce",
         Mac => "2a7d988c3a8ed31c16e5");
      Test_HMAC
        (Key => "086d40b5bbe75dfa5905545f83bcd52d712f092fce2c0f5cc9faacb569523e7120abf258a4bb376dfa3a73cfd3e9f4e11cd329a9d1d212761256f5c678625366a9d71adb2af5",
         Msg => "33fcb8eff417866344632d0f9e8198c4dbee1c139edafebdef37356b2610729f0b1c5eeb3b932261ce402d4a36d8311b6a8a6fa445d7358b28a4a5f9e78db793e37d82ac737bb7b889c76e04922625a59d7a05afc09568a7b74f993acfd6da2e0346ac9a647a4a52be2177a67814794cbce7669ad8bd9ef8e4619996a593e35a",
         Mac => "14ad915c8190567f889160f9");
      Test_HMAC
        (Key => "5744618fe8e5c1e4cad95cf43505cc032df1cfe50434ed13202d5bfefef420a377907660426b7306bb03e82fe2e18ad2a7cf4f1465461b61ac269cbc43a972536d9a94576cc2",
         Msg => "90a02bc5f26d2ccc030b1503c6c712b8e6ef4b41ec33b887b45137c122f2dc8211ce88f68c17bd684115b008320ea0ecae68675480114f32661f26eac5b495569a25ad0db45bc3e521797eb6e6be2e61f3ae5f11556cafc1ae6bdcffe24521ef14ebc392d1ffe7488a7ea69448a263209b075c01d30c803b737c8188e36e2955",
         Mac => "43bf1001ad1f5c5adf0f59c2");
      Test_HMAC
        (Key => "6154b5d6d233c4e630b4b2094155954ee63f80cbf4ccfa3d4047afeef9f366dc3b4e3317e096ee6b9a8de33f3f7acbbd6370fc332cd2dcb962179b15c6cb22dba5d646d9ac01",
         Msg => "ae3897b902c499faa6e54fcf8864ae65eff6e24903b5ef7e8fd198cd0683805cc4438f82973b97da7efb3796b06e0016e00dd7bac0529af4c47007a12841d99934803384bf3842f0f27c1fa14e59f228f0095db814691834d9aed88c4453764a86554d6882a3e4658ad0cd98690cccc3a7523ceb08e3af6756f2d53860a19f98",
         Mac => "72ad19cc01c8933dc6a37cc5");
      Test_HMAC
        (Key => "1e8602e3f3a12b3f9ab21c3a7add7fa9a5381eff4f74f51385c08c231cea8418e7c76f0b2dd6e5095920d413f4621769d16e4a0987cfdd7224ac68ad20ef3e8e90a545389ca8",
         Msg => "7ac33ace5b4a6a3292b72d0dd4bdf853509d9bdf87a5bc155ef684c6718b9853ab774b16146e12fde9873878f240d29610c3f66b166828b4d97a15be8b3e848344318916e292fb421320296eb025c9c44db331930e2ecaf1bc0ac1a417d6ff436e7a5c986ebd0f49380a69b7b673c4272ef6b62017ff8a132c2ff042c05cf3da",
         Mac => "639410b3e778003a9d66c317");
      Test_HMAC
        (Key => "caa2f077c0bde9e98c2f54a98caba4a9f95de80e742bfe92e23b03267ab50ddb1cca1d02e5f54f92008054cbbf4b2219eac9ea3b574b4ba4ba81c522bf3d70bd567beee24e9f",
         Msg => "820037b251f283a52f6c19177dda02fe2416060fd593158e96dbe6647a3bde72afbc3325be56514a0f617d24ac4cb8bc4691e6797de82ff05cbca6fd23db28134a7187d0c237e8d57ee86ad432f509ea5b79c1307f6ff68db62313ce69e672f85a067cdce4fd11ed85e92a4f993cbc3068b5e05b638f320aabf876fcd3c482c8",
         Mac => "ac6f7955adb9610c7a30a046");
      Test_HMAC
        (Key => "12145ff87225dabfb7c8dc370ec61b16e6219c14a4fb10f298b464bb3053944a6c27c00c92ae810723b57d1b0dc1398822ae2fb1c9962120f4f4acc952092093c57f8f14164d",
         Msg => "097abbed69ebf2e5e87e4ed54fe38d10f32f4073962ed25088fac6ab11cc40a91413c745ecc349459af05f6c229bd3f232cc603105e1b8a18725cc06baa447e8583e5b44bafbc181f89efba5527dddc9ce8f4bcb23c74442d6a020b7a3fa15121e2400529a3a62814ab1a9e7a630b27f10a18ba7b8897d1bbd944a249575b30d",
         Mac => "abee151bbe2d515b07c63a23");
      Test_HMAC
        (Key => "495539a68141fc099393ad40555a70ebb45e3d37f9573fb14b5c7a5c759eb100ea5687c606fce40297ba9a509c2049e24d1980185b1e245178a916021aed10057cc4d033e6e9",
         Msg => "3f61d4e1b7b2014510544a12ed367d378f6204bcebc8a4a8003d6b2367c3e3d82c0b8c9ddc388956dfe69a16086b4a886b5c6a8e6f54bd2724f0f596d61edec1e298dad7c8ab8d35823dd98b140e0d3a653e59014d1086d9efede31d49ac83ee0910a5d6a29274aba061f1b738a82d15240fbb5eae8465860a3b1e00e8f33829",
         Mac => "21b96662150e4f742128dfa3");
      Test_HMAC
        (Key => "387ca57d6cea7ece2adf507ee497bbc1cd043b32e3c04d6b2d45d4d34160bab80ae3da9ec89b1ed65881e452b634a7b7c0a7dbb43d1718931d417b0d02d14a63001dd6aaa113",
         Msg => "0f31992894b41db6dd3e8c807caca260b2ca46b5320e6bb5288734057a105b874ec9d373ccc8aca9250b3845d4b16c74246a8887f22dfb46b4298087bafd8effb42bef5775caae82f67c374f9ea0ba3ac0c9d088666e61934de3c5623087297c494035fe1624ecec5979d3c562e0555a90cd66df163a6743fb9d49bd6517f6a8",
         Mac => "aaf4e6bc966753260f912e95");
      Test_HMAC
        (Key => "bf1512506858d2b38e387a1e65aa813bc1c1f6e6d96a6a864b59099e61430a9f934e4a014dc63391f211e30d20e58aee36b8148513780949217db17093bc7bbcea3d9f98becf",
         Msg => "8eeabcffbbe968425ff795fabaa1a9c77a2ce9a931338fc205921c5eaa83ef308d0717de528866c181bcc6e67cccd058b5b69ba11df0d28ee04e0a334f25522f1db10b31cfb4fabb6e609b267f77b8e735b13b10e45e411ab94c6fe1a9eb89f0a7af40ff1ab64cba8eabbbc4a9ea89fc61e470ff6dc501eef955f4719e1cbdfb",
         Mac => "6ea8c31c4035c2084be1743a");
      Test_HMAC
        (Key => "332c022cd7cdbb71fcc3eaf48635a8bb6e03e73f5c08a9cd799c702d7e5df58212301c7152822885b1d42bd20276c1d9d392feacfd6da55379ea9b6d75509b1aa74c2a19e23a",
         Msg => "07e23ba57979f53aad3bcd9341e6de6fc64ff3770c9cf019a0b36e9394f3a64e7e21906ec3a54ca716f6c0523b5383c011b4f9cecf00c0b98e804b340894cdb89fa4591ca15a4765ca0ed9df0a821f6d89d0171de9a019ffcb9e7238942c50527153ded69800af1dd16d606335dd791d368c958ce0e6c3935ff72bc6c023f5c3",
         Mac => "07c6d34628e28c8ba39a619a");
      Test_HMAC
        (Key => "ae1ba736e20691bcc3495be8e438d9cd5aa469de20ac7c5dbad753161960074cbfd1ccf423d3762157453dc0e88bbd8506294125e49040c6623728b3eaee5b559770775f9d37",
         Msg => "8c79f911b301a8718cc4b19a81d5f0cb6312d87c5b4b079e23a61d247541cfc2c41a37f52b2c6e43a3db5dc47892d0e1feabcc5c808f2391791e45fb065159f99c1d8dd2f69baaf75267eb89dd460f1b6c0badb96cbbc8291cefa370fa7ad6997a4ca2b1fe968216032f02f29837d40215fa219c09161df074e1de8e37056e28",
         Mac => "ff39e0b4fd5cd0c40be32024");
      Test_HMAC
        (Key => "25117774deaf7c068cbd4ce82a595a584ecc9dfd541ad81eb9d71f12c53b97f76d797da7774d6ae8dfd4d5e37aa1d9d8d90d380f70cea112f7cc2e19113031c62cbd3012a863",
         Msg => "08dd4f5c7afbdb4363a7df60d247776d6c7c122eb155d44981c23858de4bfa3df30134b555b5c7318a69fce1c8046b11fe4a1cb8190aed4e809933dfe080a45e2f72753beb81bf37a3912778b90cbed866d72683fe85f7c176cb601023341276c4165915c3c58c00b806a84d2fc7386cab0d78b7eb2db9496b3f07142ed00a2e",
         Mac => "a52411b649601f629bb75f5c");
      Test_HMAC
        (Key => "aac2322ffd2efaebccf8389eabb3411ab55f21087d90322c48cceeeb7934020a4c66a3b8c7a325cfee2dca5737f3d84c3d70eea0b8d19784ad5620e4e2faa730955675626dc3",
         Msg => "7261818aa26ad3861426af03ae6ddcba10f19213d473def6143747de2db5b230c39183cc06cd05e1333e0c055d3cd9856d9e3df968e6021cf0b886db0e91a9ac2eb5e9216b69ccbd0d637f06507fbcdb68b3f008c1459e188b3bfe6b7614eb88bab5fcb35ba6f0c3ab7e4f2e109c4e660718f36869f97b91eea9f9b4efa63f6b",
         Mac => "2785abca097ad771fcaeed6e");
      Test_HMAC
        (Key => "100bd00e9c4c9f2becaec6145640e57d1363a9e8e8dc95610627026c300e643c1b7bd0251a8bbb54fbe305be2b47365621690783fafe24d1611730e7b2af09b95f804efe921c",
         Msg => "725400784625df22bbb897e7df2bdc801f8e8c1f724788f5d4b5c3f7f61498e234a1617cc7fe451d3cd7516f24c6ca720e74c2c3b202ea1d6fa7a720f89a68514a323663e14b8db52bed6a1b3d28a5e1c542810d3f1582e56cb27eb1004af7c29b4fa8b3fbd65eef70400973901913d62b40f0868248f754b31f703378edee3c",
         Mac => "86d5e21fca7caf63426a9a4f");
      Test_HMAC
        (Key => "e01b54dfcebf64fdc61bc0d9a46f3850db32f7350958b6abcfd130d1df52d6a55657c3224d69f2acaa9cafae3c5d4b82086a1491dd2284bb2fffb9f922612540e48d87a940f5",
         Msg => "abc9ccdfbd92b6919a5d6c6b5a765a39662ed90080d3549204dfaa5f6d70d48e1af8c84d53369d658765ef11d7b38510d9f431f99598f8cfd4da73d59b3b75a3f22fef7ae91610d5dd6db040f846ee6df7f51885300dccbcd38b5d28705078d3b9d5080f8a1a560926df75a1c417dd794a9a564c581a188288583001f4972545",
         Mac => "0aa1a8368477289bdcd2bb2f");
      Test_HMAC
        (Key => "4a25e3a88eae864851b4c6d01c6b98b799a70f0ca49f1860a4f167df1ce7b1c07df91ce03f93f4a92f189f390b26d3c04c1c062a43d926ff67c78b87ee192a319a500b35d604",
         Msg => "7272eff0b28964a1aabfa08f37527a8607043fedf31ba6ee8fad05d8ff1ac4c10cda126f7779d8798cdfeba9fbd586a5e4c5f7ce31c1986928c701fd40447cfb34d6baa45756c4282716330b2467a4cde35f67ca5ed9775f8ebcaf4e3c813a6414ef4c59fb290ff7a2ebe17e5b11bc482c59f5a922692a19e814769598d9e642",
         Mac => "76122c5582fea3b4f59181cb1d83a5ee");
      Test_HMAC
        (Key => "13e8b6568b1d83ee06235223caf6be6e76897ffc950a9a0f7468d5a231136e4c15030c6623fbf670f10f83b1b764d21ea637ba7d7b2004ca5398d8dac1ba763e1e46276a20eb",
         Msg => "c2c1ad604e21c2c869193d6797ae657ee740649c7805eeb83cb6237dfc88b7e59d5e5009a13d2f38f1001346d94d5a2654c76abb8a854fec97c4a5f78ed8b907bd69eb0833db57ba800eb404bc487b8ccb6f4c84de7c8fc73d2c572445f88bf9ac4847040de48077a0abe74a488710d5d4a0d49e7ed0f470b858fead29d175e4",
         Mac => "87ae0952132a3b0583317997e5907ae4");
      Test_HMAC
        (Key => "583e7b26715647c6c50482866f84c9a097ef1f1bf4b18ee48e3e1120c901b2c19f95f0572d386329717da38552416554e0dfe7f1dea88f3c7e8dcfea6b1f4b1f0cba3e3e08fc",
         Msg => "a20f4cfde1c12ac3aa4d11b13dc4590ad9395f0ed28032d8e4368f87c701109c0319a0a30608321674aeb37ebe873cdbf6318d46e228b7d54fd518bfa7c78cc0c640e2bf0af38dafa90c9cb34871ed85c9479d1864b9c27cf9f45d03a4768aa29389fa99140aa356f26fb6970209d2d0f98577cc80b9bd968b9e469ae6987108",
         Mac => "702a4317f0e27c16ad95ec8217917285");
      Test_HMAC
        (Key => "381dfe5c3405f0c67216a34475d453af05f8ae8fd47b92d561f119cd1d18d34ecdb152342f8eec0fe0edbc1d7d04ea7608dd2c878e648dc107bf6e927eddca957252be067b62",
         Msg => "3b8bcf1cdcd4b5673d298f8df1e226c1a7ff4a2552bd15f588677402286fe26340bd77672e4722ce05e2333832571cdd5fba787f97f74c9dabae8dead541e3fd9c2bad4af7934551b52085151c108ad0d184b7e5f81efd169bce5af750e9a0a2167c78ad81dfa659178d8f0cf932f802c606103fbc5ab1c82070e312e090a2bb",
         Mac => "dfc632da93cb1a878ae38c0cdf5db11a");
      Test_HMAC
        (Key => "772619f048d8cfa9cb846e1ac8deb0ab56b0029eff70d0441f1802718d32c72d7d3291aca50961819ff7440e8fa11d3f0563a67825e7b2cb05f7b56f568f856d4737629da68f",
         Msg => "5a84d46560d7ec2d1ab663c984022cb24393463581c5361af733b4844bc2a5189de249615d10b6735f9f85cf31b9cb87aca14ba3c93ae9c2b6cd620529073b28f541f7f2db058dd0a2cd19bd690dd2643d743c89e76f9fa507f0b7d0676dade4892b46e082bc5b8a0bc78959d60729911e9682b0826c3e0913221bafacfce394",
         Mac => "490c969829f9413c70287001488b0f18");
      Test_HMAC
        (Key => "f39adca21ff0939639ff8d6da236d519572de92a742364e7f7aada9ec7a10438f5631d10413e8b06e027c2cf7cab668f7d29afa9873f12d543821e746372a421e0ad1a898662",
         Msg => "9ead422c9e22b885a422c37ea49c271f9d65f28d297fae76519bdbafa5dc9d1c8ddeb1d1daf7a576a0bd49f048c8613ee1b99ca0b77acaff27c84989b1efc09c4fd510e5053a88c9ba3e59034624498fcc55abc74aa88ecd6ee03528ac77c7b28d9a48b14a74c84499afda01c73848dc0743054a0a9063a7cfec86d5bdfa1927",
         Mac => "a7549bb8be315b3a8fd3e62c8d960758");
      Test_HMAC
        (Key => "cf20eaca221a646675f696c2c9ffab2cca83cdfa0135f4154ad0fbb489fdf96a9977ce63856dfcebfb28b92ffded4248da2571755dbb92a844c67345f368ba266af57be27558",
         Msg => "0f7251cc8687e3e02c363af2ed4551233cf2bfbb10e5ddbe2c622bc0a4c3f0f99d26219c54638465624115713ee9a953039ad164739f015a3c7ef21d7b7344d67f1c6848cf76bd636e08f9165d5ecb6662b9bfbd08056184e70ba5f325e886283dbeee77ffa9d602d9f5ae89548eff83e1b74f6dd6ff4562b4710decab0cfe1a",
         Mac => "9d0b8ca2dfa14e8aea28a65698796da2");
      Test_HMAC
        (Key => "8c26d9e739fef007ecf426612f7408daa6a8e41aaa918b3e335755cdfbdd66eee09930d88aa339894f0b1ebb5370d914f4ce3f9d6598cc759807a3c762b1d1f9da5dd2260216",
         Msg => "e437f8b6ecad318267ddf85d7ee05b35382e3d6b40564129e9f3eaf66fdb0087809935d8fa1e087cf7b3ea3207329fb8bc76e8e46c105ff0323ba2163613b35c2e019fb2257a5e3a7be9fbe72ee9f54957b8e4a7f8e85f4ff4581e2a5f635c93f8577f69f429fb63fe6774a47b6d239012dc7add6c480bed3831a65b7335c1d4",
         Mac => "0d5aed6fd871560f8123439d476e19bd");
      Test_HMAC
        (Key => "f1e95a2ac2982a63584af1b7aab0ee739bacccaac5058187755e77e1f669e910135891ffd794808397b24deb33a371d9982af25089933f0da0a35b1b8fcb3ea2aca07900ad90",
         Msg => "5ad21401118c89f381a8343b12fd5a96d95d587dbc26e758d7149eef1f59b92145f018d8de2e8b3cc09a4c27affecdd939beb4eede69248d748e3fe1cad1e9cd8c3dcedb66dca6766c85b85abaf69c48572346fe60cd40666255370e07d3b9d8f5633df3f3bf64094d137eba7a0c504afd3215968979c24d68128e5c1e87b2aa",
         Mac => "f137933e9b264f559dfd0fc262a69c0f");
      Test_HMAC
        (Key => "4c1624a9407697dd3feb1bddd4a9ad07f99039e12df356fdc69d30208916c5a278225518eb8b1331e22021de9afebbb65e0eb398a0cf1d9248564b014c93fcfa81d5d0e9b190",
         Msg => "e3a90651f7652c0c7dea981f8167c7e3879f81cdc249b1ef86b773c200b76f2225b7669ae82c0ae2b03413a609798f899959796a57458ee6f7675c1ea8889cba0230c12e3a0fd13b999b74b92cfb4b95bc2482160042a9641259bf4a202c903b645e429356d72a202069e4e152b3a20dd746c4572807a971bfd5c5cfcf6bf4ad",
         Mac => "b4276d71392026f683012521bda55952");
      Test_HMAC
        (Key => "0531b92d1b218c08cd8630dd4861f7c80aced6f75d7e0db81e670ad6c3ba8b269d16045d59fb4024cd814a6ff24a8e0a2cb53c74d254edf1eaa189db34ec68396b98b793c787",
         Msg => "b9b8f4c824377a6cd1a31b1f3a21b551dfc16baf8bb002f4d8b08b02f5c64331a732b7e78ea42c69aaad3df01e74c60033aa01f59fc0efdf0857fa8fc4f8d8f2e305b29e6fef86abf2aacac4395e527d586073e7ee606963aae4f6b30ef54c5773172d164e7f51dbb18108c21548207356c909affff93728c83ec8965d246707",
         Mac => "6369914b2350ed960f0e8128c02f04c9");
      Test_HMAC
        (Key => "ecd29cbb1a39d7fdbc5c92a096c0cef1d4b2363e9e895537ec2b079a9cd32d10c211a5523f127a8f95215712f96e4220aa0e861f8244f1fecaff40d053a3d8bac20cb7102cd1",
         Msg => "84c514e4714119a9e4e47fccb9e82404dd5a785060d631decc92402cb69d036d9269bc2ecc88423914b3f6b9f910f9a0b9b59c4657681852efa880de47f2f3d6a63d16a1e9c7c104d313f943a5321f89ee436689a5368b6675d5c0d05804e97167470a87f18600d2ca0d70b0e5d7fe87250cbf6371c8f0e0071ee84b125d4b04",
         Mac => "d598d7af92d2d65d418a116484cdad9a");
      Test_HMAC
        (Key => "f54e514eb70f39579c9f175afd7cbdf1de2fdf102b8276e042ee63cab25355d142ecec2636811ff6cddedb870e85ec83c4a02194c839ab307eadc7b7a25e9dbb45a9679e1218",
         Msg => "3d31cf76288ba777d0da29e9ce21d69dc6419c153e7a4d2eb02f5001dde9970c659fd08d9535e02f80428de851167a22dffc591982bc5c842664ec779d489e883a4863319b51ff75c627bcc678615f27b9b55b8eb475458cc65a882fd5815a28e3b3ee29e2e9eb91ca0f1e4bea096bf37bf40a3b7baef08eb9988af32c9ab133",
         Mac => "0dfdb14b000d0420880f83192888bdea");
      Test_HMAC
        (Key => "e88006364955d8110c553fdfd59db9baaa310ae50f9081026f8b7e85be5631685de0a4213e60fcd14830fcbefddfca035a82f686fe4ab82b8f5c79475adc9558394b60f3ba14",
         Msg => "4bbb7596f19aa5ded4017a81cac28e7d6a685253c01a5e0c45c2057a0d6e2dc043f65d15d3df18c4667f6a779362c0b653edfdabb641c928d5622ceb08995d205916d42738daa69870d41284594a57fe4f7bc9da648324b5527e2036b4f04692756501568854f861d9499b2f8443fc5e465be16a30a717bca35e09e3783d9121",
         Mac => "dba4d87dc72e6187afd8381a490b0d0d");
      Test_HMAC
        (Key => "deca6cc2bec006c19ae4b3b2246fd63608aca28b225ae80bee522df5406a007035988bcd695b670d6a56b5a36d3e6a7b40f7ea3a80fad9c80cfa2d0cb9c788f64872c6c395b2",
         Msg => "f4a65ebf30900ab9860490c7bd7c0ce4f46cb5bb38830f10522e625ce25f6ab7b28c50fb44fad927ad3bde01a6f6fc00e1e68c689925d5b76dab81406e114e16779b062bbd76b1b9a63e09e1dfc42e93a90d9bad739e5967aef672eedd5da94febdc6897c28dfa381915faaf8d6e0c64f4eacbd2ee7402e7bc191eae56c8e32b",
         Mac => "97f6e4631174e11964193a37a916f257");
      Test_HMAC
        (Key => "f0dae6d8753076b1895c01262ca9b57633eb28b3f963a7c752e2cbb4c0314c20eab11a10493faaf4255a8ee4c0884929d1f561ff335eb699df2d116618e60093e5c1e2d1c499",
         Msg => "61cb9e1f1e4b3a3b3bdff8cd5f24566b987f75c8a05377855f772b49b0e7ec1368b9c6cf9553db2803dc059e05f0bdd871983c3bed79dfbb694bd0f1ed8de36e9577be50da313d13124215a93a4bb7ccf4f57793cc28ed43bf7e9b68fef7d125efeecec9754b28a271fb6e16899d0bef287e6df7c5c867c569f6d4d66b8b7ee0",
         Mac => "62ac956ada19f04be50c23f2328a32477cd58fb9");
      Test_HMAC
        (Key => "65af1f17cd7fdaa523b9b7a9829d497cac7303d450c59e9888cbbaf3a627c8a830d327a529578dda923fa94b31cc076491ea338d4a6221ff8251ccd6b4d91e67b11610d3e453",
         Msg => "9ab4667b2df7eb4be8863aa53e9bf9af8bae0fc09de94f7373dc56fa4472b6b5c4235403a26c0e59557ca1911831ca843342acda7dbe72211fb5351d9a34205f0c77d219af5b0331a2126b94ec1adfcdbe70bed6f8018b2eef61db2b6dbf7292fa19a9655aac13fc57af5f57c14080b3b29f0c5b169ae2c16b4810cdc6faf475",
         Mac => "a279d055e2d73306a8187344fc32cb0b5b80cd35");
      Test_HMAC
        (Key => "538b4a4753183ce5607fa03636db2fdc84722aeb9d98a6ed70d0282aba3571267a189b6aa6eb65871c5dcc59dbc7db8973c7c355ba2a2e94c110d1f4064a4087eb07077e67b0",
         Msg => "a1c7f3c9a79b071b49301aac754a2e89d971fd90a7a2dfc99544effa295d6975330657359b1d6d295c3931d0d1e35f0630038b1e54980830bfac09b4df880650902461efe3e14a131d7ae06c033898a95566e38e99050b4719c15efc2f238fa5c00759200751658094dc6ea994b3a31a52844d09fe51b1b5ae6938f8a297cd1b",
         Mac => "05598da96093f17687d9cca772ef61ea2af8ee40");
      Test_HMAC
        (Key => "1e7982d0975b36da4144041fac9a7f70b4d5180bed489f11453e073be4496ac957d74cbcee06244562ba197dbbec09567145cfd2d2ebc673a39b89f20af8fd34ac229279128b",
         Msg => "8c5337d74388cbbfe0f400f403879687887b6b2f5cddefeb8f49d8e9abf517a745f00a58d1acf389bbbba904b3d68df44823c04bb8b89361065b3fdd4e8bd7d956c57a416500cd7c587aa84ff2b610fe74c566b46dc6dd24d4a932715438974be757f05ca68a41e2e0b9679d693007eb34eac532240fb67e20bb176b66013f46",
         Mac => "f174bb064880c9b111d71be221ceedd9add971ee");
      Test_HMAC
        (Key => "ff5f9fb03fc15b2143ef638bbaac07557d3efda920bb9bd5c68349f13a0e37c23ce84bdf19f95e127f0aa7018e85770e327c277bb1ed4fd2804539845b2296d0945d6fe6ac48",
         Msg => "b9b50774715edeb6947842ae807d18bed911c4c9ce3491fd9ebb53f05b014befefda4a935cc81994487219e2b85127f21cadc2568cc8709151595d29a73b46fec16795d90e20ce48bb6d29aa79cc818680256c21d3fdac4fc6ecc689be51f040394430710eccc37af552bc2c4956ed210d610a4f2e3b0cde075dd4372aa9115e",
         Mac => "2f5e0b070c0e268578ac6e868b364b144abf84ad");
      Test_HMAC
        (Key => "06ec0e5bc833caaf766f8a531b09621c0c93e859280196ac5f166f18711ce55af8d8fb7da9bda7a9d7607a3c382c821bec57704bbb14f6bb9f0b73648206d29448edaf8710f4",
         Msg => "15b186bce73456813d85a50e68c4e2a5fa4ec9a3288fe5f7731753d888efcab8642dd873bbc66ecd9ba49f1b4df8a5407cd225db98efb4bf7dd199a45015d41caa0260c8f95eb6cb2385927f6cbcf96799c27b6555a8b62dd5e31bfab8a0f5803157a62167a334631c5105a28db6e7029a4654a82763f32ac2736143863532cc",
         Mac => "4bbcf1bf06f47a720078e2a886d70c8e90ced8da");
      Test_HMAC
        (Key => "a52069d08c729eec3f803df6adcfc53c7eb6456549bf29fa084f5425c98a6fb8a6718070f64dbe7cc551a439827b4440f8bbdea28057b172748e1184e67cba75923d64eb1255",
         Msg => "5967ebc2c80785c87cda84a888f4bab97312ff49e981819ab13b5c2adf546b374b945d8341660b557af008c04b847a271d3729011dcfd6da35e3ce9a3a3dbf0a6783c9940a17d84b7d3b322b58794ca1e542e24ed4d546083062f921926f78ec957c587e89e295b26c012870169ad72eb37a51b676597a2a8c0104464fb33fe6",
         Mac => "2835d14142e4b662578b4c0879c1831bb7245a5c");
      Test_HMAC
        (Key => "5a04585891a5ddc97a7ce83bab92eba55133905c7ff4aa34c5f56be80564d7bc824278603a6a541876cf1c1a9f05a63753039dbeb827789e107aa8ca8e3616e26885cc0f2e8c",
         Msg => "ecc714bd81aac0002a987a81d35d328872a23a2e8f63ec6e03a4937f0060896151c39cb7e399b6d48505be18ec76b97dfad7356d4006e7d7c1889381f87b2ca01dcb3da6a5a9875b0839eb2fc68b8bceaccd2df653bfe085eb67e1d73605bf4ed749be32cdc479bc3b9dcc6d6a85f1a410ece970d3751ea309a84628c2e88a96",
         Mac => "b8ffe657b108b8367502a28c0fa1d595ffa853b6");
      Test_HMAC
        (Key => "d5ed1cdaae3edacf80ee9487eb317df46ba293b07ddbdd350443f150ea28bad30a0e788b4e46087114c26624d72770970b24ed074803cd31ab7db2c17ad3b00d061a5103d6d6",
         Msg => "f753f3e9b4bd1895a259492ba160713f00ac8e24dbbfab0da7070e720b61b2b6f1dbf806debe99847eccdfa584c615d7b1313c68315affa32e98e93ca0d1d6ee623fa7628b743a53fb9c9af0340372816cd7c84ee02ee7bc6a4a9dba561ca75b72086ac464e8e4494053e1d35a1f728559249b9f8d434ca283a892b5d64b0f47",
         Mac => "7056292af9371cf9ad3e1b9c2743cbc1f52b4e16");
      Test_HMAC
        (Key => "9fc05ef49579aaef45c00586c8a35dc0960513483e8951715bb29e77c348af0801fd80020650a47f1bb2da0f1ae7e044deb08c74f8a718baa36abe3efbfb84b669675a2d62a6",
         Msg => "4e7c667a38bee08ac51afde3f22f2e38736a7f7d3f7b32f94e05a79ba19a809184e60217102abd8df3ed6fcd74ee26bbb15ca51e2b4909ae855dac6d89c74a3b6c7962a55395dfff1522f8b2430455d6662b7304870a4965f54b2c0f42c1f0928f9e50cd09e68f07b423603b685b04b2193fb2d75ba53b482438ee29d46eb9bd",
         Mac => "4dcd504d883e2b9d5d1e1ee15c0ff396f4d1c42b");
      Test_HMAC
        (Key => "3e3b577a9cc800d2dc69362837878d4f7ec0fbf3fe3ae08aa63745886cea61d2ec8a627652a46a997bb5d7b157f8c7f4927ddb0f737b3c1c04e7dcce7345ffefb8bff90d7874",
         Msg => "7a000b03fce176de620f0df2d9d3886bee54014da45ea65bc361b13874bd9acc0b3c8ae924e0142ef1e0202cd2ed27c826b9a6e062bacc32602c7679f9555ed8d50c8f7c827c1d7ec42612062c25abb6ecb6c546eaf7926b13ef90fef2cfbc5a817703063f3cf99482e9cdc80f037dfde85246c5659c5fd086b4e60f88b41b18",
         Mac => "49d70fcedd5029673d8027f34a4282968237cfef");
      Test_HMAC
        (Key => "98fdfe9b591008fa03fcc480809410a53a2a4175de480de360a1a95f3f462eab0a1d41ea2390f3fac382e6033e87b2508854865ef87413334d3da5f1ef0393ab778bda7770c2",
         Msg => "9eeb079c552e421f703085b9b275d5b05c0c922efe14f2e78c7faefbb416fb1e6fbdbcf6d7f9f6c438af8447692f0cde5d7031ecf59d0a8018d1d3360620e358e9d6de49ae032c241237aaa0008a9f371adff187966a99f84b70549f0b4e9b6234bdd65d8254cd85274f5f8b1e8e7604bce13ac6888285954ce397ff6caa0c84",
         Mac => "e887df3367b67f8c9e7386d13d1a07a08de9ec68");
      Test_HMAC
        (Key => "74c6bd81ed71bebacf5f7263cad715951c690afe4cd127e41b1e5468b813540833cde26834a60052ed5a8cfb4d68148876bbebd0728a7c64217ddfcd7611aa14e33d0a881256",
         Msg => "3af349f3647218e4be26fa863ac71381b64fccaa7e66761e121e308e2ae00ad9f8a76ae0ad6baf963ee115566861d87af2279d2932bf0d70d2bbc394d4a768a7d43f1c5a8ddf18129f3a923e904fe1e71099e28881869a21b62b1d87fb36aefe562427090db49c81689b3be5b87976f1980c657273a3655847d6060da8752405",
         Mac => "97284bd4e44b2e7a034a2f2795d70250ed5c84da");
      Test_HMAC
        (Key => "cea65320f0ca8dc160c5ff83100e523a16b7651d5e4d9cca9c007b8b850373d83f36fb1d1603e3bd7085e55603f07e47452dfc6f24c4d738f8ff44d4b64d08c766e48aa6d7aa",
         Msg => "13aaeb074c23597bf5557b221300ad3df211aedc75b198feaa8116f8a124d11b7fff2b91ce3c30881715c993b34f334cde04b03f0da67d03824103aa1d00515c75f3ca3e270f1b986e777138f4fae811e8dc462851d9e9b1a267fe748e3cf4761d1030d600a403f52203d9d97f07b3d43920d760e851c54e327b6e209ddea1b3",
         Mac => "0819f3d43c19965373a3fc72c446508c969d154e");
      Test_HMAC
        (Key => "314743435cf8e0a1e1c4a321433bafec55ec262de77aebc5a4f3ad3f3b5e2106bd938ed546508f70e0881592a4feab262313feb904dc9c30ee78fcb6a8a1bff97e803596e7c6",
         Msg => "0136ea476e2e823f8e00bbcc7f9fc7272e951bc4caa67e1d78b060b248d66e4e67dd638b97d62198ddfe003a79e266111bc7981d5448cf814b418f86b1ec34e2f74ace3bbec52ee78f1341f6cc5d9d72e6a15ae5d155231cb54d8c2be7dea6b11744d25dcb41d2b10c0726065e5895d1f6ec0a242813a1781f9b02a9d0f4ee42",
         Mac => "ad4892f36828b64ff5c3fc2dfd780dee39ea30d6");
      Test_HMAC
        (Key => "13fb1ed6389f32d1de3139cb04bcdd53525c9889b85379d3535a25d290351c95938a3d0cdaf38dbf1d5234bf7965c8ddce9ace1b66247e60d74ec7702a0f931a3cdf4cb465ca9fc458c380004a3a6e79",
         Msg => "0c36ca43e7c113ed9fb71670b3ea73bfd6928c839f36db1a82d08ae0ff2c3dae199133a10aa38d1d3588ed115c4a437c137ce4307421ddd615c9863237fd5aa840dd05ff6c08bf66bfbcd9b43e3f95f45e7d3b21bdf2692e10caab495c474b616a646be675b850d0259c01e2c1901130a0dbb9dfe0722a2c5b1b20afd7d2bbe1",
         Mac => "7653dc1ca2b70f058614");
      Test_HMAC
        (Key => "5cf59e34f1ae4ed732a95cee65eb494c1f7e89e1a2727cde68229f1a00b904b519f4fffbdd29238b80886cb818a1be2faf268eda96f2df05fd4b71c0c16435848526031904308fb6a51d9a6b510565bc",
         Msg => "ab5da4a64fbbf3c60f5ab1f7776ed6a55751e39a5ec81967ea88e9061ff9adbd373995451864e42c2c135c786d22f68dbfb7d751837f808d693b4597857c002ea6aa06a5e34b5a44768221ebced656f8df35bf6bbd39204869aaae3dea43c685a0b9df0cd6f9bed496b1e997c1135dae5fd68331337d616092db0d4176d7688b",
         Mac => "8db94baaaf03a51acc87");
      Test_HMAC
        (Key => "909d3891b6a5ef3c812128cc630711861b6e73dce4f289efec5a12520778a511a55145f2027e35fa9cd20d33ea3d0ead4bf0b3c33dc2889fcfd33f01596f013b6a3502810278585f01e50d8be06673dd",
         Msg => "b7b3580daf783c070fa8fd143f5a65a18115ed1a26388c670299cdb71d6d247cab6882b63f2527753bc7b8998be191dd93935c1465f6e2b238ba228d160ea0e5d4c000a247a6d3deb53cb1a38a8e88f64c593314d16d4ffbb0554a2cf53abcb01905fb5931c4ea4a654f11b9a42bf3f496ae9ba2d264794c52b26c1c23b920e4",
         Mac => "670c4e2d2661928b8262");
      Test_HMAC
        (Key => "b51ec038eaf03b3acecf407f43e2f0f4961516850f5e5d87c645c153b9a344341caae284f025c611d701bec6270ded873dfec05c14b623d216c6f49e3131b7842e738c773ec15f02d6935fe6bd60b105",
         Msg => "2ab533078b3314949c1f34c68bfdd76750f75105902c11e8c14ade47905f61bb7fece4f3d33c59aaadf39ed677eaff22813afd9fec974db6c8e0246279f3b29c5fc6ec16b6b48f2bba1462160f10bb6361b544a44846ff656ed68862f3159bf7106bd5d7fb43bf010baa08f01d181212368db17c6ae02fdcfc5493afc66d22b4",
         Mac => "e7007d2f4a194a8b8144");
      Test_HMAC
        (Key => "d4c892aca8c9574a48b761f33f44aa867bf0c61a4929734280b77290fb5795574da61ab5b14137d1402bf662676f43719706435f3efae829f7ccc3ebfd1419a3e66738388e7d0bbb5193edec7d0fbb00",
         Msg => "d1a31b1f3a21b551dfc16baf8bb002f4d8b08b02f5c64331a732b7e78ea42c69aaad3df01e74c60033aa01f59fc0efdf0857fa8fc4f8d8f2e305b29e6fef86abf2aacac4395e527d586073e7ee606963aae4f6b30ef54c5773172d164e7f51dbb18108c21548207356c909affff93728c83ec8965d24670761527076b3bc54a0",
         Mac => "b58e9dfdb9d88df4c71a");
      Test_HMAC
        (Key => "b6294d160b6df30fa4546b63ae64effcbcf74415694984f13ecf21ccd6ca27123f1dc1cfa45bff662925d68717b3695b39b08601864b743eff8bec70dbe265c4e20695a917fc3485997503a6cb5e0d7b",
         Msg => "4c76c4e416be43ac382abf32f44d9632a75c333740d8285ff66d7d5e3b1b48c5eb937e85cae409ae2d561b7df796c196c714bb8e70aa8bacaa7eccf10729c55528193e54303392a979bd065a867c59f439199d1846ca4536e82e7e99d378c3a469cfab5b30f50625842729cf894586d5643380ddab7f7d8519443c5e874e6938",
         Mac => "97eb7dab4c4d89026158");
      Test_HMAC
        (Key => "3b1cbf6f4212f6bfb9bc106dfb5568395643de58bffa2774c31e67f5c1e7017f57caadbb1a56cc5b8a5cf9584552e17e7af9542ba13e9c54695e0dc8f24eddb93d5a3678e10c8a80ff4f27b677d40bef",
         Msg => "34f6d2877d880c45408f53a1d8ff956146ec6b488e579f8e5e48ec8df11d04bd3321d8e22660138484bae7a0a6370d9da49a0781be39a965fa0bd7270f03905e829c2c930fb6e1ae4aa08cae8676ae9df6adb5c312ec7e1b3c1d1703a4c5c9376990560001317fa9da68c9334164814a844cfe77531926966ca6348b780ab831",
         Mac => "d56a5de69805f8a9906c");
      Test_HMAC
        (Key => "09c8f4a892b2efd209af0a8135c15756c528213c86cac5edd9d8c3b965af158309fcc00c1424a874b9e3a8fdbd33e213736f5489eab8ad2665985e600be5f367e0e8a465f4bf2704db00c9325c9fbd21",
         Msg => "cf3fd262068f490c203d8ba57809e693ee284f4a3744536e77c55137114fe71abd8baaa6dc2b1aac0928d5a2f14e0a4964fb318eac24f9ae1d98829eed89cdaa4648715c9a508f9f378607241bbfec05098336a9dc11b7e71ca2516ecff2656491fd8e4de706902fd1de8bf39e63750f0447c6627013755f9b6b246e5e93988f",
         Mac => "583bc1ca3c68ecebd811");
      Test_HMAC
        (Key => "ae69e1f10bcc8ea9e47a1795c916a3132b9d4ba7104970fa0bb551236c43dc26b4bbc5ba4c34d650763886508323cca647cc357dca67354a40aaba0d3b2f07d4201ac080d7fb41cbc7f6348a02216330",
         Msg => "f570273a4e5dbab38410e4af672995eb088408461e0e4730a8d7f15fd4693bc3205935bdbf1b4f8c3e1a1b08670854926673204b2a9a92840e7e7376b93c4233429979dd98df121622e84ab7a278a5c55fd032a1837f107ec27c31183c725ea4a55b7b02a3500d3a779ff926e01f8e6c3cc0c6b0f166c9070bf8b3ae27b397fc",
         Mac => "d4225a4949faca02f3ef");
      Test_HMAC
        (Key => "7f0568cca4ff79dcf1e5a306b419d25d47dd4cdd42bb86f3ef243c40fe57c09a7a849353fc3132be1fde32f033e48fc436a3422200dc1180bd5caba8a0dbf4bcd6239e78b975f9b847280c3ad293e4a4",
         Msg => "2512718e7c139acdcd324303db3adb70348d09b058baf0e91d52b24952f832b0a3b81fa9bc9a2e9fb276a64e9e0922778b4992d892f6845b4372a28e47d27b53443586d9015463cacb5b65c617f84e1168b15988737a7eda8187f1f4165fecbdd032ae04916cc4b6e18a87558d2ce6a5946c65a9446f66cda139a76506c60d56",
         Mac => "85a83e94fd8b941124e7");
      Test_HMAC
        (Key => "0daf68d47caecbcb7373b693bbfa4b98a39d88ad3e7e1b99cb2478d2756928883d9364e534c1e294ed89ef8032dfbedef638006d8bf0b4fc15e9412e3f76c27a2c77a175b1c56754c1d0d2ac2886297d",
         Msg => "b3fa42c51aabb708a64e4056402fc97bd8964820c09c4541523c99e2d9ad76feafefa7c1a2a519f79c229bc384c6e2945f8bd055bbdbf6e44da557c6d9af6e19522e73c94394db076da91ef7b1ddbca931dc824bb364099d465381a52705aca3e5dc2d47c42003225f0a515b921b60a397b2e66a6fde895384719fe68c563886",
         Mac => "9d835f06dd733eeca888");
      Test_HMAC
        (Key => "01663b65d9d258268b1f8c770f713cbc857c1870d399e7ce901887d121d82f5f2116f8c107839c5702997d8a282ee901d04a9c183c36868e7cd5cf7d8e371990ca6c05707e96f87fd5421fc9fdf9b038",
         Msg => "64971ce186ec2dbe037ca714f212f62fc863d080799e72dbe0442de3613a22c2cd1d4a1d85d5b946e36d23b4d5219fb1cbb9ab53d41670ad030b4846186e7ecb5c6e5500cd264bfc7b739e963203101b59afe7421a0b3961c43b66e06d08e6eedb334574a5086b47953721a251e0d1d33aed8d3495a4535de97c9098a730e296",
         Mac => "be05ae222904afc2c266");
      Test_HMAC
        (Key => "ab6832846f39aa9be6dedcdce2f0d5ad7d331129b8b340d16212497e3c20909b5aac7590cc9a1d817e3674395dc87261bb699ef6f514d1fa53003d692f2dad6e5a3d0ed7bb862fc73965c5aadcd5b26e",
         Msg => "33d8e9e9c066e53f1b7d689f82f33fb1ccd9872aa7ad15a125d1159f773cf0f5f87074526dac2f148a621b5fb9eb816c187a1724c04f6bee4d2d85c59b0dc88dcd141aa794c345c3ae6e9cf5acefe10cf99b661f187573682da2e855bf1d23ddbcac2411bd13eff38c87328ae46528367724bd423589f3b8cc1984796bd4c98c",
         Mac => "a5095b5f7a26ab55a37d");
      Test_HMAC
        (Key => "d14474fe023c284a27f7be751ced9ae210a4fe5ee681889bdbdefce06a5d44fe6d7bb58684689439ba16d9c0668f329e508d4b6215444d21cd83a523eafb06dd63deb11f13adf48f5c4bf0560f55a019",
         Msg => "6af0473b68f389d5b6f20efc60dddc2f3551e62170b0d5699877077ba4ccd8d7635721801b53ffb071e5d6ca88ac95906d993b96b3019af65af05a46f6c142c70cebb3dfc01e75caad8fb78c1590502a3a634b190b50a3f703f54b794fde71a52f5504419e7b748b3598b92a4db0966564571f93c2c579d25b2de1fcf84befd7",
         Mac => "51d76d949452cbf42262");
      Test_HMAC
        (Key => "1f9284000341a262e7b61f949523b7744277e99013d5a03be04413e137a8ea97a4f1a2f62f92322a2734ef461eacadda352b27c89ab5a1534ed5cb792c8ee983279431dad3bd741c27b2016f81eac716",
         Msg => "8e7aae5ed6832b58cf200019101822d0d54c4278fea6f5685b4c112626195a7dd14d5ecf03839dacdde4eda2819b1d57d588d9d68439cd2746160e2262dbb584714ccd4364246f1fc84e2b7a4957aa697524920bc3e0aa1ad4393fbff8ccc6abf4ddc263034ce8db1ac481477036112e3e8636c0c384d2698c1d6ca6f2d3d418",
         Mac => "7832413077e6bc1ee994");
      Test_HMAC
        (Key => "24d8938c1644cbb080c4505539e44c8a61567ca74443363b80dfaa466b4068a9af7022da37c1b3dc4f60616f062d5f84d7ca96f389f2a670540d27bc45013418e44a2aff134dad1439e9ec5aa05026a3",
         Msg => "c0b184c7b9e4cb8dd19af377306516c563b3b878baa250c1ee1605b90708b5527d213b8e9e87f2ef2ff7752e5614a930b8fefe35de27f153dd62d623363dd4bafb9131da3357cf6a80bdf724ff7a568e705e452b972d4ef2e1adebff4bfe9089802aec1441fd6de70a1702c1f33f24c8d4fa17c2ac5c6d87441fcdb60ff2f2a8",
         Mac => "1d1d12f4ff4e0debb715b9cb");
      Test_HMAC
        (Key => "4bdc4b8862956899373d3df4da7281c0ea2bdd57634059efb82d157a221339cb37ff2ef9be6f0f08c2125ac6e5d0ecf4f70a2ca6c72386ed393f1bb2994ab6e52f3d02d8149cfbe54443a357f363f688",
         Msg => "28aab2e4a0e55c11d5503c4dcab584545c4923a61b313c2c5a44d61d8213d523ac2629ba6e8945d9f488d2d553b6a5821b34ef9b2b2fb464caab7f8df37f535aefa1e4012aa407543f7f689f55907bd4aee1b5e57da9fb72f8165ba4af49fa591ca34d817b3f8cc7dcbf6475764ced913ed8db4cb8a6f89e0d0dd22a5f79b067",
         Mac => "b3ebb567bef1fea5d4f954bb");
      Test_HMAC
        (Key => "732957d1867047f2904817b4f559649059870d38b2bce77ea2e8b27205464ccbc6e02589f655f3d81fdaa736d57f9fd88fb41d4ab50bf857fa3f9128ec7609b0c9c3b14795efc29469794fb10edb778a",
         Msg => "fbdbc0f366d4678654544804b8d6fd6f171668f2832e4623cdff0785f7d2de51e83f1476634fa1de3addfdf3bf4234627c31391e24df7ca9c967be8f4e6e243320028bcd21c81cb4e55720d921df1594600e01a4f83406713da53793f45faa980becce02878aff90bd8a58bfc5f6c98f2c76698ae9740d03927f199cd0ed960b",
         Mac => "243785864b714d4132b916a3");
      Test_HMAC
        (Key => "0541279805ec5e82ddea16897848b0dd584fe59f2dc1ff44a65f493b87aec4cffcfb1b4e2c9dd96b127adae188cdff59a526268e49b25aaff6bc4605e274f0d54aefa48808702d0968e64c6f38b562dc",
         Msg => "39b971d28692e9a0b5781c9d4090e839a7ea7021b5b4791004ad14e8c3dd7e01b78444c18050aa6d1ed24e3eb33309b88a231637591376cbc3a49245215f239282a64f48f0ea147ff61feae25f6da4063f2998fa3803ff1ff6819f39fcaca7c7a309da905fcaef7f454638b0caa783cbcee23e91d9eddeb4a42c81ecdb2cd147",
         Mac => "3528e08689fac23da65b7024");
      Test_HMAC
        (Key => "68ed9fb90aa9c95ff1add2476ed9a8f9f894a3bfc514b70797daef0ad97b16abeaa6b7a2b96349d99299a31637d3b6db33437a8b6b0829cdf6acac352ef1522207cdc8e2a0b3461d18140670a326fa58",
         Msg => "224e8d76f92822915a2fd36a510c398460090421d118ec654b17ebb9a452a96ef64a38a2f5b501687fc5fe2375ad2a33ca6236d4d99e7e42fc2b3b225a5efa1d00e24dce34b6c0de05790e6d27e695b4fe9b08e9f91e6463212125fff205b9c2699e35c05e36473c14d46b100fbe6250253ce12ad89f8610e3820f1a1350cea5",
         Mac => "3f172df211dc9da262936060");
      Test_HMAC
        (Key => "772326bc0d10921a489a82e3651daf798b2e2a39f72fa1ad5620de0272b890bc11b54ea81a70d912fab4a13946d08b00a2ebf2e6e198ec386eabce86ea4af2531647b710f4adca4c2998a425a64a5402",
         Msg => "f5c05a093ad994096deba25858e5c50168cff2f361b0280651b00039c37a863d34e44738cbd2abc3445785342e1ee92356093e27831793e1638b373cc64b83f20a86fb53d69996420c345980f8b82a2dcee4e48b53b1a706da7a72717260f3935eed9de2c5f8fc8eabc845c1207c3226b7a90ca83a46097c9cc5d9612f837c26",
         Mac => "46a5b300d160deae52b0dc0a");
      Test_HMAC
        (Key => "ab7b932494ccb9a4792cafbf75988ff49535f837903761f5b201ad521a8dffb5250fcf862ad53e366872a6803c1b76ef98513da1b0c1044af668e17b49fac9256985a659af51a951fb0ce2b4ed230e16",
         Msg => "231b4a2a2e6a517a55f10aa8047cdf05941091df707f7eb077392096a265d703e730e8b65d65c5eaa03f8fcd777bd933b4b0af8c5ce3d613085656498ba236a2d505877e18fda45a2916b74828007f9c63e451e978f85d2cba523346d6fa86b0b7422f6aa65a7434b61f8b015f345aa9695481de0be69a6155d2bf75cb944d95",
         Mac => "d012486da17a6c96d6ec6a85");
      Test_HMAC
        (Key => "1f8509c8553d0d77593d261fc9fcff90bf77b24c4bd3de472144faeb8e2de85fb189cd09e7892152877e02a9d0faceca1f32f04065a7fa28d906f539ea4cf401782df07143b7cf9ca433c6bc7b4ce176",
         Msg => "ee59b47d837ce466a5c6361ac4f64365ce5007de53372d17e8fe8d16c9fcf409c2de23354f411a300281965025cbd863a17aa8a01ea09ade6ce29004218a80c184d7777daa97de8fdff8fdb0489cbdafc6ebb2671cad58ef55d89d1060a6a0fcfeebb93cdea6b9eb05d67322748f7bb3054c2d1a9787f1b06a87be22cc7add22",
         Mac => "f5eddca9a528054bc587c7a0");
      Test_HMAC
        (Key => "24b2d6332eba8fd719b4b37463b456e44b9140d9909adc287c85516821a8eebce36ccbed36feadbca9472b76241f0fc86dbdffd5f1725d86c2986b21dcc5b31eac44a636d3c583bc27537a30fa871212",
         Msg => "1dc026b6adffd69b6005aba5e5d179ec42620f8c75cc04565b8ab4c6d21685351ab76f50829abbc940250a4da0889ab56195c5805bd1ca8166cbd0d578ac28180d10d3d8cc14444a67b0663cc348e14b597d9a56dc4978331b4b6ea02a5fb67cbc725a37d495f9879d4fc85c9538d717f1c396f63e5c97d344b3950f2f57b6c9",
         Mac => "109f370cfa011ede8627fe4a");
      Test_HMAC
        (Key => "b712f94e606e293683b2968806ff6a1485504a3eebb8895c3feb9b60c100cdb7367534718074e3a171546107e1635becfee3954ee452263d6eefe5854b791f8d543a8b7f1c447fa9c9fb632423d367b3",
         Msg => "8a7fdf734fe3e03017ce96e9a154d7e6a2a52578ba333b3aa713e697b9a6168c857835afde68b771010af3a010493130c251043a58acda45d3aad1c56407cce124c8c77905666768082ed506b1e8cdf1b9b7f20e024065cad00e95a6353559f2cd363cd8ac23179d9504e6246c78d4b4eea098faa03804520507db42147ae447",
         Mac => "3072ddb57d76181c164e08b8");
      Test_HMAC
        (Key => "e199ddb8612936d2e46b4e301a1e772b0312d5a903e713f9381754fe0b376d900579511fe576cc99ef2a758e8640de93fd900de4abe7304d3d068c4a50edb76d405907003a8b4aec994bb7d96f2d2597",
         Msg => "0e0e09152ca3b8f9e77d4f0781a0500ba7d8e5d202fd188e0976467b19fcd1c3c7a016a075109fc0231699ed886188ed618839a70a4cf8884b1e042574e14022acf02b528663121fd58e852dc2cb073a1b7a0949ee451aff57a9584d96b12a4f6405317488247be0a5eefa0e566535ba7cb43efed771e4bbd41f293aa6f7f713",
         Mac => "5b3a0278b3e71a3a93951b84");
      Test_HMAC
        (Key => "483d3190b2bfaf492e9688e61db2b9ff0b7dd864d76b555314d201eeb0fdccebd37cd38e0abd9ad4a5e195f25ec8eefd3b6e82ebb57b2dba191547ef2ff96e421aca86987fa8ff31e90556236cb4df07",
         Msg => "35a2b369b9e1d7999354b2a6d3a2e301355f3d833ed2775588fc250d5bd5e7197cd9e1614ac36b280699093373e89d2e9f51db4b0044fe2cc20cb903600c71f87248a9cbc627bebab177d4a5a7b110700a7e08a9407b776a083936810e8967cfbdf6f3ee549238173cf6fb429984a48e1fefaae426fe4cd7018c82cf8cd43367",
         Mac => "994e9838eaa0bb1d6515c12a");
      Test_HMAC
        (Key => "2aa3cc87deb165b2c4114d1e5038b882732338786de33223e3588f16313db3710164b34d1d43c25b81b0edc7b5e9096359d7e9010194d420442a35cc109e95bf402dc7cc71d5627e111775fcb8fc752f",
         Msg => "189aed1c0cf7700829333e5751bfd718a4450879e8836a3a2e5a2d61b222132e0441bf5165fc305b748d89730a75134a621384517d768229c470635af0eb374927800864674660a028e80c253dfb2047fc8e3bb99e020cfde91c151f0c58afa3ca804fbcda7e07bf8e6f50d6b4f806f9baddb41a15cf12a0e286cc17ce108526",
         Mac => "5a745e9ceda09b0332cb4cfe");
      Test_HMAC
        (Key => "4de1ed235e4247d73df86fc57e56360f0ca78c6c137d8e1d1d46c0237b2096afe6ef3ada66ac899673005ee45a111448e39c467a3144d95fe9293d3797bdef184dd3439b8df960d568088c89e8f9aa9b",
         Msg => "f08dac1d4d6a7ac4672b447a46cbeb3162f247ea09c6b4290004cda66d4f7746f4c8224921de4bc50668455325f13a0890526da74e87c11401bb7f0cc6a554145d1799af8ad4d7d4baa38b9feaa12647c5db58500c1c8e023b04ba196a5a52be71a39bb64ff427dacd049cc75e85b8d64ab5924f0b3023d9f70804352017792c",
         Mac => "7f25062caa0a514034f793a6");
      Test_HMAC
        (Key => "e48825a5503a6afe0bf9a240c67f27acd4a8f6993834645e03c80c72dd370cd2e10071a3ae18ef19bae9d697ea9a4118609190cd95361907a7fa1b58f499f3f5e79b935f12212f437dde399e3e649024",
         Msg => "8c84810e4c90bf6e1e88c8b944398b35c422d48c6a7070680c2d913f11b474713468409086a532feb2f7f7be858a5984aee21e0ec2cc2db78395f34a61790514415e073d7ec3cc582df3be38a67e810540e9d3905ba5b7e4a43ed21e94d5157e3ad09cbd3bd0d6a117e3e7d0adfc4ae202a0bbb93ee15415f790f663b2afead6",
         Mac => "cf0b256cb91aeb1bf3877d4c");
      Test_HMAC
        (Key => "b5438e3845f39afe7deb0fcfb86e2dbe4fbc489f55f01c0f842961b576e89fc719b944cf5d16f4af2f8820e2ab0fda068dc4e797e9bd16fe1d31d1ca03dcf23d6ba5d80ac87fb95d298d391c6b893c6c",
         Msg => "8ecdcd8176d8a164f6259733bc77ef783b48d40cffc547353d195912afee9d399e31dd9e41160cb7455d7cddadd351f6dc1b3651f0ae4ed152216d4e8ba789385ad66b7d03aeaaade9d7da5d5f2a01c9bc734abdad75feb5d02faf437e5eb7b1e843e1e765a665900a1b1a797c84e73902d77a17de223d28decc86b82e1d0feb",
         Mac => "a95cf7bb2f67983469d4fc489e3192d3");
      Test_HMAC
        (Key => "95f2c1509dff6d162edd5de32ded423866dfda682bc7b7503e734142f2fcfe428c9c1175efbf01d6795dbc2b2886dc38013f2832b28c5e7676ce307b394f8c05fd1c209c7c131e3d0e3c3c4fce5d00d8",
         Msg => "1c4396f7b7f9228e832a13692002ba2aff439dcb7fddbfd456c022d133ee8903a2d482562fdaa493ce3916d77a0c51441dab26f6b0340238a36a71f87fc3e179cabca9482b704971ce69f3f20ab64b70413d6c2908532b2a888a9fc224cae1365da410b6f2e298904b63b4a41726321835a4774dd063c211cfc8b5166c2d11a2",
         Mac => "0a060735b4799eeb204c5203e617a776");
      Test_HMAC
        (Key => "9da0c114682f82c1d1e9b54430580b9c569489ca16b92ee10498d55d7cad5db5e652063439311e04beffde8c17688ffc7f45f0255315dc8fd2ab28c52124cbf4911c41b4252231264f684d3ffbbf7963",
         Msg => "7c287ca52d40f53f92b00432984595cd20e644494ac7c3a4f3e07cad7c9e785bcdd880629a048208e5ab3635c51a00ca655b19344f63ea41eb8db83242478611080b3745da92f463c444cd4706f2a36418c74558eb7cd9c372cc7e5a61282f3735abea73745012f73663138fe4354441401411dca57a59d39085154c60a73b75",
         Mac => "d2f6e9f1ea2cbb0519df68fde357979c");
      Test_HMAC
        (Key => "acc3e67746033c73958992fd94f457d6d12c29367050f66372f06181387d67ac42fd42443d038d883ddfaa67471261921205c9d60efa6ca9a642a603c2b04e6f914f986185503aca9f46ceeaec967865",
         Msg => "dd3e68b757ffe06068e52005889bfbc1b43bf0a11164f35cd38d713e5d998e66a9abb131eb3b42f6716ab2f4ce92bc883722eba42da95d7c5d30c682c4cdb795167521756112157bedd5cd8768cef0393fba12644f1c7abfbd8f29de225a1861ec45c06c01abdf57a5d17aa69d761e3b94ab6ccabfe5d58ebd51a13ac1673633",
         Mac => "104ac1da3bc023eb3a94c45f7c42be51");
      Test_HMAC
        (Key => "545514c74c932e3ed856e93d878ad42cedf8e04434bd09a1d4fa38989ece684aff8108798302a19b9894b92d95c4f74afa9e887cf920c0d236ef0533cc49e9f1903b96a199146f2b0019f41de47ae645",
         Msg => "0a20bb48b5a3e4f47b2fe7312c223cec1271936281eb0a88afc2a2aac647f45238f5206b53b107a61550ba1d415a3137b20d41cbf0a5c88801db2b9482ac0273f65b112b5db97ba509a43257adceb220b7c0ef73df1e8bb8002c4def2791cf97ea5b76cefc44a7b9fe33382697062570c68f85a377dcbce155bcf105e07ec385",
         Mac => "f72b19e31efa84db9775dcdab258b91a");
      Test_HMAC
        (Key => "e79461f00c4c05e2e01808de1926f41aa8f45ea5ebb5baf124f674902a813c3b5e81a118e1e8e13d040eff70009a1730e8a6effadb1ecec57e6991cfa94cfb9b610b4d3a07d116cbce514d3e73ae9d5d",
         Msg => "166cdbea93469428e66efe853b6c4df9fb13db05f4126deab4c5b81a355124ecc0efcf930b88d551a583cfe893db99523c7459b182afbc89323c832d9e2f3f77885658bc42ca54ff14c55665deb3e5e9fe8cef5174600e614434094e1c0c9e7637497f4d81359a9bfcdd9de5621fba280c03a8ce124feadab4555366f910ca4f",
         Mac => "04d599b40b7623ca25c8ea694aec3afd");
      Test_HMAC
        (Key => "48eff7d489f9b25c0c65cb3a37d4efba3a84f79be7cf62b5c3f403e05d1af712de92dac7e25d3aa686ee4c61c230deddfacb8d93cfa438363ba2b595ddb8c2c491203e7644e499ae07a389976192feaf",
         Msg => "c2412a6d1d52d12c0a54b8f5701ea58adaa11a767ad57a9e6ff46c1943e78441b8fd210ac4e39193dad17cfb6b017f76ad6517a09b99c1113d175f3129aade4d4a2516ebe054f15bc833d08ffe5e2a2d60c976e1b4b14cf8edd2c72baadb2db8001fd2b8798d39ac5ce27d592f1defd67b3301e3cf05637c078f6baece62baaa",
         Mac => "7bf44b98d95c3a57d83f8e8bf82a1cb3");
      Test_HMAC
        (Key => "6ad25e9dabd163d092e124fa0ad1867fbb3e020389074a7c5e01308c2aecc40f28a6bdf0629f1b40778d0a899c61085fe1794a39b6175c7fad1209e481cb7af65863a2f3452bd9df115cc6d33b098398",
         Msg => "77517dbfda50493a04445d72430ea3f6fd54bb31fc81f2920a0d72eabefeb61595af41dc44d0901a4dae4d1ed1b4c551a5329c18a85ebffc53999b0991f38d73d1f099805a8d5ea1df7e49e254ba0a85003944ead2fc89b3f84f8525ae4b79d0549eec72c48f9d19e23cbb88752658dc35f01c6f246436fd22b79805bc0e6472",
         Mac => "69211fd5573b030e379f7661ae6e6d57");
      Test_HMAC
        (Key => "58812ce4018d2cb65571271492fef87c06d703d4d52819b8f7959c138071e3ec2431df83fa20ff9d8054521ce0e0ecd2714b8a97814179995289b3f462374c83ef230cf5bb995e230d5268a0f8a37c92",
         Msg => "e88b88545af54f3559594239f0e4f0854770d576d3f02c2aca0f0543da1497e71a09d70b411c4af2164517f027296074be3fd24611317b0cb985dc13657c404cd03a4c95f028d63a7197fbbc61a66bd12d6508abcc3ab07d3a84563c287f58a3f2680c79d1e19c16529615240621baa37b2b9e2f6cd4728635559b4589e488f2",
         Mac => "85c9afe1502539c3140777de9b5afe35");
      Test_HMAC
        (Key => "20c0db0aab2f9be21d2bf0421a16c6390a0bdd57c9c11cb4a0b22933757c36083e871e78bce8b0e065854af9a27aab5a3abc023f0efc4a8808cfda054e0b38f0bb742fbb8f98210d65f79e07666734cb",
         Msg => "02140f7b50f2600961ced8b36dd48b8e3f70c2108c55ef2d83c4e6c0a50b492dd74c4444b57f7b692aba41f23db00bd12e792473c291a2e8db2298434b868d44ea072d34e7ea3f115badd7eb248ccd8ef04a6d61982d708eb04b2c635c0407f964d031138b3b93481d2d0265c86fb90dac6b06a2b533436929c508e87d8e9f93",
         Mac => "66aacb93fac3b3ab7f9a61ea907f863b");
      Test_HMAC
        (Key => "282d222b848ce96372409931abe8e1db709914b2d6dd213d62fbc593d579ff0949e0c50d7dbff5526ef28e2e27242040d99381552e13c28cdb5661b9756ac0088583d6e3defb25152e97ec2fd40c9d2a",
         Msg => "7b7ba2a854840b24fd75ae12ebc2c6144bb2065c95abd31164b0b0f58528fa464ee1d5e2315466ae912b4337d300279ab968eba2eb30b131d7e663e1bb9b5cea00e86447ca2fe214cd234d3b628be44fda439fb81283651147637fce2c9f4d223a983720489ce7205b67b564bfea63fb574b0be6312c557a5d30ed0500bb35b4",
         Mac => "5e671f68bee18089e4fb7fb8ce85e66d");
      Test_HMAC
        (Key => "82a19090190ef59e77a26cde0e1799ec5b0a796bc64e5af8ca862b5d55f3f607728aabbb254a1f8496cc54f0721cfb7b8fc7374ccf35a41f463998839fe7a945bba66f2c9c868be682d3e74353ea40a1",
         Msg => "c1e969ae81507ce3dd94ef0a21da24935129daceca79f3a4270d7a856203e4a13b2a965bde13a8fac06be9a2ca872384b941a051c503ecf48021dd80026cd167430437eec86d51dd82e5377bf3f520b99247ddae71b7a6431dac1930c5a980279f1f534e8886fef3ebabe37ce34ca39ca4e299cd17bea8fac457377bf5e37947",
         Mac => "b1fbf176cb48f5a90db4af7a555a0c65");
      Test_HMAC
        (Key => "76280c24849f0c384d6e5b512a9fb1dd2131da0307b2ffdce71027e0a8acfd9ee9b0d4b130a3e8ef443ae7e3d771b07e68db5a096836785e9c439b58c2d5198877270d2958729f5668bf867bb2facb0a",
         Msg => "09caedbd5568cc3ad0590b7d409fbc26547a2a20d9d0b22630d2d58500dd8b23289ed9c0f87aa57ca02dca99e8b1688322617d0d5d5ebafedc328fccc7b389a71f2addb9f7b545ade2ea0a6ea8bd62313da4fdb5f3f9dbc9ee9f6010d8e8aa01d7b62231bce151d57ed9f682e68d55388b8bd19f0168bd904e6270d79d449738",
         Mac => "d65dfc5a7d8477da3f29a4ea7809f265");
      Test_HMAC
        (Key => "72ce9cfd27b714419bde4dcd9b377dc840bdc3adaf5a734c0307af128834378b2a6a81252d2f0d371e2af3410987be76ec9d7c776cce1662c7afde0b0a696789846099f57a12046e1c417560b854c706",
         Msg => "08df48713db1b8ab2b51e05cde25dc3dfbce1b12045bc181d8bc492479796fdd12a44d6a390cc43971b31d7df382f081ae3c453c8cb1fa27f734654b9c4e399e6eb4ae8fee77dce0aa7b68b4042a63e935696fa792cb24390d05b21cfea3c75624f9b309e65bca48df9109299a85fd1c9a3fe17b9e130762231979c029dedfae",
         Mac => "cb314cbfe1f935b03adb10e5a8b88c96");
      Test_HMAC
        (Key => "34991e9f5b19fc2b847a87be72ff49c99ecf19d837ee3e23686cd760d9dd7adc78091bca79e42fdb9bc0120faec1a6ca52913e2a0156ba9850e1f39d712859f7fdf7daedf0e206dff67e7121e5d1590a",
         Msg => "a204be1fc04372eed3c9e5ccd1435a02b357317e78960b6e6cac2f0eaada2dbee0a7c15852d2f9c0228a9abdcee1c107fa7fc6a170936568651020edfe15df8012acda8d32b8b82ce629f8f33a72910e793dd592395d9b0f97049d65c4361fd8c17dd26666dff757a90dc7171ddd1341b9fa28fcdbdaf58a8cf1701e062535ee",
         Mac => "548cba2de5c3944be4d48ec1a2a34d9e");
      Test_HMAC
        (Key => "4ddd00d0ab6aab2100ce9754c3b3987c06f7e58656011d26e3518711e15b9e6d2d96cd8534d077c211c43ad7f5ee753bcc9e07dc1d4c5a12322ba1d17a005d242b3526d62b29a87231cbec6f2867d9a4",
         Msg => "28be0d9e62dc89e2a913064c0d3dbfb35a0c7766f756741b0eafcc28ed3ddff6adc825b211112a45b065d6875771f2afa958e80f0803cafeb9b9961542efb99e1761d1497661b721906fbdbfe90b34bd01c7326e34a092ccdf8e3bb2c45aa64cb0b09acb5b753a5d8f5a425c8cb28ec5ac81dced43d5d26fc95943693b27aee8",
         Mac => "393238d3afdb7d970b966d374fe097ec8797a870");
      Test_HMAC
        (Key => "7a31553b05e96a8da0a4d5b81a857d192afb6aabb1f127d740456a8eda7cf696fbb4c121d8d952a4e91c6ee6a5a1f3588d7804a46bcf6688dc662ae50c438d13c1a61c789b3f1c599a9f28efe0ed1cbe",
         Msg => "fb091ddd95b100dfcf892d78e5e770d3a37b8c3885df803c1d6f0935b55b68f136fb65a84862942ebb35d76d26be2413cd3c8988c87d6d2362af189dc07476c6c33417762eb77bc70cf38d814c226dd6af187250e4d47007f1553617d4af5b516a5d3b3191d93c10896a569ba13dd2840fb851781f0b115090086c8b3a34a1fc",
         Mac => "0fdd3f836dd7e5c506ab21adde9ae5dc09cb359d");
      Test_HMAC
        (Key => "6445f6d884fbd57a1eec0716f893aa9f4728aaa07d2038da62f3782e66217abe35776c508d8e0ef34c9666e4ce51b4b27562a8a189c8d34c43a65c8f2445f4a48b5b0b8c878e44b1ea3427c99f5d17fd",
         Msg => "9f63b0edfaf83bafce6c4e680bc075c7b3baf15733e5aea7f3d975a82cbc6356fa099a9ab290366f75bf8345051f6da2d821370f6b1b7032d98e2338acaa4f76f314964f95e63958e4f844ba755e06d83031c432a393af899bed1245f67bd013b30b0ed24b012db0449ffb9003832ab0e2710188825351f5637eab96b137d076",
         Mac => "090cedb3f2833a3f260b0937baae56267a6cd935");
      Test_HMAC
        (Key => "2967fa4c626d18a77aee781aa5200c227ffe703ca0901e4a706ce1393c7d8ce18a03eb2caadbfa7b8e015545dc53f0014097084707c05932ea6d920827b3061dd71ca4f47bef29a8d8b2948a05eeda0c",
         Msg => "b02dcae915a6a6be9d3c9bf3fc61a99ec3f181b4e3b0321f6cf304119b9da497144d82716cd67821eaf0ac428f2db71b532e0774b21681a8673f6bfc782c8a2f72bf8753f6ac98db742e5cf437f90619a26fbde1b916431ce34ad51fed2f535c53eaa136bb114d13c35f72b2fcaddcbf361d6ca4ff99bea3667c0a21058e4845",
         Mac => "ccbecd82cf4b29b535a9d57137b853076de78ddd");
      Test_HMAC
        (Key => "58fcc3895930c2fcf0d7c934a4ec3625633509e3c776466f98e49bd091dc436667d52a7c0794521c1f9f7527e1f3eca504f9cf590bb75e98c9439f5c257e49951bfee1bf034c23b91650a3d52e09b42c",
         Msg => "ee880b8150bc9b86607012a9a3e737e2407598d659897ffc9beb22fe14411a6245d8166979a1d137557a4135afaf12b4a4c152d3e4666ea251d05d87c9321be13f8159ec117873e595dea26ef50b73333ea977ceb3b83ce867d47da10bbb9632040a3ad1c14768d64b249b1b1d0242a837b56f906e87d316067fea1482e3739e",
         Mac => "d8013127f8491c97f1d5d275cabeb1ba3b71a2a4");
      Test_HMAC
        (Key => "f6fb322a18bac34c75998040511cf04877344e7d2b6324135f201cde2a7d121575076d57f8eeb0eb65664c4ce24cb9e5bd0dc4195bc42b8672a2678b7893c9075c1ec864738d9ad5b54f01db299a680e",
         Msg => "c280f5b782a0ba40a15699d680129b7207aa89c8ea94511c2b59aa57e146fb5a37657992b7ac90ccc973854b762c5918724ef09a5a9273663a62f258528e4ee31a4256a58335303f8022fb63c57cb22fce5e53b924c141ebdcf1e79160429fb072fed2196da3603fce4b4246f46c6e5c24c1fa4cd088855019eed32792c8b768",
         Mac => "75cb23746c04f583b8ac78998537d98022ef2440");
      Test_HMAC
        (Key => "e03e23e502700421f0018449c0fc9164ea488c1d00849fc69936519e8f25574f6a03adbb1b4fe6f8ee7ac199ba49fc305a7a6d1161aa4e580a76d92d6ee11546faf5efae1fae8cc54b13de8919a67513",
         Msg => "b949df3b02871bea0976873a9c76942ac934ce63ac2956d2856492970d8a231e0b1b178b22f6605ced2085494ec1986f026f68ae79aff750e5b92feb927cd08875e2ad04075518b754829b544e5de910686513076029ffdb5c0b179e39443ef22028086e5aab2a4465252f2147526d55229d3834099e55bc12e1b178ace953a3",
         Mac => "d78807f2a69d8e348cbd2c2d745f342397e20a41");
      Test_HMAC
        (Key => "9e8c665ba53854f0fd27ec45eccfd03d58d1360a3a94f5f24f2ddf52118352e3e5b00a3c96aa39980222dada13ac42cef121f8b27641c6f5e39d103ed1b565b06a5d546dd8658158fe78f8206645c07a",
         Msg => "d1d94bc59465657e9cf4020239e6164e00c707f8c4764d70c2873b871ce51c2d89bc827f4a96db0160c44527fcffa41b374ff1ba032cd5df61e376e5d53c9167175ac94a0ce23efef4606200e5e608a478f6be11c2a15d8d86f1defba8856fa1e57bc62fc293b6fdc2900095dce26b712c831706e91f0e0197771cd07e07e164",
         Mac => "9602a3a1fd2dc3c55df5815ac0517001f8c6593b");
      Test_HMAC
        (Key => "05b0363fc500dccbe78ca18ac7d3521d539dee9e10e9c4325e27d5ddfca77f9bce525dacde98692fa2a963f27de87789879c1a9d91e935876400851d4a9241ccd08afee8c9fbd13f9657b3f4a5e3298b",
         Msg => "a60c0e1ca329b27be58968171049a625d76154731e341b9e6066df854fee8afdbb6c0cc7b5bca0bff4cb505578a9bb416ce0167351057149598c3b0511e0097e43b493161b93ffeb88bf6352e5388581d91be58b7c2dfd92bbb8c737fd968056078bacf11cd85a69690ca9f4a11e8b4be5b9c9a3e6d747df4d918a045b3577ed",
         Mac => "b95df20e4e63936b74af4ceb7ad94d4e4b56ea8d");
      Test_HMAC
        (Key => "5efb39ea8bbf4bdc7bd985dabab07db427bca4a85550c8d832b7ddfbe683fc52fe22acddcab261d003164241b14a2f234cf30377223b16c1f8db07b9f479b844bb3599a2d67f2ae95a2bbbb2c8c77612",
         Msg => "4996ec69eb2522599ccb47ed1dd6bb0f79b585be8b68f419c03585b91f9d0844868eff3f36da472491e8fab523aa938fe0ce5302ac39e42021b13d148cd9c5b63863bb5cf081d5f2bf9c274dfa4947bc8079afe041ef62befdf8d3134e5602e7e97de865210215eaad50985caa9d1fbde41c5f005174b61bde720f5d6efa0702",
         Mac => "5f009c918e2f8d7c9f9087b78af44f54518e1c5a");
      Test_HMAC
        (Key => "3724e4bed1e72985fd1f879394543ac9448cfb8b3363c771e55ee13f607d1a188e0f50eee2ca353d3e1b51f915bb4bc5cd83646567814476614bf95cdb933d7dfafcf7ad8a2c05e8e72339471dcba12d",
         Msg => "01069a2a048aac5791e0e922efcd5292d7af1e19c0b3156d60483a936fd4ac3caea5ce55282aa6dab76383ebcb96e321674493226c5b18731aad4e8ed4a14f3523289605fef3654e49e463229bc28aac443040c38fe0c4bf4404cc8c71056dfd6a783a620f4eb05c4d4ad2f0e8b910db775d6d25b0aae1f9e535fcb4cf69cd3c",
         Mac => "f92f9c4b8d423b14ac7ad924f183a1cc27de6afd");
      Test_HMAC
        (Key => "4718ad423439cc9d3b1f691718e34a30df9b3c4dee7ea9011f496d8a42e1e69fca394a69c6763ecf1351a4f6d0bdb40813ca4e35daca8ef845b2a29c02c3d8fe0869fb948863e0ae20243cfc5379b851",
         Msg => "6ef99052e93de72a0928886350c3a86b3e1b75c81beffc65f0ad4a29d79dd1ce745b0ef1c48a696515c75dcd56dcd86a9136e531b69a88219a13e9d33f2fb553566ac22e02ebf2ccdf6e59004382a2dec4f4aecdfa8b7fdd86f5555a520216a11b10f3322dc749076e06c5249e1ccc70dd3c1ac36e2ba940ba3cd4e5987ebc60",
         Mac => "f476bd42bae22e645cedf601511b1ab8f2852b2c");
      Test_HMAC
        (Key => "7fc4aa492a3d12da5d2de0cf9a61c0fbf9e4a2571920554a5c45582754efedf878036e7a1cd9e468a0a1d6fce7ff5fb40af983524e13c32654b8ef8f90dc3cc0fce097c00eb638b4e7457961cd0fe9ed",
         Msg => "e36b3b02b86b02996c1cc21fcb70b5b30327afada1f0afdebcd1b41970c8d2f18fb384c5926d44fad63a59880565f1b8d1276f2ce9cb061f251087ee04cf77d759dd650141337abd584c520c2dcf0a61f36e9ba8790e66865c2810e37b6f8fa6abb385bfac05cd6b5c1c54b32bf72b36cfc4da293901f69cc7e1f6ffbbf142e4",
         Mac => "48d48ceb4c1f3e6b1e9c0fb8515f1121b846c19b");
      Test_HMAC
        (Key => "b6ec7ce6448428c34fc6819d50507a2d74ae4175fd2ac53ee5e576c5c5274bb2f6f40a49f6e0c4e40d249ea130f0d858250307d0e87aa5324ee5ccbde8a03fbc2a61aab5cc0d2be471d010e7876ce3bb",
         Msg => "dde1c090446d11f936517eac73d6776695c1ff3051850e32fab734cc46c280e355dca079ef3949810e7edaf19c783c187d0e0c32d074fc3a72a276ffc405837aaf74ec5fe5659ff26961531c51b56fbecb6b28455e78ea7f7237faad131659d9f290eb69ac5bd8f54fe233561bf5daff85bf9d9182f9a2a9015e07fcb95fcaa7",
         Mac => "9e51be58cf2d5c8e85556b8f3d484109fb49553a");
      Test_HMAC
        (Key => "ceb9aedf8d6efcf0ae52bea0fa99a9e26ae81bacea0cff4d5eecf201e3bca3c3577480621b818fd717ba99d6ff958ea3d59b2527b019c343bb199e648090225867d994607962f5866aa62930d75b58f6",
         Msg => "99958aa459604657c7bf6e4cdfcc8785f0abf06ffe636b5b64ecd931bd8a456305592421fc28dbcccb8a82acea2be8e54161d7a78e0399a6067ebaca3f2510274dc9f92f2c8ae4265eec13d7d42e9f8612d7bc258f913ecb5a3a5c610339b49fb90e9037b02d684fc60da835657cb24eab352750c8b463b1a8494660d36c3ab2",
         Mac => "4ac41ab89f625c60125ed65ffa958c6b490ea670");
	end Test_HMAC_NIST;

   ---------------------------------------------------------------------------

   procedure Register_Tests (T: in out Test_Case) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_HMAC_RFC'Access, "HMAC SHA-1 (RFC 2202)");
      Register_Routine (T, Test_HMAC_NIST'Access, "HMAC SHA-1 (NIST L=20)");
   end Register_Tests;

   ---------------------------------------------------------------------------

   function Name (T : Test_Case) return Test_String is
   begin
      return Format ("HMAC SHA1");
   end Name;

end LSC_Test_HMAC_SHA1;
