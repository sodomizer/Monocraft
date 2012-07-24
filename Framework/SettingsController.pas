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

    ForceUpdate: boolean;
    ClientZip: boolean;

    function GetServer:
  public
  // Properties
    property ServerCount:integer read FServerCount;

  // Client related
    procedure ForceUpdate(GetClientZip:boolean=true);

  // Settings
    procedure LoadLocalSettings;
    procedure SaveLocalSettings;

  // Server related
    function  AddServer:TServerSettings; overload;
    procedure AddServer(Name:string; Address:string; Url:string; Port:word=25565; Description:string=''; AddInfo:string=''); overload;
    procedure Clear;

  // Constructor & Destructor
    constructor Create;
    destructor Destroy;
  end;

implementation

end.
