Unit Unit2_2;

Interface

Uses
    Clipbrd,
    Winapi.Windows,
    Winapi.Messages,
    System.SysUtils,
    System.UITypes,
    System.Variants,
    System.Classes,
    Vcl.Graphics,
    Vcl.Controls,
    Vcl.Forms,
    Vcl.Dialogs,
    Vcl.StdCtrls,
    Vcl.Menus,
    Vcl.Grids,
    Vcl.MPlayer;

Type
    TForm1 = Class(TForm)
        MainMenu1: TMainMenu;
        N1: TMenuItem;
        N2: TMenuItem;
        N3: TMenuItem;
        N4: TMenuItem;
        N5: TMenuItem;
        N6: TMenuItem;
        N7: TMenuItem;
        Label1: TLabel;
        Label2: TLabel;
        Edit1: TEdit;
        Button1: TButton;
        SaveDialog1: TSaveDialog;
        OpenDialog1: TOpenDialog;
        StringGrid1: TStringGrid;
        Label3: TLabel;
        Procedure FormCreate(Sender: TObject);
        Procedure Edit1ContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
        Procedure Edit1Change(Sender: TObject);
        Procedure Label2Click(Sender: TObject);
        Procedure Label1Click(Sender: TObject);
        Procedure N1Click(Sender: TObject);
        Procedure N6Click(Sender: TObject);
        Procedure N7Click(Sender: TObject);
        Procedure FormClick(Sender: TObject);
        Procedure Edit1KeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure Edit1KeyPress(Sender: TObject; Var Key: Char);
        Procedure Button1Click(Sender: TObject);
        Procedure N2Click(Sender: TObject);
        Procedure N3Click(Sender: TObject);
        Procedure FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
        Procedure N5Click(Sender: TObject);
        Procedure StringGrid1KeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    Form1: TForm1;
    DataSaved: Boolean = False;
    MAX_N: Integer = 1000000;
    Error: Integer = 0;

Implementation

{$R *.dfm}

Uses
    Unit2_2_1,
    Unit2_2_2;

Function SumOfDigits(Num: Integer): Integer;
Var
    Sum: Integer;
Begin
    Sum := 0;
    While (Num >= 1) Do
    Begin
        Sum := Sum + (Num Mod 10);
        Num := Num Div 10;
    End;
    SumOfDigits := Sum;
End;

Function CheckSum(Sum: Integer; K: Integer; NutNumb: Integer): Boolean;
Begin
    If K * Sum = NutNumb Then
        CheckSum := True
    Else
        CheckSum := False;
End;

Procedure SearchNum(K: Integer);
Var
    Sum, NutNumb, I: Integer;
Begin
    Form1.StringGrid1.Cells[0, 0] := 'Числа';
    Form1.StringGrid1.RowCount := 1;
    NutNumb := K;
    I := 1;
    While (NutNumb <= MAX_N) Do
    Begin
        Sum := SumOfDigits(NutNumb);
        If (CheckSum(Sum, K, NutNumb)) Then
        Begin
            Form1.StringGrid1.Cells[I, 0] := IntToStr(NutNumb);
            Inc(I);
        End;
        NutNumb := NutNumb + K;
    End;
    Form1.StringGrid1.ColCount := I;
End;

Procedure TForm1.Button1Click(Sender: TObject);
Begin
    SearchNum(StrToInt(Edit1.Text));
    N3.Enabled := True;
    StringGrid1.Visible := True;
    Label3.Visible := True;
End;

Procedure TForm1.Edit1Change(Sender: TObject);
Begin
    Try
        StrToInt(Edit1.Text);
        Button1.Enabled := True;
    Except
        Button1.Enabled := False;
    End;
End;

Function CheckDelete(Tempstr: Tcaption; Cursor: Integer): Boolean;
Begin
    Delete(Tempstr, Cursor, 1);
    If (Length(TempStr) >= 1) And (Tempstr[1] = '0') Then
        CheckDelete := False
    Else
        CheckDelete := True;
End;

Procedure TForm1.Edit1ContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := True;
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
        If (Length(Edit1.Text) >= 1) And (Edit1.Text[1] = '0') Then
        Begin
            Edit1.Text := Temp;
            Edit1.SelStart := Edit1.SelStart + 1;
            StringGrid1.Visible := False;
            Button1.Enabled := False;
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

    if (Edit1.SelText <> '') And (Key <> #0) then
        Edit1.ClearSelection;
        
    If Length(Edit1.Text) >= 4 Then
        Key := #0;
End;

Procedure TForm1.FormClick(Sender: TObject);
Begin
    ActiveControl := Nil;
End;

Procedure TForm1.FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
Var
    Key: Integer;
Begin
    Key := Application.Messagebox('Вы уверены, что хотите закрыть набор записей?', 'Выход', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);
    If Key = ID_NO Then
        CanClose := False
    Else
    Begin
        If DataSaved Or (StringGrid1.Cells[1, 0] = '') Then
        Begin
            If Key = ID_NO Then
                CanClose := False
        End
        Else
            If StringGrid1.Cells[1, 0] <> '' Then
            Begin
                Key := Application.Messagebox('Вы не сохранили результат. Хотите сделать это?', 'Сохранение',
                    MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);
                If Key = ID_YES Then
                    N3.Click;
            End;
    End;
End;

Procedure TForm1.FormCreate(Sender: TObject);
Begin
    Label1.Font.Style := Label1.Font.Style + [FsBold];
    Label1.Caption := 'Программа находит все натуральные числа,' + #13#10 + 'которые в k раз больше суммы своих цифр.';
    Label2.Caption := 'Введите коэфициент K: ';
    Button1.Caption := 'Рассчитать';
    Button1.Enabled := False;
    N3.Enabled := False;
    StringGrid1.Visible := False;
    Label3.Visible := False;
End;

Procedure TForm1.Label1Click(Sender: TObject);
Begin
    ActiveControl := Nil;
End;

Procedure TForm1.Label2Click(Sender: TObject);
Begin
    ActiveControl := Nil;
End;

Procedure TForm1.N1Click(Sender: TObject);
Begin
    ActiveControl := Nil;
End;

Function TryRead(Var TestFile: TextFile): Boolean;
Var
    BufferInt: Integer;
Begin
    Read(TestFile, BufferInt);
    If (BufferInt < 1) Or (BufferInt > 9999) Then
        TryRead := False
    Else
    Begin
        TryRead := True;
        Form1.Edit1.Text := IntToStr(BufferInt);
    End;
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
        Error := 1;
    End;
End;

Procedure TForm1.N2Click(Sender: TObject);
Var
    IsCorrect: Boolean;
Begin
    Repeat
        If OpenDialog1.Execute() Then
        Begin
            IsCorrect := IsCanRead(OpenDialog1.FileName);
            If Not(IsCorrect) And (Error = 0) Then
                MessageBox(0, 'Данные в выбранном файле не корректны!', 'Ошибка', MB_ICONERROR);
        End
        Else
            IsCorrect := True;
        Error := 0;
    Until IsCorrect;
End;

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
    I: Integer;
Begin
    If IsCorrect Then
    Begin
        DataSaved := True;
        AssignFile(MyFile, FileName, CP_UTF8);
        ReWrite(MyFile);
        For I := 1 To Form1.StringGrid1.ColCount - 1 Do
            Write(MyFile, Form1.StringGrid1.Cells[I, 0] + ' ');
        Close(MyFile);
    End;
End;

Procedure TForm1.N3Click(Sender: TObject);
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
End;

Procedure TForm1.N5Click(Sender: TObject);
Begin
    Form1.Close;
End;

Procedure TForm1.N6Click(Sender: TObject);
Begin
    ActiveControl := Nil;
    Form2.ShowModal;
End;

Procedure TForm1.N7Click(Sender: TObject);
Begin
    ActiveControl := Nil;
    Form3.ShowModal;
End;

Procedure TForm1.StringGrid1KeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    If (Shift = [SsCtrl]) And (Key = Ord('C')) Then
    Begin
        Clipboard.AsText := StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row];
        Label3.Caption := 'число ''' + StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row] + ''' скопировано в буфер обмена.';
    End;
    If Not((Key = VK_RIGHT) Or (Key = VK_LEFT)) Then
        Key := 0;
End;

End.
