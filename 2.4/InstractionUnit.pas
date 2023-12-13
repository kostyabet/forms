unit InstractionUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TInstraction = class(TForm)
    InstractionLabel: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Instraction: TInstraction;

implementation

{$R *.dfm}

procedure TInstraction.FormCreate(Sender: TObject);
begin
    InstractionLabel.Caption := 'Инструкция:'+
    #13#10 + '1. Введите количество N чисел последовательности.' +
    #13#10 + '   N находится в пределах от 1 до 999;'+
    #13#10 + '2. Нажмите кнопку ''Ввести числа последовательности'';' +
    #13#10 + '3. Вводите ваши числа;' + 
    #13#10 + '4. Нажимайте кнопку ''Рассчитать результат''.' + #13#10 +
    #13#10 + 'Дополнительные инструкции для файла:' + 
    #13#10 + '1. Первое число в файле - размер последоватльности;' + 
    #13#10 + '2. Далее идут числа последовательности;' + 
    #13#10 + '3. Файл должен быть формата .txt!!!';
end;

end.
