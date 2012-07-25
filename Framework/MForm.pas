unit MForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Controller;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
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
  if Controller.Login(Edit1.Text, Edit2.Text)<>0 then
    if Edit2.Text<>'' then
      MessageBox(0, 'Error!', '', 0)
    else
      Controller.Launch
  else
    Controller.Launch;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Controller:=TLauncherController.Create;
end;

end.
