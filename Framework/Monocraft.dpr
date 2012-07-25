program Monocraft;

uses
  Forms,
  MForm in 'MForm.pas' {Form1},
  Controller in 'Controller.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
