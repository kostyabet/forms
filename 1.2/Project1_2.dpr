program Project1_2;

uses
  Vcl.Forms,
  Unit1_2 in 'Unit1_2.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
