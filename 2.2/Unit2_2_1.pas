unit Unit2_2_1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm2 = class(TForm)
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.FormCreate(Sender: TObject);
begin
    label1.Caption := 'Инструкции:' + 
    #13#10 + '1. K - строго натуральное число;' +
    #13#10 + '2. К находится в пределах от [1;10000).' + 
    #13#10 + '3. После того, как вы ввели К, нажимайте кнопку K.' + #13#10 +
    #13#10 + 'Дополнительные инструкции для файла:' + 
    #13#10 + '1. Файл должен быть формата *.txt.';
end;

end.
