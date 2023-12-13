program Project3_2;

uses
  Vcl.Forms,
  Unit3_2 in 'Unit3_2.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
