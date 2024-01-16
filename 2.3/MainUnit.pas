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
    IfDataSavedInFile: Boolean = False;

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
    I := 1;
    While Not(I > HighI) And IsCorrect Do
    Begin
        IsCorrect := Not(ArrPalin[I] <> ArrPalin[PalinLen - I - 1]);

        Inc(I);
    End;

    IsCorrect := Not(Palindrome < 0);

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
        PalinCheack := 'палиндром'
    Else
        PalinCheack := 'не палиндром';
End;

Procedure ChangeEnabed(SaveMMButton: Boolean = False; ResultLabel: String = '');
Begin
    MainForm.SaveMMButton.Enabled := SaveMMButton;
    MainForm.ResultLabel.Caption := ResultLabel;
    IfDataSavedInFile := False;
End;

Procedure TMainForm.ResultButtonClick(Sender: TObject);
Var
    Res: String;
Begin
    If StrToInt(NumberEdit.Text) > 0 Then
        Res := 'Ваше число ' + PalinCheack(StrToInt(NumberEdit.Text))
    Else
        Res := 'Ваше число не палиндром';
    Res := Res + '. (' + NumberEdit.Text + ')';

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
    If ((Length(TempStr) > 0) And (Tempstr[1] = '0')) Or ((Length(TempStr) > 1) And (Tempstr[1] = '-') And (Tempstr[2] = '0')) Then
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
        If (Length(NumberEdit.Text) > 0) And (NumberEdit.Text[1] = '0') Then
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
    MAX_PALIN_LENGTH: Integer = 8;
    GOOD_VALUES: Set Of Char = ['0' .. '9'];
Var
    MinusCount: Integer;
Begin
    MinusCount := 0;

    If (NumberEdit.Text <> NumberEdit.Text) And (NumberEdit.Text[1] = '-') And (NumberEdit.SelStart = 0) Then
        Key := NULL_POINT;

    If (Key = '0') And (Length(NumberEdit.Text) > 0) And (NumberEdit.Text[1] = '-') Then
        Key := NULL_POINT;

    If (Key = '0') And (Length(NumberEdit.Text) > 1) And (NumberEdit.SelStart = 0) Then
        Key := NULL_POINT;

    If (Key = '0') And (Length(NumberEdit.Text) > 1) And (NumberEdit.Text[1] = '-') And (NumberEdit.SelStart = 1) Then
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
        If (Length(NumberEdit.Text) > MAX_PALIN_LENGTH + MinusCount) Then
            Key := NULL_POINT;

    If Key <> NULL_POINT Then
        ChangeEnabed();
End;

Procedure TMainForm.FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
Var
    ResultKey: Integer;
Begin
    ResultKey := Application.Messagebox('Вы уверены, что хотите закрыть оконное приложение?', 'Выход',
        MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);

    If ResultKey = ID_NO Then
        CanClose := False;

    If (ResultLabel.Caption <> '') And (ResultKey = ID_YES) And Not IfDataSavedInFile Then
    Begin
        ResultKey := Application.Messagebox('Вы не сохранили результат. Хотите сделать это?', 'Сохранение',
            MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);

        If ResultKey = ID_YES Then
            SaveMMButtonClick(Sender);
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
    Res: Boolean;
Begin
    Read(TestFile, BufferPalinStr);
    StrToInt(BufferPalinStr);

    Res := Not((BufferPalinStr = '') Or (StrToInt(BufferPalinStr) < MIN_PALIN) Or (StrToInt(BufferPalinStr) > MAX_PALIN));
    Res := Res And SeekEof(TestFile);

    TryRead := Res;
End;

Function IsReadable(FilePath: String): Boolean;
Var
    TestFile: TextFile;
Begin
    IsReadable := False;
    Try
        AssignFile(TestFile, FilePath, CP_UTF8);
        Try
            Reset(TestFile);
            IsReadable := TryRead(TestFile);
        Finally
            Close(TestFile);
        End;
    Except
        MessageBox(0, 'Невозможно чтение из файл!', 'Ошибка', MB_ICONERROR);
        Error := 1;
    End;
End;

Procedure ReadFromFile(IsCorrect: Boolean; FilePath: String);
Var
    MyFile: TextFile;
    BufferInt: Integer;
Begin
    If Not(IsCorrect) And (Error = 0) Then
        MessageBox(0, 'Данные в выбранном файле не корректны!', 'Ошибка', MB_ICONERROR);

    If IsCorrect And (Error = 0) Then
    Begin
        AssignFile(MyFile, FilePath, CP_UTF8);
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
            IsCorrect := IsReadable(OpenDialog.FileName);
            ReadFromFile(IsCorrect, SaveDialog.FileName);
        End
        Else
            IsCorrect := True;
        Error := 0;
    Until IsCorrect;
End;

Function IsWriteable(FilePath: String): Boolean;
Var
    TestFile: TextFile;
Begin
    IsWriteable := False;
    Try
        AssignFile(TestFile, FilePath);
        Try
            Rewrite(TestFile);
            IsWriteable := True;
        Finally
            CloseFile(TestFile);
        End;
    Except
        MessageBox(0, 'Невозможна запись в файл!', 'Ошибка', MB_ICONERROR);
    End;
End;

Procedure InputInFile(IsCorrect: Boolean; FilePath: String);
Var
    MyFile: TextFile;
Begin
    If IsCorrect Then
    Begin
        IfDataSavedInFile := True;
        AssignFile(MyFile, FilePath, CP_UTF8);
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
            IsCorrect := IsWriteable(SaveDialog.FileName);
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
