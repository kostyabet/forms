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
    InstractionLabel.Caption := 'Инструкция:' + 
    #13#10 + '1. Введите размер массива N от 1 до 99;' +
    #13#10 + '2. Нажмите кнопку для ввода значений;' +
    #13#10 + '3. Введите числа в ячейки массива;' +
    #13#10 + '   (-1 000 000; 1 000 000)' +
    #13#10 + '4. Нажмите на кнопку ''Отсортировать''.' + #13#10 +
    #13#10 + 'Доп. Инструкции для файла:' + 
    #13#10 + '1. Первым в файле идёт N;' +
    #13#10 + '2. Затем идут все значения массива.' +
    #13#10 + '*Файл строго формата .txt*';
end;

end.
