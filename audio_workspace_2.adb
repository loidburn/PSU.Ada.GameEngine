with Audio;
with Ada.Text_IO;
with System;
procedure Audio_Workspace_2 is
   hwo : Audio.LPHWAVEOUT := new Audio.HWAVEOUT;
   wfx : Audio.LPCWAVEFORMATEX := new Audio.WAVEFORMATEX;
   block : Audio.LPSTR;
   blockSize : Audio.PDWORD := new Audio.DWORD;
   result : Audio.MMRESULT;

begin

   wfx.nSamplesPerSec := 44100; -- std sample rate
   wfx.wBitsPerSample := 16; -- std sample size
   wfx.nChannels := 2; -- std no. of channels
   wfx.cbSize := 0;
   wfx.wFormatTag := Audio.WAVE_FORMAT_PCM;
   wfx.nBlockAlign := Audio.WORD((Integer(wfx.wBitsPerSample) / 8) * Integer(wfx.nChannels));
   wfx.nAvgBytesPerSec := Audio.DWORD(Integer(wfx.nBlockAlign) * Integer(wfx.nSamplesPerSec));



   result := Audio.waveOutOpen(hwo, Audio.WAVE_MAPPER, wfx, 0, 0, Audio.CALLBACK_NULL);
   Ada.Text_IO.Put_Line("waveOutOpen result: " & Integer'Image(Integer(result)));

   if Integer(result) /= Integer(Audio.MMSYSERR_NOERROR) then
      Ada.Text_IO.Put_Line("unable to open WAVE_MAPPER device");
      raise Program_Error;
   end if;

   Ada.Text_IO.Put_Line("Device opened successfully.");

   block := Audio.loadAudioBlock("C:\\Users\\burnl\\Downloads\\40504_hello-meme.raw", blockSize);
   --Audio.writeAudioBlock(hwo.all, block, blockSize.all);

   result := Audio.waveOutClose(hwo.all);
   Ada.Text_IO.Put_Line("Device closed.");

end Audio_Workspace_2;
