program Project1_2;

uses
  Vcl.Forms,
  MainUnit in 'MainUnit.pas' {MainForm},
  ConditionUnit in 'ConditionUnit.pas' {Instraction},
  EditorUnit in 'EditorUnit.pas' {AboutEditor};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TInstraction, Instraction);
  Application.CreateForm(TAboutEditor, AboutEditor);
  Application.Run;
end.
