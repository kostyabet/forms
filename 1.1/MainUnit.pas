Unit MainUnit;

Interface

Uses
    Clipbrd,
    Winapi.Windows,
    Winapi.Messages,
    System.SysUtils,
    System.Variants,
    System.Classes,
    System.UITypes,
    Vcl.Graphics,
    Vcl.Controls,
    Vcl.Forms,
    Vcl.Dialogs,
    Vcl.ToolWin,
    Vcl.ComCtrls,
    Vcl.Menus,
    Vcl.StdCtrls;

Type
    TMainForm = Class(TForm)
        MainMenu: TMainMenu;
        FileMMButton: TMenuItem;
        ConditionMMButton: TMenuItem;
        AboutEditorMMButton: TMenuItem;
        OpenMMButton: TMenuItem;
        SaveMMButton: TMenuItem;
        LineMM: TMenuItem;
        CloseMMButton: TMenuItem;
        GenderEdit: TEdit;
        AgeEdit: TEdit;
        ResultButton: TButton;
        TaskLabel: TLabel;
        ResultEdit: TLabel;
        OpenDialog: TOpenDialog;
        SaveDialog: TSaveDialog;
        GenderLabel: TLabel;
        AgeLabel: TLabel;

        Procedure OpenMMButtonClick(Sender: TObject);
        Procedure ConditionMMButtonClick(Sender: TObject);
        Procedure AboutEditorMMButtonClick(Sender: TObject);
        Procedure ResultButtonClick(Sender: TObject);
        Procedure GenderEditKeyPress(Sender: TObject; Var Key: Char);
        Procedure GenderEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure AgeEditKeyPress(Sender: TObject; Var Key: Char);
        Procedure AgeEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure CloseMMButtonClick(Sender: TObject);
        Procedure AgeEditChange(Sender: TObject);
        Procedure SaveMMButtonClick(Sender: TObject);
        Procedure GenderEditChange(Sender: TObject);
        Procedure GenderEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
        Procedure AgeEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
        Procedure FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
        Function FormHelp(Command: Word; Data: NativeInt; Var CallHelp: Boolean): Boolean;

    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    MainForm: TMainForm;
    DataSaved: Boolean = False;
    Error: Integer = 0;

Implementation

{$R *.dfm}

Uses
    ConditionUnit,
    EditorUnit;

Procedure TMainForm.FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
Var
    Key: Integer;
Begin
    Key := Application.Messagebox('Вы уверены, что хотите закрыть приложение?', 'Выход', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);

    If (Key = ID_NO) Or DataSaved Or (ResultEdit.Caption = '') Then
        CanClose := False;

    If (Key = ID_YES) And (ResultEdit.Caption <> '') And Not DataSaved Then
    Begin
        Key := Application.Messagebox('Вы не сохранили результат. Хотите сделать это?', 'Сохранение',
            MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);
        If Key = ID_YES Then
            SaveMMButton.Click;
    End;

End;

Function TryRead(Var TestFile: TextFile): Boolean;
Var
    BufferInt: Integer;
    BufferChar: Char;
    Res: Boolean;
Begin
    Res := True;

    Read(TestFile, BufferChar);
    Read(TestFile, BufferInt);

    If (BufferChar <> 'м') And (BufferChar <> 'ж') Then
        Res := False;

    If Res And ((BufferInt < 18) Or (BufferInt > 99)) Then
        Res := False;

    TryRead := Res;
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
        Writeln(MyFile, MainForm.ResultEdit.Caption);
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

Procedure ReadFromFile(IsCorrect: Boolean; Error: Integer; FileWay: String);
Var
    MyFile: TextFile;
    BufferInt: Integer;
    BufferChar: Char;
Begin
    If Not(IsCorrect) And (Error = 0) Then
        MessageBox(0, 'Данные в выбранном файле не корректны!', 'Ошибка', MB_ICONERROR)
    Else
    Begin
        Assign(MyFile, FileWay);
        Reset(MyFile);

        Read(MyFile, BufferChar);
        Read(MyFile, BufferInt);

        MainForm.GenderEdit.Text := BufferChar;
        MainForm.AgeEdit.Text := IntToStr(BufferInt);

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
            ReadFromFile(IsCorrect, Error, OpenDialog.FileName);
        End
        Else
            IsCorrect := True;
        Error := 0;
    Until IsCorrect;
End;

Function CalculatingTheResult(Gender: String; Age: Integer): String;
Begin
    If (Gender = 'м') Then
        CalculatingTheResult := 'Вы мужчина и вам ' + IntToStr(Age) + ', а вашей второй половинке ' + IntToStr(Trunc((Age / 2) + 7)) + '.'
    Else
        CalculatingTheResult := 'Вы девушка и вам ' + IntToStr(Age) + ', а вашей второй половинке ' + IntToStr((Age * 2) - 14) + '.';
End;

Procedure TMainForm.CloseMMButtonClick(Sender: TObject);
Begin
    MainForm.Close;
End;

Procedure CheckChangeCondition(AgeEdit, GenderEdit: TEdit; ResultButton: TButton);
Begin
    If (Length(AgeEdit.Text) = 2) And (Length(GenderEdit.Text) = 1) Then
        ResultButton.Enabled := True
    Else
        ResultButton.Enabled := False;
End;

Procedure ChangeEnabled(ResultEdit: TLabel);
Begin
    ResultEdit.Caption := '';
    MainForm.SaveMMButton.Enabled := False;
    DataSaved := False;
End;

Procedure ElementsEnabledAfterKeyPress(Key: Char; ResultEdit: TLabel);
Begin
    If Key <> #0 Then
        ChangeEnabled(ResultEdit);

End;

Function TMainForm.FormHelp(Command: Word; Data: NativeInt; Var CallHelp: Boolean): Boolean;
Begin
    CallHelp := False;
End;

Procedure TMainForm.ConditionMMButtonClick(Sender: TObject);
Begin
    Instraction.ShowModal();
End;

Procedure TMainForm.AboutEditorMMButtonClick(Sender: TObject);
Begin
    AboutEditor.ShowModal();
End;

Procedure TMainForm.GenderEditChange(Sender: TObject);
Begin
    CheckChangeCondition(AgeEdit, GenderEdit, ResultButton);
End;

Procedure TMainForm.GenderEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := True;
End;

Procedure TMainForm.AgeEditChange(Sender: TObject);
Begin
    CheckChangeCondition(AgeEdit, GenderEdit, ResultButton);
End;

Procedure TMainForm.AgeEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := True;
End;

Procedure TMainForm.GenderEditKeyPress(Sender: TObject; Var Key: Char);
Begin
    If (Key <> 'м') And (Key <> 'ж') Then
        Key := #0;

    If (GenderEdit.SelText = GenderEdit.Text) And (GenderEdit.Text <> '') And (Key <> #0) Then
        GenderEdit.Clear;

    If Length(GenderEdit.Text) >= 1 Then
        Key := #0;

    ElementsEnabledAfterKeyPress(Key, ResultEdit);
End;

Function CheckDelete(Tempstr: Tcaption; Cursor: Integer): Boolean;
Begin
    Delete(Tempstr, Cursor, 1);
    If (Length(TempStr) = 1) And ((TempStr[1] = '0') Or (TempStr[1] = '6') Or (TempStr[1] = '7') Or (TempStr[1] = '8') Or
        (TempStr[1] = '9')) Then
        CheckDelete := False
    Else
        CheckDelete := True;
End;

Procedure TMainForm.AgeEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    TEdit(Sender).ReadOnly := (SsShift In Shift) Or (SsCtrl In Shift);

    If Key = VK_DELETE Then
        Key := 0;

    If (Key = VK_BACK) And (AgeEdit.SelText <> '') Then
    Begin
        Var
        Temp := AgeEdit.Text;
        AgeEdit.ClearSelection;
        If (Length(AgeEdit.Text) = 1) And ((AgeEdit.Text[1] = '0') Or (AgeEdit.Text[1] = '6') Or (AgeEdit.Text[1] = '7') Or
            (AgeEdit.Text[1] = '8') Or (AgeEdit.Text[1] = '9')) Then
        Begin
            AgeEdit.Text := Temp;
            AgeEdit.SelStart := AgeEdit.SelStart + 1;
        End
        Else
            ChangeEnabled(ResultEdit);

        Key := 0;
    End;

    If (Key = VK_BACK) Then
    Begin
        Var
        Tempstr := AgeEdit.Text;
        Var
        Cursor := AgeEdit.SelStart;
        If CheckDelete(Tempstr, Cursor) Then
        Begin
            Delete(Tempstr, Cursor, 1);
            AgeEdit.Text := Tempstr;
            AgeEdit.SelStart := Cursor - 1;
            ChangeEnabled(ResultEdit);
        End;
        Key := 0;
    End;

    If Key = VK_DOWN Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);

End;

Procedure TMainForm.AgeEditKeyPress(Sender: TObject; Var Key: Char);
Begin
    If (Key = '0') And (AgeEdit.SelStart = 0) Then
        Key := #0;

    If Not(Key In ['1' .. '5']) And (AgeEdit.Text = '') And (AgeEdit.SelStart = 0) Then
        Key := #0;

    If (Key = '1') And (AgeEdit.SelStart = 0) And (AgeEdit.Text <> '') And Not((AgeEdit.Text = '8') Or (AgeEdit.Text = '9')) Then
        Key := #0;

    If (AgeEdit.Text <> '') And (AgeEdit.SelStart = 0) And Not(Key In ['1' .. '5']) Then
        Key := #0;

    If (Length(AgeEdit.Text) >= 1) And (AgeEdit.Text[1] = '1') And Not(Key In ['8' .. '9']) And (AgeEdit.SelStart = 1) Then
        Key := #0;

    If Not(Key In ['0' .. '9']) And (AgeEdit.Text <> '') Then
        Key := #0;

    If (Key <> #0) And (AgeEdit.SelText <> '') Then
        AgeEdit.ClearSelection
    Else
        If (Length(AgeEdit.Text) >= 2) Then
            Key := #0;

    ElementsEnabledAfterKeyPress(Key, ResultEdit);
End;

Procedure TMainForm.GenderEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    TEdit(Sender).ReadOnly := (SsShift In Shift) Or (SsCtrl In Shift);

    If (Key = VK_BACK) And (Length(GenderEdit.Text) = 1) Then
    Begin
        GenderEdit.Clear;
        ChangeEnabled(ResultEdit);
    End;

    If Key = VK_DOWN Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);
End;

Procedure TMainForm.ResultButtonClick(Sender: TObject);
Var
    Gender: String;
    Age: Integer;
Begin
    Gender := GenderEdit.Text;
    Age := StrToInt(AgeEdit.Text);
    ResultEdit.Caption := CalculatingTheResult(Gender, Age);
    SaveMMButton.Enabled := True;
End;

End.
