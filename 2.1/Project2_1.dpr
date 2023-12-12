program Project2_1;

uses
  Vcl.Forms,
  MainUnit in 'MainUnit.pas' {MainForm},
  InstractionUnit in 'InstractionUnit.pas' {Instraction},
  AboutEditorUnit in 'AboutEditorUnit.pas' {AboutEditor};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TInstraction, Instraction);
  Application.CreateForm(TAboutEditor, AboutEditor);
  Application.Run;
end.
