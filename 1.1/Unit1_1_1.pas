unit Unit1_1_1;

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
    Label1.Caption := '1. Введите свой пол: ' + #13#10#9 + '''M'' - если вы мужчина' + #13#10#9 + '''Ж'' - если вы женщина' + #13#10 +
        '2. Введите свой возраст. Он должен быть от 18 до 99' + #13#10 + '3. Нажмите кнопку рассчитать, чтобы ' + #13#10 +
        'узнать возрост своей идеальной второй половинки.';
end;

end.
