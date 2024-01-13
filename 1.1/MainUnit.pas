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

Const
    AGE_MAX_LENGTH: Integer = 2;
    GENDER_MAX_LENGTH: Integer = 1;

Var
    MainForm: TMainForm;
    IfDataSavedInFile: Boolean = False;
    Error: Integer = 0;

Implementation

{$R *.dfm}

Uses
    ConditionUnit,
    EditorUnit;

Procedure TMainForm.FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
Var
    ResultKey: Integer;
Begin
    ResultKey := Application.Messagebox('Вы уверены, что хотите закрыть приложение?', 'Выход', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);

    If (ResultKey = ID_NO) Then
        CanClose := False;

    If (ResultKey = ID_YES) And (ResultEdit.Caption <> '') And Not IfDataSavedInFile Then
    Begin
        ResultKey := Application.Messagebox('Вы не сохранили результат. Хотите сделать это?', 'Сохранение',
            MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);
        If ResultKey = ID_YES Then
            SaveMMButtonClick(Sender);
    End;
End;

Function TryRead(Var TestFile: TextFile): Boolean;
Const
    MIN_AGE: Integer = 18;
    MAX_AGE: Integer = 59;
Var
    BufferAge: Integer;
    BufferGenderChar: Char;
    Res: Boolean;
Begin
    Res := True;

    Read(TestFile, BufferGenderChar);
    Read(TestFile, BufferAge);

    Res := (BufferGenderChar = 'ж') Or (BufferGenderChar = 'м');
    Res := Res And ((BufferAge < MIN_AGE) Or (BufferAge > MAX_AGE));

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

Function IsCanWrite(FilePath: String): Boolean;
Var
    TestFile: TextFile;
Begin
    IsCanWrite := False;
    Try
        AssignFile(TestFile, FilePath);
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

Procedure InputInFile(IsCorrect: Boolean; FilePath: String);
Var
    MyFile: TextFile;
Begin
    If IsCorrect Then
    Begin
        AssignFile(MyFile, FilePath, CP_UTF8);
        ReWrite(MyFile);
        Writeln(MyFile, MainForm.ResultEdit.Caption);
        Close(MyFile);

        IfDataSavedInFile := True;
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

Procedure ReadFromFile(IsCorrect: Boolean; Error: Integer; FilePath: String);
Var
    MyFile: TextFile;
    BufferInt: Integer;
    BufferChar: Char;
Begin
    If Not(IsCorrect) And (Error = 0) Then
        MessageBox(0, 'Данные в выбранном файле не корректны!', 'Ошибка', MB_ICONERROR);

    If IsCorrect And (Error = 0) Then
    Begin
        AssignFile(MyFile, FilePath, CP_UTF8);
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
            IsCorrect := IsReadable(OpenDialog.FileName);
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
        CalculatingTheResult := 'Вы мужчина и вам ' + IntToStr(Age) + ', а вашей второй половинке ' + IntToStr(Trunc((Age / 2) + 7)) + '.';

    If (Gender = 'ж') Then
        CalculatingTheResult := 'Вы девушка и вам ' + IntToStr(Age) + ', а вашей второй половинке ' + IntToStr((Age * 2) - 14) + '.';
End;

Procedure TMainForm.CloseMMButtonClick(Sender: TObject);
Begin
    MainForm.Close;
End;

Procedure CheckChangeCondition(AgeEdit, GenderEdit: TEdit; ResultButton: TButton);
Begin
    If (Length(AgeEdit.Text) = AGE_MAX_LENGTH) And (Length(GenderEdit.Text) = GENDER_MAX_LENGTH) Then
        ResultButton.Enabled := True
    Else
        ResultButton.Enabled := False;
End;

Procedure ChangeEnabled(SaveMMButton: Boolean = False; ResultEdit: String = '');
Begin
    MainForm.ResultEdit.Caption := ResultEdit;
    MainForm.SaveMMButton.Enabled := SaveMMButton;
    IfDataSavedInFile := False;
End;

Procedure ElementsEnabledAfterKeyPress(Key: Char; ResultEdit: TLabel);
Const
    NULL_POINT: Char = #0;
Begin
    If Key <> NULL_POINT Then
        ChangeEnabled();
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
Const
    NULL_POINT: Char = #0;
Begin
    If Not((Key = 'м') Or (Key = 'ж')) Then
        Key := NULL_POINT;

    If (GenderEdit.SelText = GenderEdit.Text) And (GenderEdit.Text <> '') And (Key <> NULL_POINT) Then
        GenderEdit.Clear;

    If Length(GenderEdit.Text) >= GENDER_MAX_LENGTH Then
        Key := NULL_POINT;

    ElementsEnabledAfterKeyPress(Key, ResultEdit);
End;

Function CheckDelete(Tempstr: Tcaption; Cursor: Integer): Boolean;
Const
    ERROR_VALUES: Set Of Char = ['0', '6' .. '9'];
Begin
    Delete(Tempstr, Cursor, 1);
    If (Length(TempStr) = 1) And (TempStr[1] In ERROR_VALUES) Then
        CheckDelete := False
    Else
        CheckDelete := True;
End;

Procedure TMainForm.AgeEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Const
    NULL_POINT: Word = 0;
    ERROR_VALUES: Set Of Char = ['0', '6' .. '9'];
Var
    Temp: String;
    Cursor: Integer;
Begin
    TEdit(Sender).ReadOnly := (SsShift In Shift) Or (SsCtrl In Shift);

    If Key = VK_DELETE Then
        Key := NULL_POINT;

    If (Key = VK_BACK) And (AgeEdit.SelText <> '') Then
    Begin
        Temp := AgeEdit.Text;
        AgeEdit.ClearSelection;

        If (Length(AgeEdit.Text) = 1) And (AgeEdit.Text[1] In ERROR_VALUES) Then
        Begin
            AgeEdit.Text := Temp;
            AgeEdit.SelStart := AgeEdit.SelStart + 1;
        End
        Else
            ChangeEnabled();

        Key := NULL_POINT;
    End;

    If (Key = VK_BACK) Then
    Begin
        Temp := AgeEdit.Text;
        Cursor := AgeEdit.SelStart;

        If CheckDelete(Temp, Cursor) Then
        Begin
            Delete(Temp, Cursor, 1);
            AgeEdit.Text := Temp;
            AgeEdit.SelStart := Cursor - 1;

            ChangeEnabled();
        End;

        Key := NULL_POINT;
    End;

    If Key = VK_DOWN Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);

End;

Procedure TMainForm.AgeEditKeyPress(Sender: TObject; Var Key: Char);
Const
    GOOD_FIRST_NUMBER: Set Of Char = ['0' .. '9'];
    GOOD_SECOND_NUMBER: Set Of Char = ['1' .. '5'];
    GOOD_SECOND_NUMBER_IF_1_BEFORE: Set Of Char = ['8' .. '9'];

    NULL_POINT: Char = #0;
Begin
    If (Key = '0') And (AgeEdit.SelStart = 0) Then
        Key := NULL_POINT;

    If Not(Key In GOOD_SECOND_NUMBER) And (AgeEdit.Text = '') And (AgeEdit.SelStart = 0) Then
        Key := NULL_POINT;

    If (Key = '1') And (AgeEdit.SelStart = 0) And (AgeEdit.Text <> '') And Not((AgeEdit.Text = '8') Or (AgeEdit.Text = '9')) Then
        Key := NULL_POINT;

    If (AgeEdit.Text <> '') And (AgeEdit.SelStart = 0) And Not(Key In GOOD_SECOND_NUMBER) Then
        Key := NULL_POINT;

    If (Length(AgeEdit.Text) >= 1) And (AgeEdit.Text[1] = '1') And Not(Key In GOOD_SECOND_NUMBER_IF_1_BEFORE) And
        (AgeEdit.SelStart = 1) Then
        Key := NULL_POINT;

    If Not(Key In GOOD_FIRST_NUMBER) And (AgeEdit.Text <> '') Then
        Key := NULL_POINT;

    If (Key <> NULL_POINT) And (AgeEdit.SelText <> '') Then
        AgeEdit.ClearSelection
    Else
        If (Length(AgeEdit.Text) >= AGE_MAX_LENGTH) Then
            Key := NULL_POINT;

    ElementsEnabledAfterKeyPress(Key, ResultEdit);
End;

Procedure TMainForm.GenderEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    TEdit(Sender).ReadOnly := (SsShift In Shift) Or (SsCtrl In Shift);

    If (Key = VK_BACK) And (Length(GenderEdit.Text) = GENDER_MAX_LENGTH) Then
    Begin
        GenderEdit.Clear;
        ChangeEnabled();
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
