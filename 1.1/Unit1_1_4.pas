unit Unit1_1_4;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm5 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

{$R *.dfm}

uses Unit1_1;


procedure TForm5.Button1Click(Sender: TObject);
begin
    Close;
    Form1.Close;
end;

procedure TForm5.Button2Click(Sender: TObject);
begin
    Form5.close;
end;

procedure TForm5.FormCreate(Sender: TObject);
begin
    label1.Caption := 'Вы действительно хотите выйти?';
    button1.Caption := 'Да';
    button2.Caption := 'Нет'; 
end;

end.
