unit Controller;

interface

uses IdHTTP, SysUtils, Classes, ShellAPI;

const

  // Login results
  logFailed    = -1; // No connection
  logSuccess   = 0;  // Success
  logWrongPass = 1;  // Wrong login/pass
  logWrongHash = 2;  // Corrupted client
  logBanned    = 3;  // Banned
  logBrute     = 4;  // Too many attempts

  // Launch results
  lauFailed    = -1; // Unknown problem
  lauSuccess   = 0;  // Launch successful
  lauNoClient  = 1;  // No minecraft.jar
  lauNoJava    = 2;  // Java not found
  lauNoMemory  = 3;  // Not enough RAM


type

  TLauncherController = class
  private
    //Temporary place
    fLogin:string;
    JavaInitMemory,
    JavaMaxMemory:integer;

    //Settings: TSettings;
  public
    //procedure SetMemory(Max:integer; Initial:integer=256);
    //procedure SetPath(NewPath:string);
    //procedure DownloadClient;
    //
    function Login(User, Pass:string):integer;
    function Launch:integer;
    constructor Create;
  end;

implementation

{ TLauncherController }

constructor TLauncherController.Create;
begin
  JavaInitMemory:=512;
  JavaMaxMemory:=1024;
end;

function TLauncherController.Launch: integer;
var exinfo:TShellExecuteInfoW;
    par, mpath:string;
begin
  if flogin='' then
    flogin:='Player';
  mpath:={GetClientPath(si)}'D:\Users\KOOL\AppData\Roaming\.minecraft'+'\bin\';
  FillChar(exinfo, sizeOf(exinfo), 0);
    with exinfo do
    begin
      cbSize := SizeOf(TShellExecuteInfo);
      fMask := SEE_MASK_NO_CONSOLE;
      Wnd := 0;
      lpDirectory := PWideChar(mpath);
      lpFile := 'java';
      par:= '-Xms'+IntToStr(JavaInitMemory)+'m -Xmx'+IntToStr(JavaMaxMemory)+'m -Djava.library.path=natives '+
                     '-cp "minecraft.jar;jinput.jar;lwjgl.jar;lwjgl_util.jar;" net.minecraft.client.Minecraft '+'"'+flogin+'"'+' "'+{si.SessionId+}'"';
      lpParameters := PWideChar(par);
      nShow := 0;
    end;

  ShellAPI.ShellExecuteExW(@exinfo);
end;

function TLauncherController.Login(User, Pass: string): integer;
var n:integer;
    par:TStringList;
    HTTP:TIdHTTP;
    res:string;
begin
  HTTP:=TIdHTTP.Create(nil);
  par:=TStringList.Create;
  par.Add('user='+User);
  par.Add('password='+Pass);
  par.Add('version='+'18');
  try
    Res:=HTTP.Post('http://example.com/auth.php', par);
    if Pos(User, Res)>0 then
      begin
        Result:=0;
        flogin:=User;
      end
    else
      begin
        Result:=1;
        //Antibruteforce
        Sleep(3000);
      end;
  except
    Result:=-1;
  end;

  par.Free;
  HTTP.Free;
end;

end.
