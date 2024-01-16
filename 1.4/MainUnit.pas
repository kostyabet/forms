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
    Vcl.Menus,
    Vcl.Grids;

Type
    TMainForm = Class(TForm)
        ConditionLabel: TLabel;
        SizeMassiveLabel: TLabel;
        MassiveSizeEdit: TEdit;
        MainMenu: TMainMenu;
        FileMMButton: TMenuItem;
        OpenMMButton: TMenuItem;
        SaveMMButton: TMenuItem;
        N4: TMenuItem;
        CloseMMButton: TMenuItem;
        InstractionMMButton: TMenuItem;
        AboutEditorMMButton: TMenuItem;
        CreateMassiveButton: TButton;
        ResultButton: TButton;
        GridMassive: TStringGrid;
        ResultLabel: TLabel;
        SaveDialog: TSaveDialog;
        OpenDialog: TOpenDialog;
        Procedure MassiveSizeEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
        Procedure MassiveSizeEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure InstractionMMButtonClick(Sender: TObject);
        Procedure AboutEditorMMButtonClick(Sender: TObject);
        Procedure MassiveSizeEditKeyPress(Sender: TObject; Var Key: Char);
        Procedure MassiveSizeEditChange(Sender: TObject);
        Procedure CreateMassiveButtonClick(Sender: TObject);
        Procedure ResultButtonClick(Sender: TObject);
        Procedure SaveMMButtonClick(Sender: TObject);
        Procedure OpenMMButtonClick(Sender: TObject);
        Procedure FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
        Procedure CloseMMButtonClick(Sender: TObject);
        Procedure GridMassiveKeyPress(Sender: TObject; Var Key: Char);
        Procedure GridMassiveKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure GridMassiveKeyUp(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Function FormHelp(Command: Word; Data: NativeInt; Var CallHelp: Boolean): Boolean;
    Private
        { Private declarations }
        Function CalculateRes(): Integer;
        Procedure CreateDefaultStringGrid();
        Procedure CheckSelDelete();
    Public
        { Public declarations }
    End;

Const
    SIZE_MAX_LENGTH = 2;

Var
    MainForm: TMainForm;
    MinCount: Integer = 0;
    IfDataSavedInFile: Boolean = False;
    Error: Integer = 0;

Implementation

{$R *.dfm}

Uses
    InstractionUnit,
    AboutEditorUnit;

Procedure TMainForm.CreateDefaultStringGrid();
Var
    Col: Integer;
Begin
    MainForm.GridMassive.Cells[0, 0] := '№';
    MainForm.GridMassive.Cells[0, 1] := 'Элемент';

    For Col := 1 To StrToInt(MainForm.MassiveSizeEdit.Text) Do
        MainForm.GridMassive.Cells[Col, 0] := IntToStr(Col);

    For Col := 1 To StrToInt(MainForm.MassiveSizeEdit.Text) Do
        MainForm.GridMassive.Cells[Col, 1] := '';

    MainForm.GridMassive.FixedCols := 1;
    MainForm.GridMassive.FixedRows := 1;
End;

Procedure TMainForm.CreateMassiveButtonClick(Sender: TObject);
Begin
    GridMassive.ColCount := StrToInt(MassiveSizeEdit.Text) + 1;
    GridMassive.RowCount := 2;
    CreateDefaultStringGrid();

    GridMassive.Visible := True;
    ResultButton.Enabled := False;
End;

Function TMainForm.CalculateRes(): Integer;
Var
    Sum, I: Integer;
Begin
    Sum := 0;
    Try
        For I := 1 To StrToInt(MainForm.MassiveSizeEdit.Text) Do
            If I Mod 2 <> 0 Then
                Sum := Sum + StrToInt(MainForm.GridMassive.Cells[I, 1]);
    Except
        Sum := -1;
    End;

    CalculateRes := Sum;
End;

Procedure TMainForm.ResultButtonClick(Sender: TObject);
Var
    ResultMessage: Integer;
Begin
    ResultMessage := CalculateRes;

    If ResultMessage = -1 Then
        ResultLabel.Caption := 'Ошибка при обработке результата.'
    Else
    Begin
        SaveMMButton.Enabled := True;
        ResultLabel.Caption := 'Сумма всех нечётных элементов' + #13#10 + 'массива = ' + IntToStr(ResultMessage);
    End;
End;

Procedure EnablingStatusCheck(GridMassive: Boolean = False; ResultLabel: String = ''; ResultButton: Boolean = False;
    SaveMMButton: Boolean = False);
Begin
    MainForm.ResultButton.Enabled := ResultButton;
    MainForm.SaveMMButton.Enabled := SaveMMButton;
    MainForm.GridMassive.Visible := GridMassive;
    MainForm.ResultLabel.Caption := ResultLabel;
    IfDataSavedInFile := False;
End;

Procedure TMainForm.MassiveSizeEditChange(Sender: TObject);
Begin
    Try
        StrToInt(MassiveSizeEdit.Text);

        CreateMassiveButton.Enabled := True;
    Except
        CreateMassiveButton.Enabled := False;
    End;
End;

Procedure TMainForm.MassiveSizeEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := True;
End;

Function CheckDelete(Tempstr: Tcaption; Cursor: Integer): Boolean;
Begin
    Delete(Tempstr, Cursor, 1);
    If (Length(Tempstr) > 0) And (Tempstr[1] = '0') Then
        CheckDelete := False
    Else
        CheckDelete := True;
End;

Procedure TMainForm.MassiveSizeEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Const
    NULL_POINT: Word = 0;
Var
    Temp: String;
    Cursor: Integer;
Begin
    TEdit(Sender).ReadOnly := (SsShift In Shift) Or (SsCtrl In Shift);

    If Key = VK_DELETE Then
        Key := NULL_POINT;

    If (Key = VK_BACK) And (MassiveSizeEdit.SelText <> '') Then
    Begin
        Temp := MassiveSizeEdit.Text;
        MassiveSizeEdit.ClearSelection;
        If (Length(MassiveSizeEdit.Text) > 0) And (MassiveSizeEdit.Text[1] = '0') Then
        Begin
            MassiveSizeEdit.Text := Temp;
            MassiveSizeEdit.SelStart := MassiveSizeEdit.SelStart + 1;
        End
        Else
            EnablingStatusCheck();

        Key := NULL_POINT;
    End;

    If (Key = VK_BACK) Then
    Begin
        Temp := MassiveSizeEdit.Text;
        Cursor := MassiveSizeEdit.SelStart;
        If CheckDelete(Temp, Cursor) Then
        Begin
            Delete(Temp, Cursor, 1);
            MassiveSizeEdit.Text := Temp;
            MassiveSizeEdit.SelStart := Cursor - 1;

            EnablingStatusCheck();
        End;
        Key := NULL_POINT;
    End;

    If Key = VK_DOWN Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);
End;

Procedure TMainForm.CheckSelDelete();
Var
    Temp: String;
Begin
    MainForm.CreateMassiveButton.Caption := MainForm.MassiveSizeEdit.Seltext;
    Temp := MainForm.MassiveSizeEdit.Text;
    MainForm.MassiveSizeEdit.ClearSelection;
    If (Length(MainForm.MassiveSizeEdit.Text) > 0) And (MainForm.MassiveSizeEdit.Text[1] = '0') Then
        MainForm.MassiveSizeEdit.Text := Temp;

End;

Procedure TMainForm.MassiveSizeEditKeyPress(Sender: TObject; Var Key: Char);
Const
    NULL_POINT: Char = #0;
    GOOD_VALUES: Set Of Char = ['0' .. '9'];
Begin
    If (Key = '0') And (MassiveSizeEdit.SelStart = 0) Then
        Key := NULL_POINT;

    If Not(Key In GOOD_VALUES) Then
        Key := NULL_POINT;

    If (MassiveSizeEdit.SelText <> '') And (Key <> NULL_POINT) Then
        MassiveSizeEdit.ClearSelection;

    If Length(MassiveSizeEdit.Text) >= SIZE_MAX_LENGTH Then
        Key := NULL_POINT;

    If Key <> NULL_POINT Then
        EnablingStatusCheck();
End;

Procedure TMainForm.FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
Var
    ResultKey: Integer;
Begin
    ResultKey := Application.Messagebox('Вы уверены, что хотите закрыть оконное приложение?', 'Выход',
        MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);

    If (ResultKey = ID_NO) Then
        CanClose := False;

    If (ResultLabel.Caption <> '') And (ResultKey = ID_YES) And Not(IfDataSavedInFile) Then
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
    MIN_SIZE_VALUE: Integer = 1;
    MAX_SIZE_VALUE: Integer = 99;
    MIN_MASSIVE_VALUE: Integer = -10000000;
    MAX_MASSIVE_VALUE: Integer = 10000000;
Var
    IsCorrect: Boolean;
    BufferSize, BufferValue: Integer;
    I: Integer;
Begin
    {$I-}
    Read(TestFile, BufferSize);

    IsCorrect := Not((BufferSize < MIN_SIZE_VALUE) Or (BufferSize > MAX_SIZE_VALUE));

    I := 1;
    While IsCorrect And Not(I > BufferSize) Do
    Begin
        Read(TestFile, BufferValue);

        IsCorrect := (BufferValue > MIN_MASSIVE_VALUE) And (BufferValue < MAX_MASSIVE_VALUE);

        Inc(I);
    End;

    IsCorrect := IsCorrect And SeekEOF(TestFile);

    TryRead := IsCorrect;
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
        MainForm.GridMassive.Cells[I, 1] := IntToStr(Count);

        MainForm.ResultButton.Enabled := True;
    End;
End;

Procedure ReadingPros(Var MyFile: TextFile);
Var
    Size: Integer;
Begin
    Read(MyFile, Size);
    MainForm.Font.Color := ClBlack;
    MainForm.MassiveSizeEdit.Text := IntToStr(Size);
    MainForm.CreateMassiveButton.Click;
    InputMassive(MyFile, Size);
End;

Procedure ReadFromFile(IsCorrect: Boolean; FilePath: String);
Var
    MyFile: TextFile;
Begin
    If Not IsCorrect And (Error = 0) Then
        MessageBox(0, 'Данные в выбранном файле не корректны!', 'Ошибка', MB_ICONERROR);

    If (Error = 0) And IsCorrect Then
    Begin
        AssignFile(MyFile, FilePath);
        Reset(MyFile);
        ReadingPros(MyFile);
        Close(Myfile);
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

Procedure InputInFile(IsCorrect: Boolean; FilePath: String);
Var
    MyFile: TextFile;
Begin
    If IsCorrect Then
    Begin
        IfDataSavedInFile := True;
        AssignFile(MyFile, FilePath, CP_UTF8);
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

Procedure TMainForm.GridMassiveKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Const
    NULL_POINT: Word = 0;
Var
    CellText: String;
Begin
    If Key = VK_BACK Then
    Begin
        CellText := GridMassive.Cells[GridMassive.Col, GridMassive.Row];
        Delete(CellText, Length(GridMassive.Cells[GridMassive.Col, GridMassive.Row]), 1);
        GridMassive.Cells[GridMassive.Col, GridMassive.Row] := CellText;

        EnablingStatusCheck(True);

        Key := NULL_POINT;
    End;
End;

Procedure TMainForm.GridMassiveKeyPress(Sender: TObject; Var Key: Char);
Const
    NULL_POINT: Char = #0;
    GOOD_VALUES: Set Of Char = ['0' .. '9'];
    MAX_VALUE_LEN: Integer = 5;
Var
    MinusCount: Integer;
Begin
    If (Key = '0') And (Length(GridMassive.Cells[GridMassive.Col, GridMassive.Row]) <> 0) And
        (GridMassive.Cells[GridMassive.Col, GridMassive.Row][1] = '-') Then
        Key := NULL_POINT;

    If (Key = '-') And (Length(GridMassive.Cells[GridMassive.Col, GridMassive.Row]) <> 0) Then
        Key := NULL_POINT;

    If GridMassive.Cells[GridMassive.Col, GridMassive.Row] = '0' Then
        Key := NULL_POINT;

    If Not((Key In GOOD_VALUES) Or (Key = '-')) Then
        Key := NULL_POINT;

    If (Length(GridMassive.Cells[GridMassive.Col, GridMassive.Row]) > 0) And
        (GridMassive.Cells[GridMassive.Col, GridMassive.Row][1] = '-') Then
        MinusCount := 1
    Else
        MinusCount := 0;

    If (Length(GridMassive.Cells[GridMassive.Col, GridMassive.Row]) > MAX_VALUE_LEN + MinusCount) Then
        Key := NULL_POINT;

    If (Key <> NULL_POINT) Then
    Begin
        GridMassive.Cells[GridMassive.Col, GridMassive.Row] := GridMassive.Cells[GridMassive.Col, GridMassive.Row] + Key;

        EnablingStatusCheck(True);
    End;
End;

Procedure TMainForm.GridMassiveKeyUp(Sender: TObject; Var Key: Word; Shift: TShiftState);
Var
    Col: Integer;
Begin
    Try
        For Col := 1 To StrToInt(MainForm.MassiveSizeEdit.Text) Do
            StrToInt(MainForm.GridMassive.Cells[Col, 1]);

        ResultButton.Enabled := True;
    Except
        ResultButton.Enabled := False;
    End;
End;

End.
