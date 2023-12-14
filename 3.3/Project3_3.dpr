program Project3_3;

uses
  Vcl.Forms,
  MainUnit in 'MainUnit.pas' {Form1},
  InstractionUnit in 'InstractionUnit.pas' {Instraction},
  AboutEditorUnit in 'AboutEditorUnit.pas' {AboutEditor};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TInstraction, Instraction);
  Application.CreateForm(TAboutEditor, AboutEditor);
  Application.Run;
end.
