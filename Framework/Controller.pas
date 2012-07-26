unit Controller;

interface

uses IdHTTP, SysUtils, Classes, ShellAPI, SettingsController, Utils, Config;

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

  TSession = record
    login:string;
    ticket:string;
    sessid:string;
    version:string;
  end;

  TLauncherController = class
  private
    //Temporary place
    fLogin:string;

    Session: TSession;
    Settings: TSettingsHandler;
  public
    procedure SetMemory(Max:integer; Initial:integer=256);
    //procedure SetPath(NewPath:string);
    //procedure DownloadClient;

    function Login(User, Pass:string):integer;
    function Launch:integer;
    constructor Create;
    destructor Destroy;
  end;

implementation

{ TLauncherController }

constructor TLauncherController.Create;
begin
  Settings:=TSettingsHandler.Create;
end;

destructor TLauncherController.Destroy;
begin
  if Settings<>nil then
    Settings.Free;
end;

function TLauncherController.Launch: integer;
var exinfo:TShellExecuteInfoW;
    par, mpath:string;
begin
  if Session.login='' then
    Session.login:='Player';
  mpath:=GetPathSubstr('%APPDATA%\.minecraft')+'\bin\';
  FillChar(exinfo, sizeOf(exinfo), 0);
    with exinfo do
    begin
      cbSize := SizeOf(TShellExecuteInfo);
      fMask := SEE_MASK_NO_CONSOLE;
      Wnd := 0;
      lpDirectory := PWideChar(mpath);
      lpFile := 'java';
      par:= '-Xms'+IntToStr(Settings.Local.JavaInitMemory)+'m -Xmx'+IntToStr(Settings.Local.JavaMaxMemory)+'m -Djava.library.path=natives '+
                     '-cp "minecraft.jar;jinput.jar;lwjgl.jar;lwjgl_util.jar;" net.minecraft.client.Minecraft '+'"'+Session.login+'"'+' "'+Session.sessid+'"';
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
  par.Add('version='+_Version);
  try
    Res:=HTTP.Post(_AuthURL, par);
    if Pos(User, Res)>0 then
      begin
        Result:=0;

        Session.login:=User;
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

procedure TLauncherController.SetMemory(Max, Initial: integer);
begin
  Settings.SetMemory(Max, Initial);
end;

end.
