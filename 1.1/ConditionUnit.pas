unit ConditionUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TInstraction = class(TForm)
    Label1: TLabel;
    
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
    Label1.Caption := '1. Введите свой пол: ' + #13#10#9 + 
        '''м'' - если вы мужчина' + #13#10#9 + 
        '''ж'' - если вы женщина' + #13#10 +
        'Разрешается писать только в нижнем регистре.' + #13#10 +
        '2. Введите свой возраст. Он должен быть от 18 до 59' + #13#10 + 
        '3. Нажмите кнопку рассчитать, чтобы ' + #13#10 +
        'узнать возраст своей идеальной второй половинки.' + #13#10#10 +
        'Инструкции для файла: ' + #13#10 +
        '1. Формат файла должен быть .txt' + #13#10 +
        '2. Первый элемент файла - символ(ваш пол). ' + #13#10 +
        '3. Далее идёт цифра(ваш возраст).';
end;

end.
