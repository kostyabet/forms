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
    InstractionLabel.Caption := 'Инструкция: ' + 
    #13#10 + '1. Введите номер вхождения K.' + 
    #13#10 + '   Коэффициент K находится в пределах [1..50];' +
    #13#10 + '2. Введите подстроку st1;' + 
    #13#10 + '3. Введите основную строку st2.' + #13#10 +
    #13#10 + 'Инструкция для файла:' +
    #13#10 + '1. Первая строка файла - K;' +
    #13#10 + '2. Вторая строка - st1;' +
    #13#10 + '3. Третья строка - st2.' +
    #13#10 + 'Файл должен быть строго формата .txt!';
end;

end.
