unit Unit1_2;

interface

uses
  Clipbrd, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls, Vcl.Grids;

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
    Button1: TButton;
    StringGrid1: TStringGrid;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure StringGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure StringGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure createGrid();
const
    Mith:Integer = 50;
    ONEKILOCOST: Integer = 280;
    GRAMINKILO: Integer = 1000;
var
    i:integer;
begin
    for I := 1 to 20 do
    begin
        Form1.StringGrid1.Cells[0, I] := IntToStr(I * Mith); 
        Form1.StringGrid1.Cells[1, I] := IntToStr((I * Mith * ONEKILOCOST) Div (GRAMINKILO));    
    end;
end;

procedure defultGrid();
begin
    Form1.StringGrid1.RowCount := 21;
    Form1.StringGrid1.ColCount := 2;
    Form1.StringGrid1.Cells[0,0] := 'Вес (г)';
    Form1.StringGrid1.Cells[1,0] := 'Цена (р)';
    
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
    Button1.Enabled := false;
    createGrid();
    StringGrid1.Options := StringGrid1.Options + [goEditing, goAlwaysShowEditor];
    StringGrid1.Enabled := true;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    StringGrid1.Enabled := false;
    defultGrid();
end;

procedure TForm1.StringGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if (Shift = [ssCtrl]) and (Key = Ord('C')) then
    begin
        Clipboard.AsText := StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row];
        Label2.Caption := 'число ''' + StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row] + ''' скопировано в буфер обмена.';
    end;
    if not ((Key = VK_UP) or (Key = VK_DOWN)) then
        Key := 0;
end;

procedure TForm1.StringGrid1KeyPress(Sender: TObject; var Key: Char);
begin
    if (Key = #13) and (StringGrid1.Row < StringGrid1.RowCount - 1) then
        StringGrid1.Row := StringGrid1.Row + 1;        
    Key := #0;
end;

end.
