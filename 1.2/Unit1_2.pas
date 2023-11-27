unit Unit1_2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    Label1: TLabel;
    ListBox1: TListBox;
    SaveDialog1: TSaveDialog;
    procedure N2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure N5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses Unit1_2_1, Unit1_2_2;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
    If MessageDlg('Вы уверены, что хотите закрыть набор записей?', MtConfirmation, [MbYes, MbNo], 0) = MrNo Then
        CanClose := False;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    Label1.Font.Style := Label1.Font.Style + [FsBold];
    label1.Caption := 'Программа выводит таблицу стоимости порций сыра'+
                      #13#10+'весом 50, 100, 150, ..., 1000 г (цена 1кг 280р.)';
    N4.Enabled := False;
end;

procedure TForm1.N2Click(Sender: TObject);
begin
    Form2.ShowModal;
end;

procedure TForm1.N3Click(Sender: TObject);
begin
    Form3.ShowModal;
end;

procedure TForm1.N5Click(Sender: TObject);
begin
    if SaveDialog1.Execute() then
    begin
    
    end;
end;

procedure TForm1.N7Click(Sender: TObject);
begin
    Form1.close;
end;

end.
