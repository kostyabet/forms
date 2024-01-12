Unit MainUnit;

Interface

Uses
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
    Vcl.ExtCtrls,
    Vcl.Menus;

Type
    TMainForm = Class(TForm)
        ConditionLabel: TLabel;
        EPSLabel: TLabel;
        EPSInputEdit: TEdit;
        MainMenu: TMainMenu;
        FileMMButton: TMenuItem;
        OpenMMButton: TMenuItem;
        SaveMMButton: TMenuItem;
        N4: TMenuItem;
        CloseMMButton: TMenuItem;
        InstractionMMButton: TMenuItem;
        AboutEditorMMButton: TMenuItem;
        SaveDialog: TSaveDialog;
        OpenDialog: TOpenDialog;
        XLabel: TLabel;
        XInputEdit: TEdit;
        ResultButton: TButton;
        ResultLabel: TLabel;
        Procedure EPSInputEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
        Procedure CloseMMButtonClick(Sender: TObject);
        Procedure AboutEditorMMButtonClick(Sender: TObject);
        Procedure InstractionMMButtonClick(Sender: TObject);
        Procedure FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
        Procedure OpenMMButtonClick(Sender: TObject);
        Procedure SaveMMButtonClick(Sender: TObject);
        Procedure ResultButtonClick(Sender: TObject);
        Procedure EPSInputEditChange(Sender: TObject);
        Procedure XInputEditChange(Sender: TObject);
        Procedure XInputEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
        Procedure EPSInputEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure XInputEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure EPSInputEditKeyPress(Sender: TObject; Var Key: Char);
        Procedure XInputEditKeyPress(Sender: TObject; Var Key: Char);
        Procedure EPSInputEditClick(Sender: TObject);
        Procedure EPSInputEditExit(Sender: TObject);
        Function FormHelp(Command: Word; Data: NativeInt; Var CallHelp: Boolean): Boolean;
        Procedure EPSInputEditEnter(Sender: TObject);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Const
    MAX_EPS_LENGTH: Integer = 8;
    CURSOR_DEFAULT_POS: Integer = 3;

Var
    MainForm: TMainForm;
    IfDataSavedInFile: Boolean = False;
    Error: Integer = 0;

Implementation

{$R *.dfm}

Uses
    InstractionUnit,
    AboutEditorUnit;

Function CalcResult(EPS: Real; X: Integer): String;
Const
    START_NUMBER: Real = 1.0;
Var
    Eteration: Integer;
    Y0, Y: Real;
Begin
    Y0 := START_NUMBER;
    Eteration := 0;
    If (X = 0) Then
    Begin
        Y := 0;
        Inc(Eteration);
    End
    Else
    Begin
        Y := ((Y0 * 2) + (X / (Y0 * Y0))) / 3;
        Inc(Eteration);
        If (Abs(Y - Y0) > EPS) Then
        Begin
            Y0 := Y;
            Y := ((Y0 * 2) + (X / (Y0 * Y0))) / 3;
            Inc(Eteration);
            While (Abs(Y - Y0) > EPS) Do
            Begin
                Y0 := Y;
                Y := ((Y0 * 2) + (X / (Y0 * Y0))) / 3;
                Inc(Eteration);
            End;
        End;
    End;

    CalcResult := 'Корень кубический ' + IntToStr(X) + ' = ' + FormatFloat('0.#####', Y) + #13#10 +
        'Количество операций по достижению точности: ' + IntToStr(Eteration);
End;

Procedure TMainForm.ResultButtonClick(Sender: TObject);
Var
    EPS: Real;
    X: Integer;
Begin
    EPS := StrToFloat(EPSInputEdit.Text);
    X := StrToInt(XInputEdit.Text);
    ResultLabel.Caption := CalcResult(EPS, X);
    SaveMMButton.Enabled := True;
End;

Procedure CheckChange(EPSInputEdit, XInputEdit: TEdit; ResultButton: TButton);
Begin
    Try
        StrToFloat(EPSInputEdit.Text);
        StrToInt(XInputEdit.Text);
        If StrToFloat(EPSInputEdit.Text) = 0.0 Then
            Raise Exception.Create('EPS has zero value.');

        ResultButton.Enabled := True;
    Except
        ResultButton.Enabled := False;
    End;
End;

Procedure EnablingCheck(ResultLabel: TLabel);
Begin
    ResultLabel.Caption := '';
    MainForm.SaveMMButton.Enabled := False;
    IfDataSavedInFile := False;
End;

Procedure TMainForm.EPSInputEditChange(Sender: TObject);
Begin
    CheckChange(EPSInputEdit, XInputEdit, ResultButton)
End;

Procedure TMainForm.EPSInputEditClick(Sender: TObject);
Begin
    If Length(EPSInputEdit.Text) = 0 Then
        EPSInputEdit.Text := '0,0';

    If EPSInputEdit.SelStart < 3 Then
        EPSInputEdit.SelStart := 3;
End;

Procedure TMainForm.EPSInputEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := True;
End;

Procedure TMainForm.EPSInputEditEnter(Sender: TObject);
Begin
    If Length(EPSInputEdit.Text) = 0 Then
    Begin
        EPSInputEdit.Text := '0,0';
        EPSInputEdit.SelStart := CURSOR_DEFAULT_POS;
    End;
End;

Procedure TMainForm.EPSInputEditExit(Sender: TObject);
Begin
    If StrToFloat(EPSInputEdit.Text) = 0.0 Then
        EPSInputEdit.Clear;
End;

Function CheckDelete1(Tempstr: Tcaption; Cursor: Integer): Boolean;
Begin
    Delete(Tempstr, Cursor, 1);
    If (Length(TempStr) < 3) Or (Tempstr[1] <> '0') Or (Tempstr[2] <> ',') Or (Tempstr[3] <> '0') Then
        CheckDelete1 := False
    Else
        CheckDelete1 := True;
End;

Procedure TMainForm.EPSInputEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Const
    NULL_POINT: Word = 0;
Var
    Tempstr: String;
    Cursor: Integer;
Begin
    TEdit(Sender).ReadOnly := (SsShift In Shift) Or (SsCtrl In Shift);

    If ((Key = VK_LEFT) And (EPSInputEdit.SelStart = CURSOR_DEFAULT_POS)) Or (Key = VK_DELETE) Then
        Key := NULL_POINT;

    Tempstr := EPSInputEdit.Text;
    If (Key = VK_BACK) And (EPSInputEdit.SelText <> '') Then
    Begin
        EPSInputEdit.ClearSelection;
        If (Length(EPSInputEdit.Text) < 3) Or (EPSInputEdit.Text[1] <> '0') Or (EPSInputEdit.Text[2] <> ',') Or
            (EPSInputEdit.Text[3] <> '0') Then
        Begin
            EPSInputEdit.Text := Tempstr;
            EPSInputEdit.SelStart := CURSOR_DEFAULT_POS;
        End
        Else
            EnablingCheck(ResultLabel);
        Key := NULL_POINT;
    End;

    If (Key = VK_BACK) Then
    Begin
        Cursor := EPSInputEdit.SelStart;
        If CheckDelete1(Tempstr, Cursor) Then
        Begin
            Delete(Tempstr, Cursor, 1);
            EPSInputEdit.Text := Tempstr;
            EPSInputEdit.SelStart := Cursor - 1;

            EnablingCheck(ResultLabel);
        End;
        Key := NULL_POINT;
    End;

    If Key = VK_DOWN Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);
End;

Procedure TMainForm.EPSInputEditKeyPress(Sender: TObject; Var Key: Char);
Const
    NULL_POINT: Char = #0;
    GOOD_VALUES: Set Of Char = ['0' .. '9'];
Begin
    If EPSInputEdit.SelStart < CURSOR_DEFAULT_POS Then
        Key := NULL_POINT;

    If Not(Key In GOOD_VALUES) Then
        Key := NULL_POINT;

    If (Length(EPSInputEdit.Text) = MAX_EPS_LENGTH) And (Key = '0') And
        (StrToInt(Copy(EPSInputEdit.Text, 3, Length(EPSInputEdit.Text) - 1)) = 0) Then
        Key := NULL_POINT;

    If (EPSInputEdit.SelText <> '') And (Key <> NULL_POINT) And (XInputEdit.SelStart >= CURSOR_DEFAULT_POS) Then
        EPSInputEdit.ClearSelection
    Else
        If Length(EPSInputEdit.Text) > MAX_EPS_LENGTH Then
            Key := NULL_POINT;

    If Key <> NULL_POINT Then
        EnablingCheck(ResultLabel);
End;

Procedure TMainForm.XInputEditChange(Sender: TObject);
Begin
    CheckChange(EPSInputEdit, XInputEdit, ResultButton)
End;

Procedure TMainForm.XInputEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := True;
End;

Function CheckDelete2(Tempstr: Tcaption; Cursor: Integer): Boolean;
Begin
    Delete(Tempstr, Cursor, 1);
    If ((Length(TempStr) >= 1) And (Tempstr[1] = '0')) Or ((Length(TempStr) >= 2) And (Tempstr[1] = '-') And (Tempstr[2] = '0')) Then
        CheckDelete2 := False
    Else
        CheckDelete2 := True;
End;

Procedure TMainForm.XInputEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Const
    NULL_POINT: Word = 0;
Var
    Temp: String;
    Cursor: Integer;
Begin
    TEdit(Sender).ReadOnly := (SsShift In Shift) Or (SsCtrl In Shift);

    If Key = VK_DELETE Then
        Key := NULL_POINT;

    If (Key = VK_BACK) And (XInputEdit.SelText <> '') Then
    Begin
        Temp := XInputEdit.Text;
        XInputEdit.ClearSelection;
        If (Length(XInputEdit.Text) >= 1) And (XInputEdit.Text[1] = '0') Then
        Begin
            XInputEdit.Text := Temp;
            XInputEdit.SelStart := XInputEdit.SelStart + 1;
        End
        Else
            EnablingCheck(ResultLabel);
        Key := NULL_POINT;
    End;

    If (Key = VK_BACK) Then
    Begin
        Temp := XInputEdit.Text;
        Cursor := XInputEdit.SelStart;
        If CheckDelete2(Temp, Cursor) Then
        Begin
            Delete(Temp, Cursor, 1);
            XInputEdit.Text := Temp;
            XInputEdit.SelStart := Cursor - 1;

            EnablingCheck(ResultLabel);
        End;
        Key := NULL_POINT;
    End;

    If Key = VK_DOWN Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);
End;

Procedure TMainForm.XInputEditKeyPress(Sender: TObject; Var Key: Char);
Const
    GOOD_VALUES: Set Of Char = ['0' .. '9'];
    MAX_X_LENGTH: Integer = 6;
    NULL_POINT: Char = #0;
Var
    MinCount: Integer;
Begin
    MinCount := 0;

    If (XInputEdit.Text <> XInputEdit.Text) And (XInputEdit.Text[1] = '-') And (XInputEdit.SelStart = 0) Then
        Key := NULL_POINT;

    If (Key = '0') And (Length(XInputEdit.Text) >= 1) And (XInputEdit.Text[1] = '-') And (XInputEdit.SelStart = 1) Then
        Key := NULL_POINT;

    If (Key = '0') And (Length(XInputEdit.Text) >= 2) And (XInputEdit.SelStart = 0) Then
        Key := NULL_POINT;

    If (Key = '0') And (Length(XInputEdit.Text) >= 2) And (XInputEdit.Text[1] = '-') And (XInputEdit.SelStart = 1) Then
        Key := NULL_POINT;

    If (Key = '-') And (XInputEdit.SelStart <> 0) Then
        Key := NULL_POINT;

    If ((Length(XInputEdit.Text) <> 0) And (XInputEdit.Text[1] = '-')) Or (Key = '-') Then
        MinCount := 1;

    If XInputEdit.Text = '0' Then
        Key := NULL_POINT;

    If Not((Key In GOOD_VALUES) Or (Key = '-')) Then
        Key := NULL_POINT;

    If (XInputEdit.SelText <> '') And (Key <> #0) Then
        XInputEdit.ClearSelection
    Else
        If (Length(XInputEdit.Text) >= MAX_X_LENGTH + MinCount) Then
            Key := NULL_POINT;

    If Key <> NULL_POINT Then
        EnablingCheck(ResultLabel);
End;

Procedure TMainForm.FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
Var
    ResultKey: Integer;
Begin
    ResultKey := Application.Messagebox('Вы уверены, что хотите закрыть набор записей?', 'Выход',
        MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);

    If (ResultKey = ID_NO) Then
        CanClose := False;

    If (ResultKey = ID_YES) And (ResultLabel.Caption <> '') And Not IfDataSavedInFile And (ResultLabel.Caption <> '') Then
    Begin
        ResultKey := Application.Messagebox('Вы не сохранили результат. Хотите сделать это?', 'Сохранение',
            MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);
        If ResultKey = ID_YES Then
            SaveMMButton.Click;
    End;

End;

Function TMainForm.FormHelp(Command: Word; Data: NativeInt; Var CallHelp: Boolean): Boolean;
Begin
    CallHelp := False;
End;

Function TryRead(Var TestFile: TextFile): Boolean;
Const
    MIN_EPS: Real = 0.0;
    MAX_EPS: Real = 0.1;
    MIN_X: Integer = -100000;
    MAX_X: Integer = 1000000;
Var
    BufferEPS: Real;
    BufferX: String;
    Signal: Boolean;
Begin
    Signal := True;

    Read(TestFile, BufferEPS);
    Read(TestFile, BufferX);
    StrToInt(BufferX);

    If (BufferEPS < MIN_EPS) Or (BufferEPS >= MAX_EPS) Or (Length(FloatToStr(BufferEPS)) >= MAX_EPS_LENGTH) Then
        Signal := False;

    If (BufferX = '') Or (StrToInt(BufferX) < MIN_X) Or (StrToInt(BufferX) > MAX_X) Then
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
        Error := 1;
    End;
End;

Procedure ReadFromFile(IsCorrect: Boolean; FileWay: String);
Var
    MyFile: TextFile;
    BufferFloat: Real;
    BufferInt: Integer;
Begin
    If Not IsCorrect And (Error = 0) Then
        MessageBox(0, 'Данные в выбранном файле не корректны!', 'Ошибка', MB_ICONERROR);

    If IsCorrect Then
    Begin
        AssignFile(MyFile, FileWay);
        Try
            Reset(MyFile);
            Read(MyFile, BufferFloat);
            MainForm.EPSInputEdit.Text := FloatToStr(BufferFloat);
            Read(MyFile, BufferInt);
            MainForm.XInputEdit.Text := FloatToStr(BufferInt);
        Finally
            Close(MyFile);
        End;
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
            ReadFromFile(IsCorrect, OpenDialog.FileName);
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
        IfDataSavedInFile := True;
        AssignFile(MyFile, FileName, CP_UTF8);
        ReWrite(MyFile);
        Writeln(MyFile, MainForm.ResultLabel.Caption);
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
