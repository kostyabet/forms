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
    InstractionLabel.Caption := 'Инструкция:' + 
    #13#10 + '1. Введите количество N чисел последовательности.' + 
    #13#10 + '   N находится в пределах от 1 до 999;' + 
    #13#10 + '2. Нажмите кнопку ''Ввести числа последовательности'';' + 
    #13#10 + '3. Вводите ваши числа.' + 
    #13#10 + '   Числа должны быть в диапазоне [-999999;999999];' + 
    #13#10 + '4. Нажимайте кнопку ''Рассчитать результат''.' + #13#10 + 
    #13#10 + 'Дополнительные инструкции для файла:' + 
    #13#10 + '1. Первое число в файле - размер последоватльности;' + 
    #13#10 + '2. Далее идут числа последовательности;' + 
    #13#10 + 'Если числа нет, то оно будет заменено на 0!' + 
    #13#10 + '!!Между числами допускается не более 4-ёх побелов!!' + 
    #13#10 + '*Файл должен быть формата .txt!!!*';
End;

End.
