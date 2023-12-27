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
    InstractionLabel.Caption := '*многоугольник должен быть без ' + #13#10 + #9#9#9 + 'самопересечений!!!*' + 
    #13#10 + #13#10 + 'Инструкция:' + 
    #13#10 + '1. Введите N в пределах от 3 до 99;' +
    #13#10 + '2. Нажмите кнопку формирования таблицы' + 
    #13#10 + '   для ввода координат вершин;' +
    #13#10 + '3. Нажмите кнопку рассчёта площади.' + #13#10 +
    #13#10 + 'Инструкции для файла:' +
    #13#10 + '1. Первое число в файле это колличество вершин.' +
    #13#10 + '2. Дальше идут координаты вершин в' + 
    #13#10 + '   последовательности x1 y1 x2 y2 .. xn yn';
end;

end.
