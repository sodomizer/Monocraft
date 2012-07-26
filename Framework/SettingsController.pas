unit SettingsController;

interface

type

  TServerSettings = record
  // Connection settings
    Address:string;
    Port:word;
  // Server settings
    Name:string;
    Description:string;
    AddInfo:string;
    DownloadURL:string;
  // Client settings
    Folder:string;

  // Internal use
    Version:string;
  end;

  TLocalSettings = record
  // User settings
    Username:string;
    Password:string;
  // Java settings
    JavaPath:string;
    JavaInitMemory:integer;
    JavaMaxMemory:integer;
  end;

  TSettingsHandler = class
  private
    FServerCount: integer;

    FLocal: TLocalSettings;

    DoForceUpdate: boolean;
    ClientZip: boolean;

    //function GetServer(Index:integer):TServerSettings;
  public
  // Properties
    //property ServerCount:integer read FServerCount;
    property Local:TLocalSettings read FLocal;

  // Client related
    //procedure ForceUpdate(GetClientZip:boolean=true);

  // Settings
    procedure SetMemory(Max, Initial: integer);
    //procedure LoadLocalSettings;
    //procedure SaveLocalSettings;

  // Server related
   // function  AddServer:TServerSettings; overload;
   // procedure AddServer(Name:string; Address:string; Url:string; Port:word=25565; Description:string=''; AddInfo:string=''); overload;
   // procedure Clear;

  // Constructor & Destructor
    constructor Create;
    destructor Destroy;
  end;

implementation

{ TSettingsHandler }

constructor TSettingsHandler.Create;
begin
  FLocal.JavaInitMemory:=512;
  FLocal.JavaMaxMemory:=1024;
end;

destructor TSettingsHandler.Destroy;
begin

end;

procedure TSettingsHandler.SetMemory(Max, Initial: integer);
begin
  FLocal.JavaMaxMemory:=Max;
  if Initial>Max then
    FLocal.JavaInitMemory:=Max
  else
    FLocal.JavaInitMemory:=Initial;
end;

end.
