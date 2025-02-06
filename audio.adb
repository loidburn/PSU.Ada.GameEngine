with Interfaces.C.Strings;

package body Audio is

   procedure play_audio(file_path : String) is
      open : constant String := "open """ & file_path & """ type mpegvideo alias music" & ASCII.NUL;
      play : constant String := "play music wait" & ASCII.NUL;
      close : constant String := "close music" & ASCII.NUL;

      open_ptr  : Interfaces.C.Strings.chars_ptr := Interfaces.C.Strings.New_String(open);
      play_ptr  : Interfaces.C.Strings.chars_ptr := Interfaces.C.Strings.New_String(play);
      close_ptr : Interfaces.C.Strings.chars_ptr := Interfaces.C.Strings.New_String(close);
   
      result : Interfaces.C.int;

   begin
      result := mciSendStringA(open_ptr, Interfaces.C.Strings.Null_Ptr, 0, 0);
      result := mciSendStringA(play_ptr, Interfaces.C.Strings.Null_Ptr, 0, 0);
      result := mciSendStringA(close_ptr, Interfaces.C.Strings.Null_Ptr, 0, 0);
   end play_audio;

end Audio;