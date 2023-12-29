unit ConditionUnit;

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
    #13#10 + '1. Нажмите кнопку рассчитать, чтобы' +
    #13#10 +'    увидеть таблицу соимости сыра.' + #13#10 +
    #13#10 + 'Инструкции для файла:' + 
    #13#10 + '1. Файл для сохранения должен быть' + 
    #13#10 + '   строго формата *.txt.';
end;

end.
