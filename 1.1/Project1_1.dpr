program Project1_1;

uses
  Vcl.Forms,
  Unit1_1 in 'Unit1_1.pas' {Form1},
  Unit1_1_1 in 'Unit1_1_1.pas' {Form2},
  Unit1_1_2 in 'Unit1_1_2.pas' {Form3},
  Unit1_1_3 in 'Unit1_1_3.pas' {Form4},
  Unit1_1_4 in 'Unit1_1_4.pas' {Form5};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TForm5, Form5);
  Application.Run;
end.
