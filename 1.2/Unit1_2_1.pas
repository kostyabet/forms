unit Unit1_2_1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm2 = class(TForm)
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.FormCreate(Sender: TObject);
begin
    Label1.Caption := 'Инструкция:' +
    #13#10 + '1. Нажмите кнопку рассчитать, чтобы' +
    #13#10 +'    увидеть таблицу соимости сыра.' + #13#10 +
    #13#10 + 'Инструкции для файла:' + 
    #13#10 + '1. Файл должен быть строго формата *.txt.';
end;

end.
