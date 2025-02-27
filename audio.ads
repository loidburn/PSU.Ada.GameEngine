with Interfaces;
with Interfaces.C;
with Interfaces.C.Strings;
with System;

package Audio is

   pragma Linker_Options("-lwinmm");

   WAVE_FORMAT_PCM     : constant := 1;
   BLOCK_SIZE          : constant := 8192;
   BLOCK_COUNT         : constant := 20;
   WAVE_MAPPER         : constant := 16#FFFF_FFFF#;
   CALLBACK_NULL       : constant := 16#0#;
   MMSYSERR_NOERROR    : constant := 0;
   WAVERR_STILLPLAYING : constant := 33;

   
   subtype HANDLE is System.Address;
   subtype HWAVEOUT is HANDLE;
   type LPHWAVEOUT is access all HWAVEOUT;


   subtype WORD is Interfaces.C.unsigned_short;
   subtype DWORD is Interfaces.C.unsigned_long;
   type PDWORD is access all DWORD;

   type WAVEFORMATEX is record
      wFormatTag        : WORD;
      nChannels         : WORD;
      nSamplesPerSec    : DWORD;
      nAvgBytesPerSec   : DWORD;
      nBlockAlign       : WORD;
      wBitsPerSample    : WORD;
      cbSize            : WORD;
   end record;

   type LPCWAVEFORMATEX is access all WAVEFORMATEX;

   subtype UINT is Interfaces.C.unsigned;
   type MMRESULT is new UINT;

   type BYTE is new Interfaces.C.unsigned_char;
   type PBYTE is access all BYTE;
   subtype LPBYTE is PBYTE;

   type WAVEHDR;
   type PWAVEHDR is access all WAVEHDR;
   subtype LPWAVEHDR is PWAVEHDR;

   type WAVEHDR is record
      lpData            : LPBYTE;
      dwBufferLength    : DWORD;
      dwBytesRecorded   : DWORD;
      dwUser            : DWORD;
      dwFlags           : DWORD;
      dwLoops           : DWORD;
      lpNext            : PWAVEHDR;
      reserved          : DWORD;
   end record;

   subtype CHAR is Interfaces.C.char;
   type PCHAR is access all CHAR;
   subtype LPSTR is PCHAR;



   --C functions
   function waveOutOpen (
      lpwho       : LPHWAVEOUT;
      uDeviceID   : UINT;
      lpFormat    : LPCWAVEFORMATEX;
      dwCallback  : DWORD;
      dwInstance  : DWORD;
      dwFlags     : DWORD
   ) return MMRESULT;

   function waveOutClose (hwo : HWAVEOUT) return MMRESULT;

   function waveOutPrepareHeader(
      hwo      :  HWAVEOUT;
      pwh      :  LPWAVEHDR;
      cbwh     :  UINT
   ) return MMRESULT;

   function waveOutUnprepareHeader(
      hwo      : HWAVEOUT;
      pwh      : LPWAVEHDR;
      cbwh     : UINT
   ) return MMRESULT;

   function waveOutWrite(
      hwo      : HWAVEOUT;
      pwh      : LPWAVEHDR;
      cbwh     : UINT
   ) return MMRESULT;

   pragma Import (Stdcall, waveOutOpen, "waveOutOpen");
   pragma Import (Stdcall, waveOutClose, "waveOutClose");
   pragma Import (Stdcall, waveOutPrepareHeader, "waveOutPrepareHeader");
   pragma Import (Stdcall, waveOutUnprepareHeader, "waveOutUnprepareHeader");
   pragma Import (Stdcall, waveOutWrite, "waveOutWrite");

   --prototypes
   procedure writeAudioBlock(
      hwo    : HWAVEOUT;
      block       : LPSTR;
      size        : DWORD
   );

   function loadAudioBlock(
      filename    : String;
      blockSize   : PDWORD
   ) return LPSTR;

--   procedure waveOutProc(
--      hWaveOut    : HWAVEOUT;
--      uMsg        : UINT;
--      dwInstance  : DWORD;
--      dwParam1    : DWORD;
--      dwParam2    : DWORD
--   );

--   function allocateBlocks(
--      size  : Integer;
--      count : Integer
--   ) return access WAVEHDR;

--   procedure freeBlocks(
--      blockArray  : access WAVEHDR
--   );

--   procedure writeAudio(
--      hWaveOut : HWAVEOUT;
--      data     : LPSTR;
--      size     : Integer
--   );

end Audio;