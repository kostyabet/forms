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
    InstractionLabel.Caption := 'Инструкция:' + 
    #13#10 + '1. Напишите вашу последовательность символов;' + 
    #13#10 + '2. Нажмите кнопку ''Сформировать множество'';' + 
    #13#10 + #13#10 + 'Инструкции для файла' +
    #13#10 + '1. В файле сразу идёт ваша строка;' + 
    #13#10 + '*Файл должен быть строго формата .txt*';
end;

end.
