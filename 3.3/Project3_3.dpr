program Project3_3;

uses
  Vcl.Forms,
  Unit3_3 in 'Unit3_3.pas' {Form1},
  Unit3_3_1 in 'Unit3_3_1.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
