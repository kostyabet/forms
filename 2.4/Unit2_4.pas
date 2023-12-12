Unit Unit2_4;

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
    Vcl.Menus,
    Vcl.Grids;

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
        StringGrid1: TStringGrid;
        Button1: TButton;
        Button2: TButton;
        Label3: TLabel;
        OpenDialog1: TOpenDialog;
        SaveDialog1: TSaveDialog;
        Procedure Label2Click(Sender: TObject);
        Procedure Label1Click(Sender: TObject);
        Procedure N6Click(Sender: TObject);
        Procedure N7Click(Sender: TObject);
        Procedure N1Click(Sender: TObject);
        Procedure N5Click(Sender: TObject);
        Procedure FormClick(Sender: TObject);
        Procedure Edit1Change(Sender: TObject);
        Procedure Edit1ContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
        Procedure Edit1KeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure Edit1KeyPress(Sender: TObject; Var Key: Char);
        Procedure Button1Click(Sender: TObject);
        Procedure Button2Click(Sender: TObject);
        Procedure Label3Click(Sender: TObject);
        Procedure N2Click(Sender: TObject);
        Procedure N3Click(Sender: TObject);
        Procedure FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
        Procedure StringGrid1KeyUp(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure StringGrid1KeyPress(Sender: TObject; Var Key: Char);
        Procedure StringGrid1KeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    Form1: TForm1;
    DataSaved: Boolean = False;
    Error: Integer = 0;

Implementation

{$R *.dfm}

Uses
    Unit2_4_1,
    Unit2_4_2;

Procedure TForm1.Button1Click(Sender: TObject);
Var
    I: Integer;
Begin
    StringGrid1.Cells[0, 0] := '№';
    StringGrid1.Cells[0, 1] := 'Число';
    StringGrid1.ColCount := StrToInt(Edit1.Text) + 1;
    For I := 1 To StringGrid1.ColCount - 1 Do
    Begin
        StringGrid1.Cells[I, 0] := IntToStr(I);
        StringGrid1.Cells[I, 1] := '';
    End;
    StringGrid1.Visible := True;
End;

Function IsArrIncreasing(): Boolean;
Var
    I: Integer;
    IsConditionYes: Boolean;
Begin
    IsConditionYes := True;

    For I := 2 To Form1.StringGrid1.ColCount - 1 Do
        If Not(Form1.StringGrid1.Cells[I, 1] <= Form1.StringGrid1.Cells[I - 1, 1]) Then
            IsConditionYes := False;

    IsArrIncreasing := IsConditionYes;
End;

Procedure TForm1.Button2Click(Sender: TObject);
Var
    Res: String;
Begin
    If IsArrIncreasing() Then
        Res := 'невозростающая.'
    Else
        Res := 'возростающая.';
    Label3.Caption := 'Числовая последовательност ' + Res;
    N3.Enabled := True;
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
            Button2.Enabled := False;
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
            Button2.Enabled := false;
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
    Button2.Enabled := false;

    If (Key = '0') And (Edit1.SelStart = 0) Then
        Key := #0;

    If Not(Key In ['0' .. '9']) Then
        Key := #0;

    if (Edit1.SelText <> '') And (Key <> #0) then
        Edit1.ClearSelection;
        
    If Length(Edit1.Text) >= 3 Then
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
        CanClose := False;

    If (Label3.Caption <> '') And (Key = ID_YES) And Not DataSaved Then
    Begin
        Key := Application.Messagebox('Вы не сохранили результат. Хотите сделать это?', 'Сохранение',
            MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);

        If Key = ID_YES Then
            N3.Click
    End;
End;

Procedure TForm1.Label1Click(Sender: TObject);
Begin
    ActiveControl := Nil;
End;

Procedure TForm1.Label2Click(Sender: TObject);
Begin
    ActiveControl := Nil;
End;

Procedure TForm1.Label3Click(Sender: TObject);
Begin
    ActiveControl := Nil;
End;

Procedure TForm1.N1Click(Sender: TObject);
Begin
    ActiveControl := Nil;
End;

Function TryRead(Var TestFile: TextFile): Boolean;
Var
    Signal: Boolean;
    TempSize, TestInt: INteger;
    I: Integer;
Begin
    Signal := True;
    Readln(TestFile, TempSize);
    If (TempSize > 0) And (TempSize < 100) Then
    Begin
        For I := 0 To TempSize - 1 Do
        Begin
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
        Error := -1;
    End;
End;

Procedure InputMassive(Var MyFile: TextFile; Size: Integer);
Var
    I, Count: Integer;
Begin
    For I := 0 To Size - 1 Do
    Begin
        Read(MyFile, Count);
        Form1.StringGrid1.Cells[I + 1, 1] := IntToStr(Count);
        Form1.Button2.Enabled := True;
    End;
End;

Procedure ReadingPros(Var MyFile: TextFile);
Var
    Size: Integer;
Begin
    Read(MyFile, Size);
    Form1.Font.Color := ClBlack;
    Form1.Edit1.Text := IntToStr(Size);
    Form1.Button1.Click;
    InputMassive(MyFile, Size);
End;

Procedure ReadFromFile(IsCorrect: Boolean; FileWay: String);
Var
    MyFile: TextFile;
Begin
    If Not IsCorrect And (Error = 0) Then
        MessageBox(0, 'Данные в выбранном файле не корректны!', 'Ошибка', MB_ICONERROR)
    Else if (Error = 0) then
    Begin
        AssignFile(MyFile, FileWay);
        Reset(MyFile);
        ReadingPros(MyFile);
        Close(Myfile);
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
            ReadFromFile(IsCorrect, OpenDialog1.FileName);
        End
        Else
            IsCorrect := True;
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
Var
    Minus: Integer;
Begin
    If (Key = '-') And (Length(StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row]) <> 0) Then
        Key := #0;

    if (StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row] = '0') or (StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row] = '-0') then
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

Procedure TForm1.StringGrid1KeyUp(Sender: TObject; Var Key: Word; Shift: TShiftState);
Var
    Col: Integer;
    temp : boolean;
Begin
    temp := true;
    For Col := 1 To StringGrid1.ColCount - 1 Do
        if Form1.StringGrid1.Cells[Col, 1] = '' then
            temp := false;
              
    Button2.Enabled := temp; 
End;

End.
