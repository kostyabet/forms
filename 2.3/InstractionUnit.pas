unit InstractionUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TInstraction = class(TForm)
    InstractionLabel: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Instraction: TInstraction;

implementation

{$R *.dfm}

procedure TInstraction.FormCreate(Sender: TObject);
begin
    InstractionLabel.caption := 'Инструкция:' + 
    #13#10 + '1. Введите натуральное число в' + 
    #13#10 + '   диапазоне [-999999999; 999999999];' +
    #13#10 + '2. Нажимайте кнопку и смотрите на' +
    #13#10 + '   результат.' + #13#10 +
    #13#10 + 'Доп. инструкции для файла:' +
    #13#10 + '1. В файле первым находится число' +
    #13#10 + '   которое необходимо оценить;' +
    #13#10 + '2. Файл должен быть формата .txt!';
end;

end.
