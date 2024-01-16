Unit MainUnit;

Interface

Uses
    Clipbrd,
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
        KEdit: TEdit;
        St1Edit: TEdit;
        St2Edit: TEdit;
        KLabel: TLabel;
        St1Label: TLabel;
        St2Label: TLabel;
        ResultButton: TButton;
        ResultLabel: TLabel;
        MainMenu: TMainMenu;
        FileMMButton: TMenuItem;
        OpenMMButton: TMenuItem;
        SaveMMButton: TMenuItem;
        LineMM: TMenuItem;
        CloseMMButton: TMenuItem;
        InstractionMMButton: TMenuItem;
        AboutEditorMMButton: TMenuItem;
        SaveDialog: TSaveDialog;
        OpenDialog: TOpenDialog;
        Procedure KEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure KEditKeyPress(Sender: TObject; Var Key: Char);
        Procedure St1EditKeyPress(Sender: TObject; Var Key: Char);
        Procedure St2EditKeyPress(Sender: TObject; Var Key: Char);
        Procedure KEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
        Procedure KEditChange(Sender: TObject);
        Procedure St1EditChange(Sender: TObject);
        Procedure St2EditChange(Sender: TObject);
        Procedure St2EditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure St1EditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure St1EditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
        Procedure St2EditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
        Procedure ResultButtonClick(Sender: TObject);
        Procedure InstractionMMButtonClick(Sender: TObject);
        Procedure AboutEditorMMButtonClick(Sender: TObject);
        Procedure SaveMMButtonClick(Sender: TObject);
        Procedure OpenMMButtonClick(Sender: TObject);
        Procedure CloseMMButtonClick(Sender: TObject);
        Procedure FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
        Function FormHelp(Command: Word; Data: NativeInt; Var CallHelp: Boolean): Boolean;
    Private
        { Private declarations }
        Procedure ButtonStat();
    Public
        { Public declarations }
    End;

Const
    MAX_STR_LENGTH: Integer = 40;

Var
    MainForm: TMainForm;
    IfDataSavedInFile: Boolean = False;
    Error: Integer = 0;

Implementation

{$R *.dfm}

Uses
    InstractionUnit,
    AboutEditorUnit;

Procedure ChangeEnabling(SaveMMButton: Boolean = False; ResultLabel: String = '');
Begin
    MainForm.SaveMMButton.Enabled := SaveMMButton;
    MainForm.ResultLabel.Caption := ResultLabel;
    IfDataSavedInFile := False;
End;

Procedure TMainForm.ButtonStat();
Begin
    MainForm.ResultButton.Enabled := (MainForm.KEdit.Text <> '') And (MainForm.St1Edit.Text <> '') And (MainForm.St2Edit.Text <> '');
End;

Function CheckDelete(Tempstr: Tcaption; Cursor: Integer): Boolean;
Begin
    Delete(Tempstr, Cursor, 1);
    CheckDelete := Not((Length(Tempstr) > 0) And ((Tempstr[1] = '0') Or (Tempstr[1] = '5') Or (Tempstr[1] = '6') Or (Tempstr[1] = '7') Or
        (Tempstr[1] = '8') Or (Tempstr[1] = '9')));
End;

Function IsStringsEqual(Str1, Str2: String; I: Integer): Boolean;
Var
    J, HighJ: Integer;
    IsCorrect: Boolean;
Begin
    IsCorrect := True;
    HighJ := Length(Str1);

    For J := 2 To HighJ Do
        IsCorrect := Not((I + J - 1 <= Length(Str2)) And IsCorrect And (Str2[I + J - 1] <> Str1[J]));

    IsStringsEqual := IsCorrect;
End;

Function CalculationOfTheResult(K: Integer; Str1, Str2: String): Integer;
Var
    Res, I: Integer;
    IsCorrect: Boolean;
Begin
    Res := -1;
    For I := 1 To Length(Str2) Do
        If (Length(Str1) <= Length(Str2)) And (Str2[I] = Str1[1]) And (K > 0) Then
        Begin
            IsCorrect := IsStringsEqual(Str1, Str2, I);
            If IsCorrect Then
                Dec(K);
            If ((K = 0) And IsCorrect) Then
                Res := I;
        End;
    CalculationOfTheResult := Res;
End;

Procedure TMainForm.ResultButtonClick(Sender: TObject);
Begin
    ChangeEnabling(True, 'Результат: ' + IntToStr(CalculationOfTheResult(StrToInt(KEdit.Text), St1Edit.Text, St2Edit.Text)));
End;

Procedure TMainForm.KEditChange(Sender: TObject);
Begin
    ButtonStat();
End;

Procedure TMainForm.KEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := True;
End;

Procedure TMainForm.KEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Const
    NULL_POINT: Word = 0;
Var
    Temp: String;
    Cursor: Integer;
Begin
    TEdit(Sender).ReadOnly := (SsShift In Shift) Or (SsCtrl In Shift);

    If Key = VK_DELETE Then
        Key := NULL_POINT;

    If (Key = VK_BACK) And (KEdit.SelText <> '') Then
    Begin
        Temp := KEdit.Text;
        KEdit.ClearSelection;
        If (Length(KEdit.Text) >= 1) And (KEdit.Text[1] = '0') Then
        Begin
            KEdit.Text := Temp;
            KEdit.SelStart := KEdit.SelStart + 1;
        End
        Else
            ChangeEnabling();
        Key := NULL_POINT;
    End;

    If (Key = VK_BACK) Then
    Begin
        Temp := KEdit.Text;
        Cursor := KEdit.SelStart;
        If CheckDelete(Temp, Cursor) Then
        Begin
            Delete(Temp, Cursor, 1);
            KEdit.Text := Temp;
            KEdit.SelStart := Cursor - 1;

            ChangeEnabling();
        End;

        Key := NULL_POINT;
    End;

    If Key = VK_DOWN Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);
End;

Procedure TMainForm.KEditKeyPress(Sender: TObject; Var Key: Char);
Const
    MAX_K_LENGTH: Integer = 1;
    NULL_POINT: Char = #0;
    GOOD_VALUES: Set Of Char = ['0' .. '9'];
    GOOD_FIRST_NUM: Set Of Char = ['1' .. '4'];
    GOOD_SEC_NUM_WHEN_FIRST_4: Set Of Char = ['1' .. '9'];
Begin
    If (Length(KEdit.Text) = 2) And (Key In GOOD_SEC_NUM_WHEN_FIRST_4) And (KEdit.Text[1] = '4') And (KEdit.SelText = KEdit.Text[2]) Then
        Key := NULL_POINT;

    If (Key = '4') And (KEdit.SelStart = 0) And (Length(KEdit.Text) >= 2) And (KEdit.Text[2] <> '0') Then
        Key := NULL_POINT;

    If (KEdit.Text = '4') And (Key <> '0') And (KEdit.SelStart = Length(KEdit.Text)) Then
        Key := NULL_POINT;

    If (Key = '0') And (KEdit.SelStart = 0) Then
        Key := NULL_POINT;

    If (Kedit.SelStart = 0) And Not(Key In GOOD_FIRST_NUM) Then
        Key := NULL_POINT;

    If (KEdit.SelStart <> 0) And Not(Key In GOOD_VALUES) Then
        Key := NULL_POINT;

    If (KEdit.SelText <> '') And (Key <> NULL_POINT) Then
        KEdit.ClearSelection;

    If Length(KEdit.Text) > MAX_K_LENGTH Then
        Key := NULL_POINT;

    If Key <> NULL_POINT Then
        ChangeEnabling();
End;

Procedure TMainForm.St1EditChange(Sender: TObject);
Begin
    ButtonStat();
End;

Procedure TMainForm.St1EditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := False;
End;

Procedure TMainForm.St1EditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    If (((Shift = [SsCtrl]) And (Key = Ord('V'))) Or ((Shift = [SsShift]) And (Key = VK_INSERT))) And
        (Length(Clipboard.AsText + St1Edit.Text) >= MAX_STR_LENGTH) Then
        Clipboard.AsText := '';

    If (Key = VK_BACK) Or (Key = VK_DELETE) Then
        ChangeEnabling();

    If Key = VK_DOWN Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);
End;

Procedure TMainForm.St1EditKeyPress(Sender: TObject; Var Key: Char);
Const
    NULL_POINT: Char = #0;
Begin
    If (Length(St1Edit.Text) >= MAX_STR_LENGTH) And (St1Edit.SelText = '') Then
        Key := NULL_POINT
    Else
        ChangeEnabling();
End;

Procedure TMainForm.St2EditChange(Sender: TObject);
Begin
    ButtonStat();
End;

Procedure TMainForm.St2EditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := False;
End;

Procedure TMainForm.St2EditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    If (((Shift = [SsCtrl]) And (Key = Ord('V'))) Or ((Shift = [SsShift]) And (Key = VK_INSERT))) And
        (Length(Clipboard.AsText + St2Edit.Text) >= MAX_STR_LENGTH) Then
        Clipboard.AsText := '';

    If (Key = VK_BACK) Or (Key = VK_DELETE) Then
        ChangeEnabling();

    If (Key = VK_DOWN) And (Key = VK_INSERT) Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);
End;

Procedure TMainForm.St2EditKeyPress(Sender: TObject; Var Key: Char);
Const
    NULL_POINT: Char = #0;
Begin
    If (Length(St2Edit.Text) >= MAX_STR_LENGTH) And (St2Edit.SelText = '') Then
        Key := NULL_POINT
    Else
        ChangeEnabling();
End;

Procedure TMainForm.FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
Var
    ResultKey: Integer;
Begin
    ResultKey := Application.Messagebox('Вы уверены, что хотите закрыть оконное пиложение?', 'Выход',
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

Function TryRead(Var TestFile: TextFile): Boolean;
Const
    MAX_K: Integer = 50;
    MIN_K: Integer = 1;
Var
    BufferK: String;
    BufferStr1, BufferStr2: String;
    ReadStatus: Boolean;
Begin
    Readln(TestFile, BufferK);
    StrToInt(BufferK);

    ReadStatus := Not((BufferK = '') Or (StrToInt(BufferK) < MIN_K) Or (StrToInt(BufferK) > MAX_K));

    If ReadStatus Then
    Begin
        Readln(TestFile, BufferStr1);
        Readln(TestFile, BufferStr2);

        ReadStatus := Not((Length(BufferStr1) > MAX_STR_LENGTH) And (Length(BufferStr2) > MAX_STR_LENGTH));
    End;

    TryRead := ReadStatus;
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

Procedure ReadFromFile(IsCorrect: Boolean; Error: Integer; FilePath: String);
Var
    MyFile: TextFile;
    BufferInt: Integer;
    BufferStr: String;
Begin
    If Not(IsCorrect) And (Error = 0) Then
        MessageBox(0, 'Данные в выбранном файле не корректны!', 'Ошибка', MB_ICONERROR)
    Else
    Begin
        AssignFile(MyFile, FilePath);
        Reset(MyFile);
        Readln(MyFile, BufferInt);
        MainForm.KEdit.Text := IntToStr(BufferInt);
        Readln(MyFile, BufferStr);
        MainForm.St1Edit.Text := BufferStr;
        Readln(MyFile, BufferStr);
        MainForm.St2Edit.Text := BufferStr;
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
            ReadFromFile(IsCorrect, Error, OpenDialog.FileName);
        End
        Else
            IsCorrect := True;
        Error := 0;
    Until IsCorrect;
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
