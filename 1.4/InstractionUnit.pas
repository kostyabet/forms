﻿Unit InstractionUnit;

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
    InstractionLabel.Caption := 'Инструкции:' + #13#10 + '1. Введите размер массива, он находится в' + #13#10 +
        '   пределах [0, 99] и является целым числом;' + #13#10 + '2. Затем нажимайте кнопку ''Создать массив''' + #13#10 +
        '3. Вводите числа в ваш массив, числа должны' + #13#10 + '   быть целыми и в пределах (-1000000;1000000);' + #13#10 +
        '4. Нажимайте кнопку расчитать.' + #13#10 + #13#10 + 'Дополнительные инструкции для файлов:' + #13#10 +
        '1. Первым идёт размер массива;' + #13#10 + '2. Затем идут все числа массива.' + #13#10 + 'Если цифры нет, то вместо неё ставится 0!' + #13#10 + '*Файл должен быть строго формата .txt!!!*';
End;

End.
