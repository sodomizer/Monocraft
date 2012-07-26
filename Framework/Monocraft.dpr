program Monocraft;

uses
  Forms,
  Utils in '..\Utils.pas',
  MForm in 'MForm.pas' {Form1},
  Controller in 'Controller.pas',
  SettingsController in 'SettingsController.pas',
  Config in 'Config.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
