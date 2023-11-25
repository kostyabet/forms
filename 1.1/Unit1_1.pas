unit Unit1_1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ToolWin, Vcl.ComCtrls, Vcl.Menus,
  Vcl.StdCtrls;

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
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    procedure N4Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}







procedure TForm1.N2Click(Sender: TObject);
var
    TextBox : PWideChar;
begin
      
end;

procedure TForm1.N4Click(Sender: TObject);
begin
    if OpenDialog1.Execute() then begin
        // имя выбранного файла в OpenDialog1.FileName
        MessageBox(Handle, PChar(OpenDialog1.FileName), 'open', MB_OK);
    end else begin
        MessageBox(Handle, '[Отмена]', 'open', MB_OK);
    end;
end;

end.
