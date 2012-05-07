unit Utils;

interface

uses Windows, Classes, SysUtils, ShlObj;

type

  StrArray = array of string;

function Explode(sText, sSeparator: string):StrArray;
function StrReplace(str, src, rep: String): String;
function GetDiskSerialNumber(Disk: char): Cardinal;
function GetAppDataFolder:string;
function GetTempFolder:string;
function GetPathSubstr(ss:string):string;

var Path, Temp, Data:string;

implementation

uses
  MForm;

function Explode(sText, sSeparator: string):StrArray;
var
  n, l, sl: integer;
begin
  sl:=Length(sSeparator);
  n:=Pos(sSeparator, sText);
  l:=1;
  while n > 0 do
  begin
    SetLength(result, l);
    result[l-1]:=Copy(sText, 1, n-1);
    sText:=Copy(sText, n+sl, maxint);
    n:=Pos(sSeparator, sText);
    Inc(l);
  end;
  SetLength(result, l);
  result[l-1]:=sText;
end;

function StrReplace(str, src, rep: String): String;
var
aPos: Integer;
rslt: String;
begin
  aPos := Pos(src, str);
  rslt := '';
  while (aPos <> 0) do
    begin
      rslt := rslt + Copy(str, 1, aPos - 1) + rep;
      Delete(str, 1, aPos + Length(src) - 1);
      aPos := Pos(src, str);
    end;
  Result := rslt + str;
end;

function GetDiskSerialNumber(Disk: char): Cardinal;
var
 VolumeSerialNumber :DWORD;
 MaximumComponentLength,
 FileSystemFlags: Cardinal;
begin
  GetVolumeInformation(PChar(Disk + ':\'),
                       nil,
                       0,
                       @VolumeSerialNumber,
                       MaximumComponentLength,
                       FileSystemFlags,
                       nil,
                       0);

  Result := VolumeSerialNumber;
end;

function GetAppDataFolder:string;
var ps:widestring;
begin
  SetLength(ps, 255);
  ShlObj.SHGetSpecialFolderPath(0, @ps[1], CSIDL_APPDATA, false);
  SetLength(ps, Pos(#0, ps)-1);
  Result:=ps+'\Monocraft\';
  if not DirectoryExists(Result) then
    ForceDirectories(Result);
end;

function GetTempFolder:string;
var
  tempFolder: array[0..MAX_PATH] of Char;
begin
  GetTempPath(MAX_PATH, @tempFolder);
  result := StrPas(tempFolder);
end;

function GetPathSubstr(ss:string):string;
var ps:widestring;
begin
  SetLength(ps, 255);
  ShlObj.SHGetSpecialFolderPath(0, @ps[1], CSIDL_APPDATA, false);
  SetLength(ps, Pos(#0, ps)-1);
  ss:=StrReplace(ss, '%APPDATA%', ps);

  SetLength(ps, 255);
  ShlObj.SHGetSpecialFolderPath(0, @ps[1], CSIDL_PROGRAM_FILES, false);
  SetLength(ps, Pos(#0, ps)-1);
  ss:=StrReplace(ss, '%PROGRAMS%', ps);

  ss:=StrReplace(ss, '%PATH%', Path);

  Result:=ss;
end;

initialization

end.
