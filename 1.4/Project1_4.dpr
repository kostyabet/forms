program Project1_4;

uses
  Vcl.Forms,
  Unit1_4 in 'Unit1_4.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
