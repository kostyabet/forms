program Project2_1;

uses
  Vcl.Forms,
  Unit2_1 in 'Unit2_1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
