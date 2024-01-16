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
    Vcl.Menus,
    Vcl.Grids;

Type
    TMainForm = Class(TForm)
        MainMenu: TMainMenu;
        FileMMButton: TMenuItem;
        OpenMMButton: TMenuItem;
        SaveMMButton: TMenuItem;
        LineMMButton: TMenuItem;
        CloseMMButton: TMenuItem;
        InstractionMMButton: TMenuItem;
        AboutEditorMMButton: TMenuItem;
        ConditionLabel: TLabel;
        NLabel: TLabel;
        NEdit: TEdit;
        SequenceGrid: TStringGrid;
        CreateMassiveButton: TButton;
        ResultButton: TButton;
        ResultLabel: TLabel;
        OpenDialog: TOpenDialog;
        SaveDialog: TSaveDialog;
        Procedure InstractionMMButtonClick(Sender: TObject);
        Procedure AboutEditorMMButtonClick(Sender: TObject);
        Procedure CloseMMButtonClick(Sender: TObject);
        Procedure NEditChange(Sender: TObject);
        Procedure NEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
        Procedure NEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure NEditKeyPress(Sender: TObject; Var Key: Char);
        Procedure CreateMassiveButtonClick(Sender: TObject);
        Procedure ResultButtonClick(Sender: TObject);
        Procedure OpenMMButtonClick(Sender: TObject);
        Procedure SaveMMButtonClick(Sender: TObject);
        Procedure FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
        Procedure SequenceGridKeyUp(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure SequenceGridKeyPress(Sender: TObject; Var Key: Char);
        Procedure SequenceGridKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Function FormHelp(Command: Word; Data: NativeInt; Var CallHelp: Boolean): Boolean;
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    MainForm: TMainForm;
    IfDataSavedInFile: Boolean = False;
    Error: Integer = 0;

Implementation

{$R *.dfm}

Uses
    InstractionUnit,
    AboutEditorUnit;

Procedure ChangingEnabling(SequenceGrid: Boolean = False; ResultButton: Boolean = False; SaveMMButton: Boolean = False;
    ResultLabel: String = '');
Begin
    MainForm.SequenceGrid.Visible := SequenceGrid;
    MainForm.ResultButton.Enabled := ResultButton;
    MainForm.SaveMMButton.Enabled := SaveMMButton;
    MainForm.ResultLabel.Caption := ResultLabel;
    IfDataSavedInFile := False;
End;

Procedure CreateMassiveBeforInput(SequenceGrid: TStringGrid; NEdit: TEdit);
Var
    I: Integer;
Begin
    SequenceGrid.Cells[0, 0] := '№';
    SequenceGrid.Cells[0, 1] := 'Число';
    SequenceGrid.ColCount := StrToInt(NEdit.Text) + 1;
    For I := 1 To SequenceGrid.ColCount - 1 Do
    Begin
        SequenceGrid.Cells[I, 0] := IntToStr(I);
        SequenceGrid.Cells[I, 1] := '';
    End;
    ChangingEnabling(True);
End;

Procedure TMainForm.CreateMassiveButtonClick(Sender: TObject);
Begin
    CreateMassiveBeforInput(SequenceGrid, NEdit);
End;

Function IsArrIncreasing(): Boolean;
Var
    I, HighI, J, HighJ: Integer;
    IsConditionYes: Boolean;
Begin
    IsConditionYes := False;
    HighI := MainForm.SequenceGrid.ColCount - 1;
    For I := 2 To HighI Do
    Begin
        If Not(MainForm.SequenceGrid.Cells[I, 1] >= MainForm.SequenceGrid.Cells[I - 1, 1]) Then
            IsConditionYes := True;
    End;

    HighJ := HighI;
    If Not IsConditionYes Then
    Begin
        IsConditionYes := True;
        For I := 1 To HighI Do
        Begin
            For J := I + 1 To HighJ Do
            Begin
                If MainForm.SequenceGrid.Cells[J, 1] <> MainForm.SequenceGrid.Cells[I, 1] Then
                    IsConditionYes := False;
            End;
        End;
    End;

    IsArrIncreasing := IsConditionYes;
End;

Procedure TMainForm.ResultButtonClick(Sender: TObject);
Var
    Res: String;
Begin
    Res := 'Числовая последовательность ';
    If IsArrIncreasing() Then
        Res := Res + 'невозростающая.'
    Else
        Res := Res + 'возростающая.';

    ChangingEnabling(True, True, True, Res);
End;

Procedure TMainForm.NEditChange(Sender: TObject);
Begin
    Try
        StrToInt(NEdit.Text);
        CreateMassiveButton.Enabled := True;
    Except
        CreateMassiveButton.Enabled := False;
    End;
End;

Function CheckDelete(Tempstr: Tcaption; Cursor: Integer): Boolean;
Begin
    Delete(Tempstr, Cursor, 1);

    CheckDelete := Not((Length(TempStr) > 0) And (Tempstr[1] = '0'))
End;

Procedure TMainForm.NEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := True;
End;

Procedure TMainForm.NEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Const
    NULL_POINT: Word = 0;
Var
    Temp: String;
    Cursor: Integer;
Begin
    TEdit(Sender).ReadOnly := (SsShift In Shift) Or (SsCtrl In Shift);

    If Key = VK_DELETE Then
        Key := NULL_POINT;

    If (Key = VK_BACK) And (NEdit.SelText <> '') Then
    Begin
        Temp := NEdit.Text;
        NEdit.ClearSelection;
        If (Length(NEdit.Text) > 0) And (NEdit.Text[1] = '0') Then
        Begin
            NEdit.Text := Temp;
            NEdit.SelStart := NEdit.SelStart + 1;
        End
        Else
            ChangingEnabling();
        Key := NULL_POINT;
    End;

    If (Key = VK_BACK) Then
    Begin
        Temp := NEdit.Text;
        Cursor := NEdit.SelStart;
        If CheckDelete(Temp, Cursor) Then
        Begin
            Delete(Temp, Cursor, 1);
            NEdit.Text := Temp;
            NEdit.SelStart := Cursor - 1;

            ChangingEnabling();
        End;

        Key := NULL_POINT;
    End;

    If Key = VK_DOWN Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);
End;

Procedure TMainForm.NEditKeyPress(Sender: TObject; Var Key: Char);
Const
    NULL_POINT: Char = #0;
    GOOD_VALUES: Set Of Char = ['0' .. '9'];
    MAX_EDIT_LENGTH: Integer = 2;
Begin
    If (Key = '0') And (NEdit.SelStart = 0) Then
        Key := NULL_POINT;

    If Not(Key In GOOD_VALUES) Then
        Key := NULL_POINT;

    If (NEdit.SelText <> '') And (Key <> NULL_POINT) Then
        NEdit.ClearSelection;

    If Length(NEdit.Text) > MAX_EDIT_LENGTH Then
        Key := NULL_POINT;

    If Key <> NULL_POINT Then
        ChangingEnabling();
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
    MAX_N: Integer = 999;
    MIN_N: Integer = 1;
    MAX_VALUE: Integer = 999999;
    MIN_VALUE: Integer = -999999;
    SPACE_LIMIT: Integer = 4;
Var
    Res, IsNumeral: Boolean;
    TempN, SpaceCount, NumCount: Integer;
    BufferValue: Char;
Begin
    {$I-}
    Read(TestFile, TempN);

    Res := Not((TempN < MIN_N) Or (TempN > MAX_N));

    SpaceCount := 0;
    NumCount := 0;
    While Res And Not(EOF(TestFile)) Do
    Begin
        Read(TestFile, BufferValue);
        IsNumeral := (BufferValue > Pred('0')) And (BufferValue < Succ('9'));

        Res := Not((SpaceCount > SPACE_LIMIT - 1) And IsNumeral);

        If (SpaceCount > 0) And IsNumeral Then
            Inc(NumCount);

        If (BufferValue <> ' ') Then
            SpaceCount := 0
        Else
            Inc(SpaceCount);

        Res := Res And (IsNumeral Or (BufferValue = ' '));

        Res := Res And Not(NumCount > TempN);
    End;
    Res := Res And Not(NumCount < TempN);

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
        Error := -1;
    End;
End;

Procedure InputMassive(Var MyFile: TextFile; Size: Integer);
Var
    I, Count: Integer;
Begin
    For I := 1 To Size Do
    Begin
        Read(MyFile, Count);
        MainForm.SequenceGrid.Cells[I, 1] := IntToStr(Count);
        MainForm.ResultButton.Enabled := True;
    End;
End;

Procedure ReadingPros(Var MyFile: TextFile);
Var
    Size: Integer;
Begin
    Read(MyFile, Size);
    MainForm.NEdit.Text := IntToStr(Size);
    CreateMassiveBeforInput(MainForm.SequenceGrid, MainForm.NEdit);
    InputMassive(MyFile, Size);

    ChangingEnabling(True, True);
End;

Procedure ReadFromFile(Var IsCorrect: Boolean; FilePath: String);
Var
    MyFile: TextFile;
Begin
    If Not IsCorrect And (Error = 0) Then
        MessageBox(0, 'Данные в выбранном файле не корректны!', 'Ошибка', MB_ICONERROR);

    If IsCorrect And (Error = 0) Then
    Begin
        AssignFile(MyFile, FilePath);
        Try
            Reset(MyFile);
            Try
                ReadingPros(MyFile);
            Finally
                Close(Myfile);
            End;
        Except
            MessageBox(0, 'Ошибка при чтении из файла!', 'Ошибка', MB_ICONERROR);
            IsCorrect := False;
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
            IsCorrect := IsReadable(OpenDialog.FileName);
            ReadFromFile(IsCorrect, OpenDialog.FileName);
        End
        Else
            IsCorrect := True;
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

Procedure InputInFile(Var IsCorrect: Boolean; FilePath: String);
Var
    MyFile: TextFile;
Begin
    If IsCorrect Then
    Begin
        AssignFile(MyFile, FilePath, CP_UTF8);
        Try
            ReWrite(MyFile);
            Try
                Writeln(MyFile, MainForm.ResultLabel.Caption);
            Finally
                Close(MyFile);
            End;
            IfDataSavedInFile := True;
        Except
            MessageBox(0, 'Ошибка при записи в файл!', 'Ошибка', MB_ICONERROR);
            IsCorrect := False;
        End;
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

Procedure TMainForm.SequenceGridKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Const
    NULL_POINT: Word = 0;
Var
    Tempstr: String;
Begin
    If (Key = VK_BACK) Then
    Begin
        Tempstr := SequenceGrid.Cells[SequenceGrid.Col, SequenceGrid.Row];
        Delete(Tempstr, Length(Tempstr), 1);
        SequenceGrid.Cells[SequenceGrid.Col, SequenceGrid.Row] := Tempstr;

        ChangingEnabling(True, True);
        Key := NULL_POINT;
    End;
End;

Procedure TMainForm.SequenceGridKeyPress(Sender: TObject; Var Key: Char);
Const
    NULL_POINT: Char = #0;
    MAX_VALUE_LENGTH: Integer = 5;
    GOOD_VALUES: Set Of Char = ['0' .. '9'];
Var
    MinusCount: Integer;
Begin
    If (Key = '0') And (Length(SequenceGrid.Cells[SequenceGrid.Col, SequenceGrid.Row]) <> 0) And
        (SequenceGrid.Cells[SequenceGrid.Col, SequenceGrid.Row][1] = '-') Then
        Key := NULL_POINT;

    If (Key = '-') And (Length(SequenceGrid.Cells[SequenceGrid.Col, SequenceGrid.Row]) <> 0) Then
        Key := NULL_POINT;

    If (SequenceGrid.Cells[SequenceGrid.Col, SequenceGrid.Row] = '0') Then
        Key := NULL_POINT;

    If Not((Key In GOOD_VALUES) Or (Key = '-')) Then
        Key := NULL_POINT;

    If (Length(SequenceGrid.Cells[SequenceGrid.Col, SequenceGrid.Row]) > 0) And
        (SequenceGrid.Cells[SequenceGrid.Col, SequenceGrid.Row][1] = '-') Then
        MinusCount := 1
    Else
        MinusCount := 0;

    If (Length(SequenceGrid.Cells[SequenceGrid.Col, SequenceGrid.Row]) > MAX_VALUE_LENGTH + MinusCount) Then
        Key := NULL_POINT;

    If (Key <> NULL_POINT) Then
        SequenceGrid.Cells[SequenceGrid.Col, SequenceGrid.Row] := SequenceGrid.Cells[SequenceGrid.Col, SequenceGrid.Row] + Key;

    If Key <> NULL_POINT Then
        ChangingEnabling(True, True);
End;

Procedure TMainForm.SequenceGridKeyUp(Sender: TObject; Var Key: Word; Shift: TShiftState);
Var
    Col, HighCol: Integer;
    Temp: Boolean;
Begin
    Temp := True;
    HighCol := SequenceGrid.ColCount - 1;
    For Col := 1 To HighCol Do
        Temp := Not(MainForm.SequenceGrid.Cells[Col, 1] = '');

    ResultButton.Enabled := Temp;
End;

End.
