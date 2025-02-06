with Interfaces;
with Interfaces.C;
with Interfaces.C.Strings;

package Audio is

   pragma Linker_Options ("-lwinmm");

   function mciSendStringA (
      lpstrCommand : in Interfaces.C.Strings.chars_ptr;
      lpstrReturnString : in Interfaces.C.Strings.chars_ptr;
      uReturnLength : in Interfaces.C.unsigned_short;
      hwndCallback : in Interfaces.C.unsigned_short
   ) return Interfaces.C.int;

   pragma Import (Stdcall, mciSendStringA, "mciSendStringA");

   procedure play_audio(file_path : String);
end Audio;