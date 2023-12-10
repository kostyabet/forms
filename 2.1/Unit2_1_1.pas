unit Unit2_1_1;

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
    Label1.Caption := '*многгоугольник быть без самопересечений!!!*' + 
    #13#10 + #13#10 + 'Инструкция:' + 
    #13#10 + '1. Введите N в пределах от 3 до 99;' +
    #13#10 + '2. Нажмите кнопку формирования таблицы' + 
    #13#10 + '   для ввода координат вершин;' +
    #13#10 + '3. Нажмите кнопку рассчёта площади.' + #13#10 +
    #13#10 + 'Инструкции для файла:' +
    #13#10 + '1. Первое число в файле это колличество вершин.' +
    #13#10 + '2. Дальше идук координаты вершин в' + 
    #13#10 + '   последовательности x1 y1 x2 y2 .. xn yn';
end;

end.
