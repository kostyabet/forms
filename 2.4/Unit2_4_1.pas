unit Unit2_4_1;

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
    Label1.Caption := 'Инструкция:'+
    #13#10 + '1. Введите количество N чисел последовательности;' +
    #13#10 + '2. Нажмите кнопку ''Ввести числа последовательности'';' +
    #13#10 + '3. Вводите ваши числа;' + 
    #13#10 + '4. Нажимайте кнопку ''Рассчитать результат''.' + #13#10 +
    #13#10 + 'Дополнительные инструкции для файла:' + 
    #13#10 + '1. Первое число в файле - размер последоватльности;' + 
    #13#10 + '2. Далее идут числа последовательности;' + 
    #13#10 + '3. Файл должен быть формата .txt!!!';
end;

end.
