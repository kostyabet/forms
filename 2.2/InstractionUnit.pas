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
    InstractionLabel.Caption := 'Инструкции:' + #13#10 + '1. K - строго натуральное число;' + #13#10 +
        '2. К находится в пределах от [1;9999];' + #13#10 + '3. После того, как вы ввели К,' + #13#10 +
        '   нажимайте кнопку ''рассчитать''.' + #13#10 + #13#10 + 'Дополнительные инструкции для файла:' + #13#10 +
        '1. В файле первым идёт сразу число K.' + #13#10 + '*Файл должен быть формата .txt!!!*';
End;

End.
