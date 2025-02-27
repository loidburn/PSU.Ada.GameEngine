with Audio;
with Ada.Text_IO;
with Ada.Streams.Stream_IO;
with Ada.IO_Exceptions;
with Interfaces;
with Interfaces.C;
with Interfaces.C.Strings;
with Interfaces.C.Pointers;
with System;
with System.Storage_Elements;
with Ada.Unchecked_Conversion;
with Ada.Unchecked_Deallocation;

with GNAT.OS_Lib;

use System;
use Ada.Streams;
use Ada.Streams.Stream_IO;
use Interfaces;
use Interfaces.C;
use Interfaces.C.Strings;
use System.Storage_Elements;

package body Audio is
   pragma Optimize(off);  



   procedure writeAudioBlock(hwo : HWAVEOUT; block : LPSTR; size : DWORD) is
      header : LPWAVEHDR := new WAVEHDR;
      pheader : LPWAVEHDR;
      header_size : constant Natural := WAVEHDR'Size / 8;
      result : MMRESULT;

      function Convert is new Ada.Unchecked_Conversion(PCHAR, LPBYTE);
      

   begin

      header.all.lpData := Convert(block);
      header.all.dwBufferLength := size;

      result := waveOutPrepareHeader(hwo, header, UINT(header_size));
      result := waveOutWrite(hwo, header, UINT(header_size));


      delay 0.5;
      loop
         exit when waveOutUnprepareHeader(hwo, header, UINT(header_size)) /= WAVERR_STILLPLAYING;
      end loop;
      delay 0.1;

   end writeAudioBlock;

   function loadAudioBlock(filename : String; blockSize : PDWORD) return LPSTR is
      type Byte_Array is array (Positive range <>) of Stream_Element;
      type Byte_Array_Access is access Byte_Array;
      subtype BOOL is Interfaces.C.int;

      file    : Ada.Streams.Stream_IO.File_Type;
      size    : Ada.Streams.Stream_IO.Count;
      read    : Ada.Streams.Stream_IO.Count;
      data    : Byte_Array_Access;
      mem_ptr : System.Address;
      stream  : Ada.Streams.Stream_IO.Stream_Access;
      --stream_arr  : Ada.Streams.Stream_Element_Array(1 .. data'Length);

      -- Import Windows API Functions
      function HeapAlloc (hHeap : System.Address; dwFlags, dwBytes : DWORD) return System.Address;
      pragma Import (Stdcall, HeapAlloc, "HeapAlloc");

      function GetProcessHeap return System.Address;
      pragma Import (Stdcall, GetProcessHeap, "GetProcessHeap");

      function CloseHandle (hObject : System.Address) return BOOL;
      pragma Import (Stdcall, CloseHandle, "CloseHandle");

      --function Convert is new Ada.Unchecked_Conversion(System.Address, Byte_Array_Access);
      -- function ConvertArr is new Ada.Unchecked_Conversion(Byte_Array, Stream_Element_Array);
      function ConvertToLPSTR is new Ada.Unchecked_Conversion(System.Address, LPSTR);

   begin
      -- Open the file
      Ada.Streams.Stream_IO.Open(file, Ada.Streams.Stream_IO.In_File, filename);

      -- Get the file size
      size := Ada.Streams.Stream_IO.Size(file);
      blockSize.all := DWORD(size);  -- Assign size to blockSize
      stream := Ada.Streams.Stream_IO.Stream(file);

      declare
         mem_buffer : Byte_Array(0 .. size-1) := (others => 0);

      begin
               -- Allocate memory from Windows heap
         -- mem_ptr := HeapAlloc(GetProcessHeap, 0, DWORD(size));
         
         -- Allocate an Ada Byte_Array_Access for data manipulation
         
         
         -- Convert Byte_Array to Stream_Element_Array manually
         --for I in stream_arr'Range loop
         -- stream_arr(I) := Ada.Streams.Stream_Element(data(Integer(I)));
         --end loop;


         -- Read file into memory
      -- Ada.Streams.Read(stream.all, stream_arr, Ada.Streams.Stream_Element_Offset(read));

         -- Close the file
         Ada.Streams.Stream_IO.Close(file);

         -- Return LPSTR pointer
         return ConvertToLPSTR(mem_ptr);
      end;


   exception
      when Ada.IO_Exceptions.Name_Error =>
         Ada.Text_IO.Put_Line("ERR: File not found.");
         return null;
      when others =>
         Ada.Text_IO.Put_Line("ERR: Failed to load audio block.");
         return null;
   end loadAudioBlock;


   



end Audio;