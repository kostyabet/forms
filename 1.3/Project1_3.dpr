program Project1_3;

uses
  Vcl.Forms,
  Unit1_3 in 'Unit1_3.pas' {Form1},
  Unit1_3_1 in 'Unit1_3_1.pas' {Form2},
  Unit1_3_2 in 'Unit1_3_2.pas' {Form3};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
