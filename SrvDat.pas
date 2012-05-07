unit SrvDat;

interface

uses Classes, SysUtils, Forms, Srv, Utils;

type

  TServersDat=class
  private
    Srvs:TStringList;
    CurFile:string;
    function HasSrv(Index:string):boolean;
    function GetSrv(Index:string):string;
    procedure SetSrv(Index, Value:string);
    constructor Create;
    destructor Destroy;
  public
    property HasServer[Index:string]:boolean read HasSrv;
    property Server[Index:String]:string read GetSrv write SetSrv;
    class procedure ProcessServer(si:PServerSettings);
    procedure LoadFromFile(FileName:string);
    procedure SaveToFile(FileName:string); overload;
    procedure SaveToFile; overload;
  end;

implementation

{ TServersBin }

class procedure TServersDat.ProcessServer(si:PServerSettings);
var Srv:TServersDat;
    sa, sv:StrArray;
    i:integer;
begin
  if (si=nil) or (si.Servers='') then
    Exit;

  Srv:=TServersDat.Create;
  Srv.LoadFromFile(GetPathSubstr('%APPDATA%\.minecraft\')+'servers.dat');
  sa:=Explode(si.Servers, ',');
  for i:=0 to High(sa) do
    begin
      sv:=Explode(sa[i], '@');
      Srv.Server[sv[0]]:=sv[1];
    end;
  Srv.SaveToFile;
  Srv.Free;
end;

constructor TServersDat.Create;
begin
  Srvs:=TStringList.Create;
  CurFile:='';
end;

destructor TServersDat.Destroy;
begin
  FreeAndNil(Srvs);
  CurFile:='';
  inherited Destroy;
end;

function TServersDat.HasSrv(Index: string): boolean;
begin
  Result:=Srvs.Values[Index]<>'';
end;

function TServersDat.GetSrv(Index: string): string;
begin
  Result:=Srvs.Values[Index];
end;

procedure TServersDat.SetSrv(Index, Value: string);
begin
  if Value<>'' then
    Srvs.Values[Index]:=Value
  else
    Srvs.Delete(Srvs.IndexOfName(Index));
end;

procedure TServersDat.LoadFromFile(FileName: string);
var S:TFileStream;
    str:AnsiString;
    name, ip:string;
    n, l:byte;
    i:integer;
begin
  if not FileExists(FileName) then
    Exit;

  try
    s:=TFileStream.Create(FileName, fmOpenRead);

    Srvs.Clear;

    SetLength(str, 17);
    s.Read(str[1], 17);
    if str<>#10#0#0#9#0#7'servers'#10#0#0#0 then
      begin
        S.Free;
        Exit;
      end;

    CurFile:=FileName;

    s.Read(n, SizeOf(Byte));
    for i:=0 to n-1 do
      begin
        SetLength(str, 8);
        s.Read(str[1], 8);

        s.Read(l, SizeOf(Byte)); //Name
        SetLength(str, l);
        s.Read(str[1], l);
        name:=str;

        SetLength(str, 6);
        s.Read(str[1], 6);

        s.Read(l, SizeOf(Byte)); //IP
        SetLength(str, l);
        s.Read(str[1], l);
        ip:=str;

        s.Read(l, SizeOf(Byte));

        Srvs.Values[name]:=ip;
      end;
    s.Free;
  except
    s.Free;
    Application.MessageBox('Servers.dat File is corrupted!', 'Error!');
  end;
end;

procedure TServersDat.SaveToFile(FileName: string);
var S:TFileStream;
    str:AnsiString;
    n, l:byte;
    i:integer;
begin
  try
    s:=TFileStream.Create(FileName, fmCreate);

    str:=#10#0#0#9#0#7'servers'#10#0#0#0;
    s.Write(str[1], 17);

    n:=Srvs.Count;
    s.Write(n, SizeOf(Byte));
    for i:=0 to n-1 do
      begin
        str:=#8#0#4'name'#0;
        s.Write(str[1], 8);

        str:=Srvs.Names[i]; //Name
        l:=length(str);
        s.Write(l, SizeOf(Byte));
        s.Write(str[1], l);

        str:=#8#0#2'ip'#0;
        s.Write(str[1], 6);

        str:=Srvs.ValueFromIndex[i]; //IP
        l:=length(str);
        s.Write(l, SizeOf(Byte));
        s.Write(str[1], l);

        l:=0;
        s.Write(l, SizeOf(Byte));
      end;

    l:=0;
    s.Write(l, SizeOf(Byte));
    s.Free;
  except
    s.Free;
  end;
end;

procedure TServersDat.SaveToFile;
begin
  if CurFile<>'' then
    SaveToFile(CurFile)
  else
    SaveToFile(GetPathSubstr('%APPDATA%\.minecraft\')+'servers.dat');
end;

end.
