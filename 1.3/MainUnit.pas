Unit MainUnit;

{ TODO -oOwner -cGeneral : Проверка на ввод в Х }

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

Var
    MainForm: TMainForm;
    DataSaved: Boolean = False;

Implementation

{$R *.dfm}

Uses
    InstractionUnit,
    AboutEditorUnit;

Function CalcResult(EPS: Real; X: Integer): String;
Var
    Eteration: Integer;
    Y0, Y: Real;
Begin
    Y0 := 1.0;
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

Procedure TMainForm.EPSInputEditChange(Sender: TObject);
Begin
    Try
        StrToFloat(EPSInputEdit.Text);
        StrToInt(XInputEdit.Text);
        If (EPSInputEdit.Text <> '0,0') And (StrToInt(Copy(EPSInputEdit.Text, 3, Length(EPSInputEdit.Text) - 1)) <> 0) Then
            ResultButton.Enabled := True;
    Except
        ResultButton.Enabled := False;
    End;
End;

Procedure TMainForm.EPSInputEditClick(Sender: TObject);
Begin
    If Length(EPSInputEdit.Text) = 0 Then
    Begin
        EPSInputEdit.Text := '0,0';
        EPSInputEdit.SelStart := 3;
    End;

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
        EPSInputEdit.SelStart := 3;
    End;
End;

Procedure TMainForm.EPSInputEditExit(Sender: TObject);
Begin
    If StrToFloat(EPSInputEdit.Text) = 0.0 Then
    Begin
        EPSInputEdit.Clear;
    End;
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
Var
    Tempstr: String;
    Cursor: Integer;
Begin
    TEdit(Sender).ReadOnly := (SsShift In Shift) Or (SsCtrl In Shift);

    If ((Key = VK_LEFT) And (EPSInputEdit.SelStart = 3)) Or (Key = VK_DELETE) Then
        Key := 0;

    Tempstr := EPSInputEdit.Text;
    If (Key = VK_BACK) And (EPSInputEdit.SelText <> '') Then
    Begin
        EPSInputEdit.ClearSelection;
        If (Length(EPSInputEdit.Text) < 3) Or (EPSInputEdit.Text[1] <> '0') Or (EPSInputEdit.Text[2] <> ',') Or
            (EPSInputEdit.Text[3] <> '0') Then
        Begin
            EPSInputEdit.Text := Tempstr;
            EPSInputEdit.SelStart := 3;
        End
        Else
        Begin
            ResultLabel.Caption := '';
            SaveMMButton.Enabled := False;
            DataSaved := False;
        End;
        Key := 0;
    End;

    If (Key = VK_BACK) Then
    Begin
        Cursor := EPSInputEdit.SelStart;
        If CheckDelete1(Tempstr, Cursor) Then
        Begin
            Delete(Tempstr, Cursor, 1);
            EPSInputEdit.Text := Tempstr;
            EPSInputEdit.SelStart := Cursor - 1;
            ResultLabel.Caption := '';
            SaveMMButton.Enabled := False;
            DataSaved := False;
        End;
        Key := 0;
    End;

    If Key = VK_DOWN Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);
End;

Procedure TMainForm.EPSInputEditKeyPress(Sender: TObject; Var Key: Char);
Begin
    If EPSInputEdit.SelStart < 3 Then
        Key := #0;

    If Not(Key In ['0' .. '9']) Then
        Key := #0;

    If (Length(EPSInputEdit.Text) = 8) And (Key = '0') And (StrToInt(Copy(EPSInputEdit.Text, 3, Length(EPSInputEdit.Text) - 1)) = 0) Then
        Key := #0;

    If (EPSInputEdit.SelText <> '') And (Key <> #0) And (XInputEdit.SelStart >= 3) Then
        EPSInputEdit.ClearSelection
    Else
        If Length(EPSInputEdit.Text) > 8 Then
            Key := #0;

    If Key <> #0 Then
    Begin
        ResultLabel.Caption := '';
        SaveMMButton.Enabled := False;
        DataSaved := False;
    End;
End;

Procedure TMainForm.XInputEditChange(Sender: TObject);
Begin
    Try
        StrToInt(XInputEdit.Text);
        StrToFloat(EPSInputEdit.Text);
        If (EPSInputEdit.Text <> '0,0') And (StrToInt(Copy(EPSInputEdit.Text, 3, Length(EPSInputEdit.Text) - 1)) <> 0) Then
            ResultButton.Enabled := True;
    Except
        ResultButton.Enabled := False;
    End;
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
Var
    Temp: String;
    Cursor: Integer;
Begin
    TEdit(Sender).ReadOnly := (SsShift In Shift) Or (SsCtrl In Shift);

    If Key = VK_DELETE Then
        Key := 0;

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
        Begin
            ResultLabel.Caption := '';
            SaveMMButton.Enabled := False;
            DataSaved := False;
        End;
        Key := 0;
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
            ResultLabel.Caption := '';
            SaveMMButton.Enabled := False;
            DataSaved := False;
        End;
        Key := 0;
    End;

    If Key = VK_DOWN Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);
End;

Procedure TMainForm.XInputEditKeyPress(Sender: TObject; Var Key: Char);
Var
    MinCount: Integer;
Begin
    MinCount := 0;

    If (XInputEdit.Text <> XInputEdit.Text) And (XInputEdit.Text[1] = '-') And (XInputEdit.SelStart = 0) Then
        Key := #0;

    If (Key = '0') And (Length(XInputEdit.Text) >= 1) And (XInputEdit.Text[1] = '-') Then
        Key := #0;

    If (Key = '0') And (Length(XInputEdit.Text) >= 2) And (XInputEdit.SelStart = 0) Then
        Key := #0;

    If (Key = '0') And (Length(XInputEdit.Text) >= 2) And (XInputEdit.Text[1] = '-') And (XInputEdit.SelStart = 1) Then
        Key := #0;

    If (Key = '-') And (XInputEdit.SelStart <> 0) Then
        Key := #0;

    If ((Length(XInputEdit.Text) <> 0) And (XInputEdit.Text[1] = '-')) Or (Key = '-') Then
        MinCount := 1;

    If XInputEdit.Text = '0' Then
        Key := #0;

    If Not((Key In ['0' .. '9']) Or (Key = '-')) Then
        Key := #0;

    If (XInputEdit.SelText <> '') And (Key <> #0) Then
        XInputEdit.ClearSelection
    Else
        If (Length(XInputEdit.Text) >= 6 + MinCount) Then
            Key := #0;

    If Key <> #0 Then
    Begin
        ResultLabel.Caption := '';
        SaveMMButton.Enabled := False;
        DataSaved := False;
    End;
End;

Procedure TMainForm.FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
Var
    Key: Integer;
Begin
    Key := Application.Messagebox('Вы уверены, что хотите закрыть набор записей?', 'Выход', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);
    If Key = ID_NO Then
        CanClose := False
    Else
    Begin
        If DataSaved Or (ResultLabel.Caption = '') Then
        Begin
            If Key = ID_NO Then
                CanClose := False
        End
        Else
            If ResultLabel.Caption <> '' Then
            Begin
                Key := Application.Messagebox('Вы не сохранили результат. Хотите сделать это?', 'Сохранение',
                    MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);
                If Key = ID_YES Then
                    SaveMMButton.Click;
            End;
    End;
End;

Function TMainForm.FormHelp(Command: Word; Data: NativeInt; Var CallHelp: Boolean): Boolean;
Begin
    CallHelp := False;
End;

Function TryRead(Var TestFile: TextFile): Boolean;
Var
    BufferReal1: Real;
    BufferInt2: Real;
    Signal: Boolean;
Begin
    Signal := True;
    BufferReal1 := 0.0;
    BufferInt2 := 0;
    Try
        Readln(TestFile, BufferReal1);
        Read(TestFile, BufferInt2);
    Except
        Signal := False;
    End;

    If (BufferReal1 < 0.0) Or (BufferReal1 >= 0.1) Or (Length(FloatToStr(BufferReal1)) >= 8) Then
        Signal := False;

    If (BufferInt2 < -1000000) Or (BufferInt2 > 1000000) Then
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

Procedure ReadFromFile(IsCorrect: Boolean; FileWay: String);
Var
    MyFile: TextFile;
    BufferFloat: Real;
    BufferInt: Integer;
Begin
    If IsCorrect Then
    Begin
        AssignFile(MyFile, FileWay);
        Try
            Reset(MyFile);
            Readln(MyFile, BufferFloat);
            MainForm.EPSInputEdit.Text := FloatToStr(BufferFloat);
            Readln(MyFile, BufferInt);
            MainForm.XInputEdit.Text := FloatToStr(BufferInt);
        Finally
            Close(MyFile);
        End;
    End
    Else
        MessageBox(0, 'Данные в выбранном файле не корректны!', 'Ошибка', MB_ICONERROR);
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
