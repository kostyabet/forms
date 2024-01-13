Unit ConditionUnit;

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
        ConditionLabel: TLabel;

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
    ConditionLabel.Caption := '1. Введите свой пол: ' + #13#10#9 + '''м'' - если вы мужчина;' + #13#10#9 + '''ж'' - если вы женщина;' +
        #13#10 + 'Разрешается писать только в нижнем регистре.' + #13#10 + '2. Введите свой возраст.' + #13#10 +
        '    Он должен быть от 18 до 59;' + #13#10 + '3. Нажмите кнопку рассчитать, чтобы ' + #13#10 +
        '    узнать возраст своей идеальной второй половинки.' + #13#10#10 + 'Дополнительные инструкции для файла: ' + #13#10 +
        '1. Первый элемент файла - символ(ваш пол);' + #13#10 + '2. Далее идёт цифра(ваш возраст).' + #13#10 +
        '*Формат файла должен быть строго .txt!!!*';
End;

End.
