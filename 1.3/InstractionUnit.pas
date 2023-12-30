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
    InstractionLabel.Caption := 'Инструкция:' + #13#10 + '1. Точность EPS должна быть в пределах (0,1; 0,000001];' + #13#10 +
        '2. X - число в пределах (-1000000; 1000000);' + #13#10 + '3. EPS нужно писать через '',''.' + #13#10 + #13#10 +
        'Дополнительные инструкции для файла:' + #13#10 + '1. EPS пишется первым и через ''.'';' + #13#10 +
        '2. После EPS пишется Х.' + #13#10 + '*Файл должен быть строго .txt!!!*';
End;

End.
