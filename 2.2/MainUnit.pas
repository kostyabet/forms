Unit MainUnit;

Interface

Uses
    Clipbrd,
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
    Vcl.Menus,
    Vcl.Grids,
    Vcl.MPlayer;

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
        KInfoLabel: TLabel;
        KEdit: TEdit;
        ResultButton: TButton;
        SaveDialog: TSaveDialog;
        OpenDialog: TOpenDialog;
        ResultGrid: TStringGrid;
        CopyLabel: TLabel;
        Procedure KEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
        Procedure KEditChange(Sender: TObject);
        Procedure InstractionMMButtonClick(Sender: TObject);
        Procedure AboutEditorMMButtonClick(Sender: TObject);
        Procedure KEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure KEditKeyPress(Sender: TObject; Var Key: Char);
        Procedure ResultButtonClick(Sender: TObject);
        Procedure OpenMMButtonClick(Sender: TObject);
        Procedure SaveMMButtonClick(Sender: TObject);
        Procedure FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
        Procedure CloseMMButtonClick(Sender: TObject);
        Procedure ResultGridKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
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

Function SumOfDigits(Num: Integer): Integer;
Var
    Sum: Integer;
Begin
    Sum := 0;

    While (Num >= 1) Do
    Begin
        Sum := Sum + (Num Mod 10);
        Num := Num Div 10;
    End;

    SumOfDigits := Sum;
End;

Function CheckSum(Sum: Integer; K: Integer; NaturalNumber: Integer): Boolean;
Begin
    CheckSum := K * Sum = NaturalNumber;
End;

Procedure SearchNum(K: Integer);
Const
    MAX_N: Integer = 1000000;
Var
    Sum, NaturalNumber, I: Integer;
Begin
    MainForm.ResultGrid.Cells[0, 0] := 'Числа';
    MainForm.ResultGrid.RowCount := 1;

    NaturalNumber := K;
    I := 1;

    While Not(NaturalNumber > MAX_N) Do
    Begin
        Sum := SumOfDigits(NaturalNumber);
        If (CheckSum(Sum, K, NaturalNumber)) Then
        Begin
            MainForm.ResultGrid.Cells[I, 0] := IntToStr(NaturalNumber);
            Inc(I);
        End;
        NaturalNumber := NaturalNumber + K;
    End;

    MainForm.ResultGrid.ColCount := I;
End;

Procedure ChangeEnabled(ResultGrid: Boolean = False; SaveMMButton: Boolean = False; CopyLabel: Boolean = False);
Begin
    MainForm.ResultGrid.Visible := ResultGrid;
    MainForm.SaveMMButton.Enabled := SaveMMButton;
    MainForm.CopyLabel.Visible := CopyLabel;
    IfDataSavedInFile := False;
End;

Procedure TMainForm.ResultButtonClick(Sender: TObject);
Begin
    SearchNum(StrToInt(KEdit.Text));

    ChangeEnabled(True, True, True);
End;

Procedure TMainForm.KEditChange(Sender: TObject);
Begin
    Try
        StrToInt(KEdit.Text);

        ResultButton.Enabled := True;
    Except
        ResultButton.Enabled := False;
    End;
End;

Function CheckDelete(Tempstr: Tcaption; Cursor: Integer): Boolean;
Begin
    Delete(Tempstr, Cursor, 1);
    If (Length(TempStr) > 0) And (Tempstr[1] = '0') Then
        CheckDelete := False
    Else
        CheckDelete := True;
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
        If (Length(KEdit.Text) > 0) And (KEdit.Text[1] = '0') Then
        Begin
            KEdit.Text := Temp;
            KEdit.SelStart := KEdit.SelStart + 1;
        End
        Else
            ChangeEnabled();

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

            ChangeEnabled();
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
    NULL_POINT: Char = #0;
    MAX_K_LENGTH: Integer = 3;
    GOOD_VALUES: Set Of Char = ['0' .. '9'];
Begin
    If (Key = '0') And (KEdit.SelStart = 0) Then
        Key := NULL_POINT;

    If Not(Key In GOOD_VALUES) Then
        Key := NULL_POINT;

    If (KEdit.SelText <> '') And (Key <> NULL_POINT) Then
        KEdit.ClearSelection;

    If Length(KEdit.Text) > MAX_K_LENGTH Then
        Key := NULL_POINT;

    If Key <> NULL_POINT Then
        ChangeEnabled();
End;

Procedure TMainForm.FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
Var
    ResultKey: Integer;
Begin
    ResultKey := Application.Messagebox('Вы уверены, что хотите закрыть оконное приложение?', 'Выход',
        MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);

    If ResultKey = ID_NO Then
        CanClose := False;

    If ResultGrid.Visible And (ResultKey = ID_YES) And Not IfDataSavedInFile Then
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
    MIN_K: Integer = 1;
    MAX_K: Integer = 9999;
Var
    BufferKStr: String;
Begin
    Read(TestFile, BufferKStr);
    StrToInt(BufferKStr);

    If (BufferKStr = '') Or (StrToInt(BufferKStr) < MIN_K) Or (StrToInt(BufferKStr) > MAX_K) Then
        TryRead := False
    Else
        TryRead := True;

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
        MainForm.KEdit.Text := IntToStr(BufferInt);
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
            ReadFromFile(IsCorrect, OpenDialog.FileName);
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
    I: Integer;
Begin
    If IsCorrect Then
    Begin
        AssignFile(MyFile, FilePath, CP_UTF8);
        ReWrite(MyFile);

        For I := 1 To MainForm.ResultGrid.ColCount - 1 Do
            Write(MyFile, MainForm.ResultGrid.Cells[I, 0] + ' ');

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

Procedure TMainForm.ResultGridKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Const
    NULL_POINTER: Word = 0;
Begin
    If (Shift = [SsCtrl]) And (Key = Ord('C')) Then
    Begin
        Clipboard.AsText := ResultGrid.Cells[ResultGrid.Col, ResultGrid.Row];
        CopyLabel.Caption := 'число ''' + ResultGrid.Cells[ResultGrid.Col, ResultGrid.Row] + ''' скопировано в буфер обмена.';
    End;

    If Not((Key = VK_RIGHT) Or (Key = VK_LEFT)) Then
        Key := NULL_POINTER;
End;

End.
