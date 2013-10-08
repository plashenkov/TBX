program Patch;

uses
  Forms,
  Main in 'Main.pas' {Form_Main};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Toolbar2000 v2.2.2 Patch';
  Application.CreateForm(TForm_Main, Form_Main);
  Application.Run;
end.
