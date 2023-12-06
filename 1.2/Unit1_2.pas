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
    SaveDialog1: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure StringGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure StringGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure N6Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure N5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  DataSaved: Boolean = false;

implementation

{$R *.dfm}

uses Unit1_2_1, Unit1_2_2;

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
    N3.Enabled := True;
end;

procedure TForm1.FormClick(Sender: TObject);
begin
    ActiveControl := Nil;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
Var
    Key: Integer;
Begin
    Key := Application.Messagebox('Вы уверены, что хотите закрыть набор записей?', 'Выход', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);
    If Key = ID_NO Then
        CanClose := False
    Else
    Begin
        If DataSaved Or (Button1.Enabled = true) Then
        Begin
            If Key = ID_NO Then
                CanClose := False
        End
        Else
            If Button1.Enabled = false Then
            Begin
                Key := Application.Messagebox('Вы не сохранили результат. Хотите сделать это?', 'Сохранение',
                    MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);
                If Key = ID_YES Then
                    N5.Click;
            End;
    End;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    StringGrid1.Enabled := false;
    defultGrid();
    N2.Enabled := false;
    N3.Enabled := false;
end;

procedure TForm1.Label1Click(Sender: TObject);
begin
    ActiveControl := Nil;
end;

procedure TForm1.Label2Click(Sender: TObject);
begin
    ActiveControl := Nil;
end;

procedure TForm1.N1Click(Sender: TObject);
begin
    ActiveControl := Nil;
end;

Function IsCanWrite(FileWay: String): Boolean;
Var
    TestFile: TextFile;
Begin
    IsCanWrite := False;
    Try
        AssignFile(TestFile, FileWay);
        Try
            Rewrite(TestFile);
            IsCanWrite := True;
        Finally
            CloseFile(TestFile);
        End;
    Except
        MessageBox(0, 'Невозможна запись в файл!', 'Ошибка', MB_ICONERROR);
    End;
End;

Procedure WritingInFile(var MyFile : TextFile);
var
  I: Integer;
begin
    Writeln(MyFile, ' _____________________');
    Writeln(MyFile, '|          |          |');
    Writeln(MyFile, '| Вес (г)  | Цена (р) |');
    Writeln(MyFile, '|__________|__________|');
    Writeln(MyFile, '|          |          |');
    for I := 1 to Form1.StringGrid1.RowCount - 1 do
    begin
        var temp1 := Form1.StringGrid1.Cells[0,I];
        var temp2 := Form1.StringGrid1.Cells[1,I];
        Writeln(MyFile, '| ', temp1:6, '   | ', temp2:6, '   |');
    end;
    Writeln(MyFile, '|__________|__________|');
end;

Procedure InputInFile(IsCorrect: Boolean; FileName: String);
Var
    MyFile: TextFile;
Begin
    If IsCorrect Then
    Begin
        DataSaved := True;
        AssignFile(MyFile, FileName, CP_UTF8);
        ReWrite(MyFile);
        WritingInFile(MyFile);
        Close(MyFile);
    End;
End;

procedure TForm1.N3Click(Sender: TObject);
Var
    IsCorrect: Boolean;
Begin
    Repeat
        If SaveDialog1.Execute Then
        Begin
            IsCorrect := IsCanWrite(SaveDialog1.FileName);
            InputInFile(IsCorrect, SaveDialog1.FileName);
        End
        Else
            IsCorrect := True;
    Until IsCorrect;
end;

procedure TForm1.N5Click(Sender: TObject);
begin
    Form1.Close;
end;

procedure TForm1.N6Click(Sender: TObject);
begin
    ActiveControl := Nil;
    Form2.ShowModal;
end;

procedure TForm1.N7Click(Sender: TObject);
begin
    ActiveControl := Nil;
    Form3.ShowModal;
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
