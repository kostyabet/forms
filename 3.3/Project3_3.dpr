program Project3_3;

uses
  Vcl.Forms,
  MainUnit in 'MainUnit.pas' {MainForm},
  InstractionUnit in 'InstractionUnit.pas' {Instraction},
  AboutEditorUnit in 'AboutEditorUnit.pas' {AboutEditor},
  StepByStepUnit in 'StepByStepUnit.pas' {StepByStep};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TInstraction, Instraction);
  Application.CreateForm(TAboutEditor, AboutEditor);
  Application.CreateForm(TStepByStep, StepByStep);
  Application.Run;
end.
