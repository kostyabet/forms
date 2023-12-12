program Project1_1;

uses
  Vcl.Forms,
  MainUnit in 'MainUnit.pas' {MainForm},
  ConditionUnit in 'ConditionUnit.pas' {Instraction},
  EditorUnit in 'EditorUnit.pas' {AboutEditor},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TInstraction, Instraction);
  Application.CreateForm(TAboutEditor, AboutEditor);
  Application.Run;
end.
