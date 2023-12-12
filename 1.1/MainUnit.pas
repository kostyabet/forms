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
    If Key = ID_NO Then
        CanClose := False
    Else
    Begin
        If DataSaved Or (ResultEdit.Caption = '') Then
        Begin
            If Key = ID_NO Then
                CanClose := False
        End
        Else
            If ResultEdit.Caption <> '' Then
            Begin
                Key := Application.Messagebox('Вы не сохранили результат. Хотите сделать это?', 'Сохранение',
                    MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);
                If Key = ID_YES Then
                    SaveMMButton.Click;
            End;
    End;
End;

Procedure TMainForm.ConditionMMButtonClick(Sender: TObject);
Begin
    Instraction.ShowModal();
End;

Procedure TMainForm.AboutEditorMMButtonClick(Sender: TObject);
Begin
    AboutEditor.ShowModal();
End;

Function TryRead(Var TestFile: TextFile): Boolean;
Var
    BufferInt: Integer;
    BufferChar: Char;
Begin
    Read(TestFile, BufferChar);
    Read(TestFile, BufferInt);
    If (BufferChar <> 'м') And (BufferChar <> 'ж') Then
        TryRead := False
    Else
        If (BufferInt < 18) Or (BufferInt > 99) Then
            TryRead := False
        Else
        Begin
            TryRead := True;
            MainForm.GenderEdit.Text := BufferChar;
            MainForm.GenderEdit.Text := IntToStr(BufferInt);
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

Procedure TMainForm.OpenMMButtonClick(Sender: TObject);
Var
    IsCorrect: Boolean;
Begin
    Repeat
        If OpenDialog.Execute() Then
        Begin
            IsCorrect := IsCanRead(OpenDialog.FileName);
            If Not(IsCorrect) And (Error = 0) Then
                MessageBox(0, 'Данные в выбранном файле не корректны!', 'Ошибка', MB_ICONERROR);
        End
        Else
            IsCorrect := True;
        Error := 0;
    Until IsCorrect;
End;

Procedure TMainForm.CloseMMButtonClick(Sender: TObject);
Begin
    MainForm.Close;
End;

Function CalculatingTheResult(Gender: String; Age: Integer): String;
Begin
    If (Gender = 'м') Then
        CalculatingTheResult := 'Вы мужчина и вам ' + IntToStr(Age) + ', а вашей второй половинке ' + IntToStr(Trunc((Age / 2) + 7)) + '.'
    Else
        CalculatingTheResult := 'Вы девушка и вам ' + IntToStr(Age) + ', а вашей второй половинке ' + IntToStr((Age * 2) - 14) + '.';
End;

Procedure TMainForm.GenderEditChange(Sender: TObject);
Begin
    If (Length(AgeEdit.Text) = 2) And (Length(GenderEdit.Text) = 1) Then
        ResultButton.Enabled := True
    Else
        ResultButton.Enabled := False;
End;

Procedure TMainForm.GenderEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := True;
End;

Procedure TMainForm.GenderEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    TEdit(Sender).ReadOnly := (SsShift In Shift) Or (SsCtrl In Shift);

    If (Key = VK_BACK) And (Length(GenderEdit.Text) = 1) Then
        GenderEdit.Clear;

    If Key = VK_DOWN Then
    Begin
        SelectNext(ActiveControl, True, True);
        Key := 0;
    End;

    If Key = VK_UP Then
    Begin
        SelectNext(ActiveControl, False, True);
        Key := 0;
    End;
End;

Procedure TMainForm.GenderEditKeyPress(Sender: TObject; Var Key: Char);
Begin

    If (Key <> 'м') And (Key <> 'ж') Then
        Key := #0
    Else
        If (GenderEdit.SelText = GenderEdit.Text) And (GenderEdit.Text <> '') Then
        Begin
            GenderEdit.Clear;
        End
        Else
            If Length(GenderEdit.Text) >= 1 Then
            Begin
                Key := #0;
            End;
End;

Procedure TMainForm.AgeEditChange(Sender: TObject);
Begin
    If (Length(AgeEdit.Text) = 2) And (Length(GenderEdit.Text) = 1) Then
        ResultButton.Enabled := True
    Else
        ResultButton.Enabled := False;
End;

Procedure TMainForm.AgeEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := True;
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
        End;
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

    if (Key = '1') And (AgeEdit.SelStart = 0) And (AgeEdit.Text <> '') And not ((AgeEdit.Text = '8') or (AgeEdit.Text = '9')) then
        Key := #0;
        
    if (AgeEdit.Text <> '') and (AgeEdit.SelStart = 0) And not (Key in ['1'..'5']) then
        Key := #0;

    if (Length(AgeEdit.Text) >= 1) And (AgeEdit.Text[1] = '1') And not (Key in ['8'..'9']) And (AgeEdit.SelStart = 1) then
        Key := #0;
        
    If Not(Key In ['0' .. '9']) And (AgeEdit.Text <> '') Then
        Key := #0;

    If (Key <> #0) And (AgeEdit.SelText <> '') Then
        AgeEdit.ClearSelection
    Else
        If (Length(AgeEdit.Text) >= 2) Then
            Key := #0;
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
