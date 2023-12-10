unit Unit2_3_1;

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
    Label1.caption := 'Инструкция:' + 
    #13#10 + '1. Введите натуральное число в' + 
    #13#10 + '   диапазоне [1; 999999999];' +
    #13#10 + '2. Нажимайте кнопку и смотрите на' +
    #13#10 + '   результат.' + #13#10 +
    #13#10 + 'Доп. инструкции для файла:' +
    #13#10 + '1. В файле первым находится число' +
    #13#10 + '   которое необходимо оценить;' +
    #13#10 + '2. Файл должен быть формата .txt!';
end;

end.
