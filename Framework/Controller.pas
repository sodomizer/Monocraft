unit Controller;

interface

uses Windows, IdHTTP, SysUtils, Classes, ShellAPI, IdURI, SettingsController, Utils, Config;

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
    Session: TSession;
    Settings: TSettingsHandler;
  public
    //#TEMP
    CanPlayOffline:boolean;

    procedure SetMemory(Max:integer; Initial:integer=256);
    //procedure SetPath(NewPath:string);
    //procedure DownloadClient;

    function Login(User, Pass:string):integer;
    function PlayOffline(User:string='Player'):integer;
    function Launch:integer;

    //#TEMP
    function DownloadFile(Url, Dst:string):integer;
    function DownloadClient:integer;

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
  if not FileExists(mpath+'minecraft.jar') then
    begin
      Result:=lauNoClient;
      Exit;
    end;
  if Settings.Local.JavaMaxMemory>GetFreeRAM then
    begin
      Result:=lauNoMemory;
      Exit;
    end;
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

  if not ShellAPI.ShellExecuteExW(@exinfo) then
    Result:=lauNoJava
  else
    Result:=lauSuccess;
end;

function TLauncherController.Login(User, Pass: string): integer;
var n:integer;
    par:TStringList;
    HTTP:TIdHTTP;
    res:string;
    ra:StrArray;
begin
  //#TEMP
  CanPlayOffline:=FileExists(GetPathSubstr('%APPDATA%\.minecraft')+'\bin\minecraft.jar');

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
        ra:=Explode(Res,':');
        Session.version:=ra[0];
        Session.ticket:=ra[1];
        Session.sessid:=ra[3];
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

function TLauncherController.PlayOffline(User: string = 'Player'): integer;
begin
  if User<>'' then
    Session.login:=User
  else
    Session.login:='Player';
  Session.sessid:='-';
  Session.ticket:='';
  Session.version:='';
  Result:=Launch;
end;

procedure TLauncherController.SetMemory(Max, Initial: integer);
begin
  Settings.SetMemory(Max, Initial);
end;

function TLauncherController.DownloadFile(Url, Dst:string):integer;
var fs:TFileStream;
    HTTP:TIdHTTP;
begin
  Url:=TIdUri.URLEncode(Url);
  result:=0;
  HTTP:=TIdHTTP.Create(nil);
  try
    fs:=TFileStream.Create(Dst, fmCreate);
    HTTP.Request.UserAgent := 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)';
    try
      HTTP.Get(Url, fs);
    except
      Result:=1;
    end;
  finally
    fs.Free;
    HTTP.Free;
  end;
end;

function TLauncherController.DownloadClient:integer;
var i:integer;
    Dst:string;
    lzma:boolean;
    CurFile:string;
begin
  Result:=-1;
  //lzma:=false;
  Dst:=GetPathSubstr('%APPDATA%\.minecraft\');//GetClientPath
  ForceDirectories(Dst+'resources');
  ForceDirectories(Dst+'bin\natives');
  for i:=0 to High(_JarArray) do
    begin
      CurFile:=_JarArray[i];
      if DownloadFile(_DownloadURL+_JarArray[i], Temp+_JarArray[i])<>0 then
        {if JarArray[i]='windows_natives.jar' then
            if DownloadFile(_DownloadURL+JarArray[i]+'.lzma', Temp+JarArray[i]+'.lzma')=0 then
                lzma:=true
            else
              begin
                Result:=1;
                Exit;
              end
        else }
          begin
            Result:=2;
            Exit;
          end;
    end;

  for i:=0 to High(_JarArray) do
    begin
      if FileExists(Dst+'bin/'+_JarArray[i]) then
        DeleteFile(Dst+'bin/'+_JarArray[i]);
      //if i<>High(JarArray)then
        MoveFile(PWideChar(Temp+_JarArray[i]), PWideChar(Dst+'bin/'+_JarArray[i]))
      {else
        begin
          if lzma then
            begin
              ExtractLZMA(Temp+JarArray[i]+'.lzma');
              ExtractZip(Temp+'natives.jar', Dst+'bin/natives/', '*.dll');
              DeleteFile(Temp+JarArray[i]+'.lzma');
              DeleteFile(Temp+'natives.jar');
            end
          else
            begin
              ExtractZip(Temp+JarArray[i], Dst+'bin/natives/', '*.dll');
              DeleteFile(Temp+JarArray[i]);
            end;
        end;}
    end;

  {if UpdateClient then
    begin
      CurFile:='client.zip';
      if DownloadFile(si.DownloadURL+'client.zip', Temp+'client.zip')=0 then
        begin
          case si.ZipType of
            ztRoot: ;
            ztData: Dst:=GetSavesPath(si);
          else
            Dst:=Dst+'resources\';
          end;
          ExtractZip(Temp+'client.zip', Dst);
          DeleteFile(Temp+'client.zip');
        end;
    end;}

  //ForceUpdate:=false;
  Result:=0;
  //#TEMP
  CanPlayOffline:=FileExists(GetPathSubstr('%APPDATA%\.minecraft')+'\bin\minecraft.jar');
end;

end.
