Unit Unit2_1;

Interface

Uses
    Winapi.Windows,
    Winapi.Messages,
    System.SysUtils,
    System.Variants,
    System.Classes,
    Vcl.Graphics,
    Vcl.Controls,
    Vcl.Forms,
    Vcl.Dialogs,
    Vcl.StdCtrls,
    Vcl.Grids,
    Vcl.Menus;

Type
    TForm1 = Class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    Label3: TLabel;
    StringGrid1: TStringGrid;
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
        Procedure FormCreate(Sender: TObject);
        Procedure Label2Click(Sender: TObject);
        Procedure Label1Click(Sender: TObject);
        Procedure FormClick(Sender: TObject);
        Procedure Edit1Change(Sender: TObject);
        Procedure Edit1ContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
        Procedure Edit1Click(Sender: TObject);
        Procedure Edit1KeyPress(Sender: TObject; Var Key: Char);
        Procedure Edit1KeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure Button1Click(Sender: TObject);
        Procedure StringGrid1KeyPress(Sender: TObject; Var Key: Char);
        Procedure StringGrid1KeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
    procedure Button2Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure StringGrid1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure N4Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure N6Click(Sender: TObject);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    Form1: TForm1;
    DataSaved: Boolean = False;

Implementation

{$R *.dfm}

uses Unit2_1_1, Unit2_1_2;

Procedure StringGridRowMake();
Var
    I, J: Integer;
Begin
    Form1.StringGrid1.RowCount := StrToInt(Form1.Edit1.Text) + 1;
    For I := 1 To StrToInt(Form1.Edit1.Text) Do
    begin
        Form1.StringGrid1.Cells[0, I] := IntToStr(I);
        Form1.StringGrid1.Cells[1, I] := '';
        Form1.StringGrid1.Cells[2, I] := '';
    end;
End;

Procedure TForm1.Button1Click(Sender: TObject);
Begin
    StringGridRowMake();
    StringGrid1.Visible := True;
End;

function ResultMulti():string;
var
    I : Integer;
    Area:Real;
begin
    Area := 0.0;
    For I := 1 To Form1.StringGrid1.RowCount - 2 Do
        Area := Area + (StrToInt(Form1.StringGrid1.Cells[1, I]) * StrToInt(Form1.StringGrid1.Cells[2, I + 1])) - (StrToInt(Form1.StringGrid1.Cells[1, I + 1]) * StrToInt(Form1.StringGrid1.Cells[2, I]));

    Area := Abs(Area + (StrToInt(Form1.StringGrid1.Cells[1, Form1.StringGrid1.RowCount - 1]) * StrToInt(Form1.StringGrid1.Cells[2, 1])) - (StrToInt(Form1.StringGrid1.Cells[1, 1]) * StrToInt(Form1.StringGrid1.Cells[2, Form1.StringGrid1.RowCount - 1])));
    Area := Area / 2;
    ResultMulti := FormatFloat('0.#####', Area);   
end;

function conditionCheck():boolean;
begin
    conditionCheck := true;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
    if conditionCheck() then
    begin
        Label3.Caption := 'Площадь многоугольника = ' + ResultMulti();
        N4.Enabled := True;

    end;
end;

Procedure TForm1.Edit1Change(Sender: TObject);
Begin
    Try
        StrToInt(Edit1.Text);
        Button1.Enabled := True;
    Except
        Button1.Enabled := False;
    End;

End;

Procedure TForm1.Edit1Click(Sender: TObject);
Begin
    Edit1.SelStart := Length(Edit1.Text);
End;

Procedure TForm1.Edit1ContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := True;
End;

Function CheckDelete(Tempstr: Tcaption; Cursor: Integer): Boolean;
Begin
    Delete(Tempstr, Cursor, 1);
    If (Length(TempStr) >= 2) And (Tempstr[1] = '0') Then
        CheckDelete := False
    Else
        CheckDelete := True;
End;

Procedure TForm1.Edit1KeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    TEdit(Sender).ReadOnly := (SsShift In Shift) Or (SsCtrl In Shift);

    If Key = VK_DELETE Then
        Key := 0;

    If (Key = VK_BACK) And (Edit1.SelText <> '') Then
    Begin
        Var
        Temp := Edit1.Text;
        Edit1.ClearSelection;
        If (Length(Edit1.Text) >= 2) And (Edit1.Text[1] = '0') Then
        Begin
            Edit1.Text := Temp;
            Edit1.SelStart := Edit1.SelStart + 1;
            StringGrid1.Visible := False;
        End;
        Key := 0;
    End;

    If (Key = VK_BACK) Then
    Begin
        Var
        Tempstr := Edit1.Text;
        Var
        Cursor := Edit1.SelStart;
        If CheckDelete(Tempstr, Cursor) Then
        Begin
            Delete(Tempstr, Cursor, 1);
            Edit1.Text := Tempstr;
            Edit1.SelStart := Cursor - 1;
            StringGrid1.Visible := False;
        End;
        Key := 0;
    End;

    If Key = VK_DOWN Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);
End;

Procedure TForm1.Edit1KeyPress(Sender: TObject; Var Key: Char);
Begin
    StringGrid1.Visible := False;

    If (Key = '0') And (Edit1.SelStart = 0) Then
        Key := #0;

    If Not(Key In ['0' .. '9']) Then
        Key := #0;

    If (Key <> #0) And (Edit1.SelText <> '') Then
        Edit1.ClearSelection
    Else
        If (Length(Edit1.Text) >= 3) Then
            Key := #0;
End;

Procedure DefultStringGrid();
Begin
    Form1.StringGrid1.Cells[0, 0] := 'Вершина';
    Form1.StringGrid1.Cells[1, 0] := 'X';
    Form1.StringGrid1.Cells[2, 0] := 'Y';
    Form1.StringGrid1.ColCount := 3;
End;

Procedure TForm1.FormClick(Sender: TObject);
Begin
    ActiveControl := Nil;
End;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
Var
    Key: Integer;
Begin
       Key := Application.Messagebox('Вы уверены, что хотите закрыть набор записей?', 'Выход', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);

    If Key = ID_NO Then
        CanClose := False;

    If (Label3.Caption <> '') And (Key = ID_YES) And Not DataSaved Then
    Begin
        Key := Application.Messagebox('Вы не сохранили результат. Хотите сделать это?', 'Сохранение',
            MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);

        If Key = ID_YES Then
            N3.Click
    End;
end;

Procedure TForm1.FormCreate(Sender: TObject);
Begin
    Edit1.Text := '';
    Button1.Enabled := False;
    Button2.Enabled := False;
    StringGrid1.Visible := False;
    DefultStringGrid();
    label3.Caption := '';
    N4.Enabled := false;
End;

Procedure TForm1.Label1Click(Sender: TObject);
Begin
    ActiveControl := Nil;
End;

Procedure TForm1.Label2Click(Sender: TObject);
Begin
    ActiveControl := Nil;
End;

procedure TForm1.N2Click(Sender: TObject);
begin
    ActiveControl := Nil;
    Form2.ShowModal;
    Form2.Free;
end;

Function TryRead(Var TestFile: TextFile): Boolean;
Var
    Signal: Boolean;
    TempSize, TestInt: INteger;
    I: Integer;
Begin
    Signal := True;
    Readln(TestFile, TempSize);
    If (TempSize > 2) And (TempSize < 1000) Then
    Begin
        For I := 1 To TempSize Do
        Begin
            Read(TestFile, TestInt);
            If Not((TestInt > -10000000) And (TestInt < 1000000)) Then
                Signal := False;

            Read(TestFile, TestInt);
            If Not((TestInt > -10000000) And (TestInt < 1000000)) Then
                Signal := False;
        End;
    End
    Else
        Signal := False;

    TryRead := Signal;
End;

Function IsCanRead(FileWay: String): Boolean;
Var
    TestFile: TextFile;
Begin
    IsCanRead := False;
    Try
        AssignFile(TestFile, FileWay, CP_UTF8);
        Try
            Reset(TestFile);
            IsCanRead := TryRead(TestFile);
        Finally
            Close(TestFile);
        End;
    Except
        MessageBox(0, 'Невозможно чтение из файл!', 'Ошибка', MB_ICONERROR);
    End;
End;

Procedure InputMassive(Var MyFile: TextFile; Size: Integer);
Var
    I, Count: Integer;
Begin
    For I := 1 To Size Do
    Begin
        Read(MyFile, Count);
        Form1.StringGrid1.Cells[1, I] := IntToStr(Count);
        Read(MyFile, Count);
        Form1.StringGrid1.Cells[2, I] := IntToStr(Count);
    End;
    Form1.Button2.Enabled := True;
End;

Procedure ReadingPros(Var MyFile: TextFile);
Var
    Size: Integer;
Begin
    Readln(MyFile, Size);
    Form1.Edit1.Text := IntToStr(Size);
    Form1.Button1.Click;
    InputMassive(MyFile, Size);
End;

Procedure ReadFromFile(IsCorrect: Boolean; FileWay: String);
Var
    MyFile: TextFile;
Begin
    If Not IsCorrect Then
        MessageBox(0, 'Данные в выбранном файле не корректны!', 'Ошибка', MB_ICONERROR)
    Else
    Begin
        AssignFile(MyFile, FileWay);
        Reset(MyFile);
        ReadingPros(MyFile);
        Close(Myfile);
    End;
End;
        
procedure TForm1.N3Click(Sender: TObject);
Var
    IsCorrect: Boolean;
Begin
    Repeat
        If OpenDialog1.Execute() Then
        Begin
            IsCorrect := IsCanRead(OpenDialog1.FileName);
            ReadFromFile(IsCorrect, OpenDialog1.FileName);
        End
        Else
            IsCorrect := True;
    Until IsCorrect;
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

Procedure InputInFile(IsCorrect: Boolean; FileName: String);
Var
    MyFile: TextFile;
Begin
    If IsCorrect Then
    Begin
        DataSaved := True;
        AssignFile(MyFile, FileName, CP_UTF8);
        ReWrite(MyFile);
        Writeln(MyFile, Form1.Label3.Caption);
        Close(MyFile);
    End;
End;

procedure TForm1.N4Click(Sender: TObject);
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

procedure TForm1.N6Click(Sender: TObject);
begin
    Form1.Close;
end;

procedure TForm1.N7Click(Sender: TObject);
begin
    ActiveControl := Nil;
    Form3.ShowModal;
    Form3.Free;
end;

Procedure NextCell(Row, Col: Integer);
Begin
    If Col = 1 Then
        Form1.StringGrid1.Col := Col + 1
    Else
        If Row < Form1.StringGrid1.RowCount - 1 Then
        Begin
            Form1.StringGrid1.Row := Row + 1;
            Form1.StringGrid1.Col := Col - 1;
        End;
End;

Procedure CheckCellLen(Row, Col: Integer; Var Key: Char);
Var
    MinCount: Integer;
Begin
    If (Length(Form1.StringGrid1.Cells[Col, Row]) > 2) And (Form1.StringGrid1.Cells[Col, Row][1] = '-') Then
        MinCount := 1
    Else
        MinCount := 0;

    If Length(Form1.StringGrid1.Cells[Col, Row]) >= 5 + MinCount Then
        Key := #0;
End;

Procedure DeleteElInCell(Row, Col: Integer; Var Key: Char);
Var
    TempString: String;
Begin
    TempString := Form1.StringGrid1.Cells[Col, Row];
    Delete(TempString, Length(TempString), 1);
    Form1.StringGrid1.Cells[Col, Row] := TempString;
    If TempString = '' Then
        Form1.Button2.Enabled := False;
    Key := #0;
End;

Procedure TForm1.StringGrid1KeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    If (Key = VK_BACK) Then
    Begin
        Var
        Tempstr := StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row];
        Delete(Tempstr, Length(Tempstr), 1);
        StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row] := Tempstr;
        Key := 0;
    End;
End;

Procedure TForm1.StringGrid1KeyPress(Sender: TObject; Var Key: Char);
Const
    ValidValues: Set Of AnsiChar = ['0' .. '9'];
Var
    Minus : Integer;
Begin
    If (Key = '-') And (Length(StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row]) <> 0) Then
        Key := #0;

    If (Length(StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row]) = 0) And (Key = '0') Then
        Key := #0;

    If Not((Key In ['0' .. '9']) Or (Key = '-')) Then
        Key := #0;

    If (Length(StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row]) >= 1) And
        (StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row][1] = '-') Then
        Minus := 1
    Else
        Minus := 0;

    If (Length(StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row]) >= 6 + Minus) Then
        Key := #0;

    If (Key <> #0) Then
        StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row] := StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row] + Key;
End;

procedure TForm1.StringGrid1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
Var
    I, J: Integer;
Begin
    Try
        For I := 1 To 2 Do
            For J := 1 To StrToInt(Edit1.Text) Do
                StrToInt(StringGrid1.Cells[I, J]);

        Button2.Enabled := True;
    Except
        Button2.Enabled := False;
    End;
end;

End.
