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
    InstractionLabel.Caption := 'Инструкция:' + #13#10 + '1. Введите размер массива N от 1 до 99;' + #13#10 +
        '2. Нажмите кнопку для ввода значений;' + #13#10 + '3. Введите числа в ячейки массива;' + #13#10 + '   (-1 000 000; 1 000 000)' +
        #13#10 + '4. Нажмите на кнопку ''Отсортировать''.' + #13#10 + #13#10 + 'Дополнительные инструкции для файла:' + #13#10 +
        '1. Первым в файле идёт N;' + #13#10 + '2. Затем идут все значения массива.' + #13#10 + 'Если подходящего значения не будет,' +
        #13#10 + 'то оно будет заменено на 0!' + #13#10 + '!!Между числами допускается не ' + #13#10 + '  более 4-ёх побелов!!' + #13#10 +
        '*Файл строго формата .txt!!!*';
End;

End.
