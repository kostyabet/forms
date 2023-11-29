unit Unit1_3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
    Label1.Font.Style := Label1.Font.Style + [FsBold];
    Label1.Caption := 'Программа вычисляет значение кубического корня с точностью' + 
                      #13#10 + 'EPS с использованием итерационной формулы Ньютона.';
    Image1.Picture.LoadFromFile('foto.jpg');
end;



end.
