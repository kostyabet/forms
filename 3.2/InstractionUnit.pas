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
    InstractionLabel.Caption := 'Инструкция:' + #13#10 + '1. Напишите вашу последовательность символов;' + #13#10 +
        '2. Нажмите кнопку ''Сформировать множество'';' + #13#10 + #13#10 + 'Дополнительные инструкции для файла' + #13#10 +
        '1. В файле сразу идёт ваша строка;' + #13#10 + '*Файл должен быть строго формата .txt!!!*';
End;

End.
