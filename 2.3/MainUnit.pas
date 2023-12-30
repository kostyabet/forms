Unit MainUnit;

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
    Vcl.Menus;

Type
    TMainForm = Class(TForm)
        ConditionLabel: TLabel;
        NumberInfoLabel: TLabel;
        NumberEdit: TEdit;
        MainMenu: TMainMenu;
        FileMMButton: TMenuItem;
        OpenMMButton: TMenuItem;
        SaveMMButton: TMenuItem;
        LineMMButton: TMenuItem;
        CloseMMButton: TMenuItem;
        InstractionMMButton: TMenuItem;
        AboutEditorMMButton: TMenuItem;
        ResultButton: TButton;
        ResultLabel: TLabel;
        OpenDialog: TOpenDialog;
        SaveDialog: TSaveDialog;
        Procedure InstractionMMButtonClick(Sender: TObject);
        Procedure AboutEditorMMButtonClick(Sender: TObject);
        Procedure NumberEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
        Procedure NumberEditChange(Sender: TObject);
        Procedure NumberEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure NumberEditKeyPress(Sender: TObject; Var Key: Char);
        Procedure ResultButtonClick(Sender: TObject);
        Procedure CloseMMButtonClick(Sender: TObject);
        Procedure OpenMMButtonClick(Sender: TObject);
        Procedure SaveMMButtonClick(Sender: TObject);
        Procedure FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
        Function FormHelp(Command: Word; Data: NativeInt; Var CallHelp: Boolean): Boolean;
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    MainForm: TMainForm;
    Error: Integer = 0;
    DataSaved: Boolean = False;

Implementation

{$R *.dfm}

Uses
    InstractionUnit,
    AboutEditorUnit;

Procedure PutInMassive(Var ArrPalin: Array Of Integer; Palindrome: Integer);
Var
    I: Integer;
Begin
    I := 0;

    While Palindrome > 0 Do
    Begin
        ArrPalin[I] := Palindrome Mod 10;
        Palindrome := Palindrome Div 10;

        Inc(I);
    End;
End;

Function PalinIsPalin(Var ArrPalin: Array Of Integer; PalinLen: Integer; Palindrome: Integer): Boolean;
Var
    IsCorrect: Boolean;
    I, HighI: Integer;
Begin
    IsCorrect := True;
    HighI := PalinLen Div 2;
    For I := 0 To HighI Do
        If (ArrPalin[I] <> ArrPalin[PalinLen - I - 1]) Then
            IsCorrect := False;

    If Palindrome < 0 Then
        IsCorrect := False;

    PalinIsPalin := IsCorrect;
End;

Function LengthOfPalin(Palindrome: Integer): Integer;
Var
    PalinLen: Integer;
Begin
    PalinLen := 0;

    While (Palindrome > 0) Do
    Begin
        Inc(PalinLen);
        Palindrome := Palindrome Div 10;
    End;

    LengthOfPalin := PalinLen;
End;

Function PalinCheack(Palindrome: Integer): String;
Var
    PalinLen: Integer;
    Res: Boolean;
    ArrPalin: Array Of Integer;
Begin
    PalinLen := LengthOfPalin(Palindrome);
    SetLength(ArrPalin, PalinLen);
    PutInMassive(ArrPalin, Abs(Palindrome));

    Res := PalinIsPalin(ArrPalin, PalinLen, Palindrome);

    ArrPalin := Nil;

    If Res Then
        PalinCheack := 'палиндром.'
    Else
        PalinCheack := 'не палиндром.';
End;

Procedure ChangeEnabed(SaveMMButton: Boolean = False; ResultLabel: String = '');
Begin
    MainForm.SaveMMButton.Enabled := SaveMMButton;
    MainForm.ResultLabel.Caption := ResultLabel;
    DataSaved := False;
End;

Procedure TMainForm.ResultButtonClick(Sender: TObject);
Var
    Res: String;
Begin
    If StrToInt(NumberEdit.Text) >= 0 Then
        Res := 'Ваше число ' + PalinCheack(StrToInt(NumberEdit.Text))
    Else
        Res := 'Ваше число не палиндром.';

    ChangeEnabed(True, Res);
End;

Procedure TMainForm.NumberEditChange(Sender: TObject);
Begin
    Try
        StrToInt(NumberEdit.Text);
        ResultButton.Enabled := True;
    Except
        ResultButton.Enabled := False;
    End;
End;

Procedure TMainForm.NumberEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := True;
End;

Function CheckDelete(Tempstr: Tcaption; Cursor: Integer): Boolean;
Begin
    Delete(Tempstr, Cursor, 1);
    If ((Length(TempStr) >= 1) And (Tempstr[1] = '0')) Or ((Length(TempStr) >= 2) And (Tempstr[1] = '-') And (Tempstr[2] = '0')) Then
        CheckDelete := False
    Else
        CheckDelete := True;
End;

Procedure TMainForm.NumberEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Const
    NULL_POINT: Word = 0;
Var
    Temp: String;
    Cursor: Integer;
Begin
    TEdit(Sender).ReadOnly := (SsShift In Shift) Or (SsCtrl In Shift);

    If Key = VK_DELETE Then
        Key := NULL_POINT;

    If (Key = VK_BACK) And (NumberEdit.SelText <> '') Then
    Begin
        Temp := NumberEdit.Text;
        NumberEdit.ClearSelection;
        If (Length(NumberEdit.Text) >= 1) And (NumberEdit.Text[1] = '0') Then
        Begin
            NumberEdit.Text := Temp;
            NumberEdit.SelStart := NumberEdit.SelStart + 1;
        End
        Else
            ChangeEnabed();

        Key := NULL_POINT;
    End;

    If (Key = VK_BACK) Then
    Begin
        Temp := NumberEdit.Text;
        Cursor := NumberEdit.SelStart;
        If CheckDelete(Temp, Cursor) Then
        Begin
            Delete(Temp, Cursor, 1);
            NumberEdit.Text := Temp;
            NumberEdit.SelStart := Cursor - 1;

            ChangeEnabed();
        End;

        Key := NULL_POINT;
    End;

    If Key = VK_DOWN Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);
End;

Procedure TMainForm.NumberEditKeyPress(Sender: TObject; Var Key: Char);
Const
    NULL_POINT: Char = #0;
    MAX_PALIN_LENGTH: Integer = 9;
    GOOD_VALUES: Set Of Char = ['0' .. '9'];
Var
    MinusCount: Integer;
Begin
    MinusCount := 0;

    If (NumberEdit.Text <> NumberEdit.Text) And (NumberEdit.Text[1] = '-') And (NumberEdit.SelStart = 0) Then
        Key := NULL_POINT;

    If (Key = '0') And (Length(NumberEdit.Text) >= 1) And (NumberEdit.Text[1] = '-') Then
        Key := NULL_POINT;

    If (Key = '0') And (Length(NumberEdit.Text) >= 2) And (NumberEdit.SelStart = 0) Then
        Key := NULL_POINT;

    If (Key = '0') And (Length(NumberEdit.Text) >= 2) And (NumberEdit.Text[1] = '-') And (NumberEdit.SelStart = 1) Then
        Key := NULL_POINT;

    If (Key = '-') And (NumberEdit.SelStart <> 0) Then
        Key := NULL_POINT;

    If ((Length(NumberEdit.Text) <> 0) And (NumberEdit.Text[1] = '-')) Or (Key = '-') Then
        MinusCount := 1;

    If NumberEdit.Text = '0' Then
        Key := NULL_POINT;

    If Not((Key In GOOD_VALUES) Or (Key = '-')) Then
        Key := NULL_POINT;

    If (NumberEdit.SelText <> '') And (Key <> NULL_POINT) Then
        NumberEdit.ClearSelection
    Else
        If (Length(NumberEdit.Text) >= MAX_PALIN_LENGTH + MinusCount) Then
            Key := NULL_POINT;

    If Key <> NULL_POINT Then
        ChangeEnabed();
End;

Procedure TMainForm.FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
Var
    Key: Integer;
Begin
    Key := Application.Messagebox('Вы уверены, что хотите закрыть набор записей?', 'Выход', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);

    If Key = ID_NO Then
        CanClose := False;

    If (ResultLabel.Caption <> '') And (Key = ID_YES) And Not DataSaved Then
    Begin
        Key := Application.Messagebox('Вы не сохранили результат. Хотите сделать это?', 'Сохранение',
            MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);

        If Key = ID_YES Then
            SaveMMButton.Click
    End;
End;

Function TMainForm.FormHelp(Command: Word; Data: NativeInt; Var CallHelp: Boolean): Boolean;
Begin
    CallHelp := False;
End;

Function TryRead(Var TestFile: TextFile): Boolean;
Const
    MAX_PALIN: Integer = 999999999;
    MIN_PALIN: Integer = -999999999;
Var
    BufferPalinStr: String;
Begin
    Read(TestFile, BufferPalinStr);
    StrToInt(BufferPalinStr);

    If (BufferPalinStr = '') Or (StrToInt(BufferPalinStr) < MIN_PALIN) Or (StrToInt(BufferPalinStr) > MAX_PALIN) Then
        TryRead := False
    Else
        TryRead := True;
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

Procedure ReadFromFile(IsCorrect: Boolean; FileWay: String);
Var
    MyFile: TextFile;
    BufferInt: Integer;
Begin
    If Not(IsCorrect) And (Error = 0) Then
        MessageBox(0, 'Данные в выбранном файле не корректны!', 'Ошибка', MB_ICONERROR);

    If IsCorrect And (Error = 0) Then
    Begin
        AssignFile(MyFile, FileWay, CP_UTF8);
        Reset(MyFile);
        Read(MyFile, BufferInt);
        MainForm.NumberEdit.Text := IntToStr(BufferInt);
        Close(MyFile);
    End;
End;

Procedure TMainForm.OpenMMButtonClick(Sender: TObject);
Var
    IsCorrect: Boolean;
Begin
    Repeat
        If OpenDialog.Execute() Then
        Begin
            IsCorrect := IsCanRead(OpenDialog.FileName);
            ReadFromFile(IsCorrect, SaveDialog.FileName);
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
Begin
    If IsCorrect Then
    Begin
        DataSaved := True;
        AssignFile(MyFile, FileName, CP_UTF8);
        ReWrite(MyFile);
        Write(MyFile, MainForm.ResultLabel.Caption);
        Close(MyFile);
    End;
End;

Procedure TMainForm.SaveMMButtonClick(Sender: TObject);
Var
    IsCorrect: Boolean;
Begin
    Repeat
        If SaveDialog.Execute Then
        Begin
            IsCorrect := IsCanWrite(SaveDialog.FileName);
            InputInFile(IsCorrect, SaveDialog.FileName);
        End
        Else
            IsCorrect := True;
    Until IsCorrect;
End;

Procedure TMainForm.CloseMMButtonClick(Sender: TObject);
Begin
    MainForm.Close;
End;

Procedure TMainForm.InstractionMMButtonClick(Sender: TObject);
Begin
    Instraction.ShowModal;
End;

Procedure TMainForm.AboutEditorMMButtonClick(Sender: TObject);
Begin
    AboutEditor.ShowModal;
End;

End.
