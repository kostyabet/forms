program Project2_2;

uses
  Vcl.Forms,
  Unit2_2 in 'Unit2_2.pas' {Form1},
  Unit2_2_1 in 'Unit2_2_1.pas' {Form2},
  Unit2_2_2 in 'Unit2_2_2.pas' {Form3};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
