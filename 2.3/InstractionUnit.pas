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
    InstractionLabel.Caption := 'Инструкция:' + #13#10 + '1. Введите натуральное число в' + #13#10 + '   диапазоне [-999999999; 999999999];'
        + #13#10 + '2. Нажимайте кнопку и смотрите на' + #13#10 + '   результат.' + #13#10 + #13#10 + 'Доп. инструкции для файла:' + #13#10
        + '1. В файле первым находится число' + #13#10 + '   которое необходимо оценить;' + #13#10 + '2. Файл должен быть формата .txt!';
End;

End.
