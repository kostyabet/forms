unit Unit1_3_1;

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
    #13#10 + '1. Точность EPS должна быть в пределах (0,1; 0,000001];' + 
    #13#10 + '2. X - число в пределах (-1000000; 1000000);' +
    #13#10 + '3. EPS нужно писать через '',''.' + #13#10 +
    #13#10 + 'Дополнительные инструкции для файла:' +
    #13#10 + '1. EPS пишется первым;' +
    #13#10 + '2. После EPS пишется Х.';
end;

end.
