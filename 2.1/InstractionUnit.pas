Unit InstractionUnit;

Interface

Uses
    Winapi.Windows,
    Winapi.Messages,
    System.SysUtils,
    System.Variants,
    System.Classes,
    Vcl.Graphics,
    Vcl.Controls,
    Vcl.Forms,
    Vcl.Dialogs,
    Vcl.StdCtrls;

Type
    TInstraction = Class(TForm)
        InstractionLabel: TLabel;
        Procedure FormCreate(Sender: TObject);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    Instraction: TInstraction;

Implementation

{$R *.dfm}

Procedure TInstraction.FormCreate(Sender: TObject);
Begin
    InstractionLabel.Caption := '*многоугольник должен быть без самопересечений!!!*' + 
    #13#10 + 
    #13#10 + 'Инструкция:' + 
    #13#10 + '1. Введите кол-во вершин (N) в диапазоне [3, 99];' + 
    #13#10 + '2. Нажмите кнопку формирования таблицы' +
    #13#10 + '   для ввода координат вершин;' + 
    #13#10 + '   Координаты - целые числа в пределах ' + 
    #13#10 + #9#9#9#9 + '(-10000;10000)' + 
    #13#10 + '3. Нажмите кнопку расчёта площади.' + #13#10 + 
    #13#10 + 'Дополнительные инструкции для файла:' + 
    #13#10 + '1. Первое число в файле это количество вершин.' + 
    #13#10 + '2. Дальше идут координаты вершин в' + 
    #13#10 + '   последовательности x1 y1 x2 y2 .. xn yn' + 
    #13#10 + '!!Между числами допускается не более 4-ёх побелов!!' + 
    #13#10 + '*Файл должен быть строго формата .txt!!!*';
End;

End.
