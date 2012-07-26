unit MForm;

interface

uses
  SysUtils, Controls, Forms, StdCtrls, Controller, System.Classes;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit3: TEdit;
    Edit4: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    Controller: TLauncherController;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  Controller.SetMemory(StrToInt(Edit4.Text), StrToInt(Edit3.Text));
  if Controller.Login(Edit1.Text, Edit2.Text)<>0 then
    if Edit2.Text<>'' then
      Application.MessageBox('Error!', '', 0)
    else
      Controller.Launch
  else
    Controller.Launch;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Controller:=TLauncherController.Create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if Controller<>nil then
    Controller.Free;
end;

end.
