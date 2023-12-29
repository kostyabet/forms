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
    Public
        { Public declarations }
    End;

Const
    SIZE_MAX_LENGTH = 2;

Var
    MainForm: TMainForm;
    MinCount: Integer = 0;
    DataSaved: Boolean = False;
    Error: Integer = 0;

Implementation

{$R *.dfm}

Uses
    InstractionUnit,
    AboutEditorUnit;

Procedure DefultStringGrid();
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
    DefultStringGrid();

    GridMassive.Visible := True;
    ResultButton.Enabled := False;
End;

Function CulcRes(): String;
Var
    Sum, I: Integer;
Begin
    Sum := 0;
    For I := 1 To StrToInt(MainForm.MassiveSizeEdit.Text) Do
        If I Mod 2 <> 0 Then
            Sum := Sum + StrToInt(MainForm.GridMassive.Cells[I, 1]);

    CulcRes := IntToStr(Sum);
End;

Procedure TMainForm.ResultButtonClick(Sender: TObject);
Begin
    SaveMMButton.Enabled := True;
    ResultLabel.Caption := 'Сумма всех нечётных эллементов' + #13#10 + 'массива = ' + CulcRes;
End;

Procedure EnablingStatusCheck(ResultLabel: TLabel; ResultButton: TButton);
Begin
    ResultLabel.Caption := '';
    ResultButton.Enabled := False;
    MainForm.SaveMMButton.Enabled := False;
    MainForm.GridMassive.Visible := False;
    DataSaved := False;
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
    If (Length(Tempstr) >= 1) And (Tempstr[1] = '0') Then
        CheckDelete := False
    Else
        CheckDelete := True;
End;

Procedure TMainForm.MassiveSizeEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Var
    Temp: String;
    Cursor: Integer;
Begin
    TEdit(Sender).ReadOnly := (SsShift In Shift) Or (SsCtrl In Shift);

    If Key = VK_DELETE Then
        Key := 0;

    If (Key = VK_BACK) And (MassiveSizeEdit.SelText <> '') Then
    Begin
        Temp := MassiveSizeEdit.Text;
        MassiveSizeEdit.ClearSelection;
        If (Length(MassiveSizeEdit.Text) >= 1) And (MassiveSizeEdit.Text[1] = '0') Then
        Begin
            MassiveSizeEdit.Text := Temp;
            MassiveSizeEdit.SelStart := MassiveSizeEdit.SelStart + 1;
        End
        Else
            EnablingStatusCheck(ResultLabel, ResultButton);

        GridMassive.Visible := False;
        ResultButton.Enabled := False;
        Key := 0;
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

            EnablingStatusCheck(ResultLabel, ResultButton);
        End;
        Key := 0;
    End;

    If Key = VK_DOWN Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);
End;

Procedure CheckSelDelete();
Var
    Temp: String;
Begin
    MainForm.CreateMassiveButton.Caption := MainForm.MassiveSizeEdit.Seltext;
    Temp := MainForm.MassiveSizeEdit.Text;
    MainForm.MassiveSizeEdit.ClearSelection;
    If (Length(MainForm.MassiveSizeEdit.Text) >= 1) And (MainForm.MassiveSizeEdit.Text[1] = '0') Then
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
        EnablingStatusCheck(ResultLabel, ResultButton);
End;

Procedure TMainForm.FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
Var
    Key: Integer;
Begin
    Key := Application.Messagebox('Вы уверены, что хотите закрыть набор записей?', 'Выход', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);

    If (Key = ID_NO) Or DataSaved Or (ResultLabel.Caption = '') Then
        CanClose := False;

    If (ResultLabel.Caption <> '') And (Key = ID_YES) And Not(DataSaved) Then
    Begin
        Key := Application.Messagebox('Вы не сохранили результат. Хотите сделать это?', 'Сохранение',
            MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);
        If Key = ID_YES Then
            SaveMMButton.Click
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
    Signal: Boolean;
    TempSize, TestInt: INteger;
    I: Integer;
Begin
    Signal := True;
    Readln(TestFile, TempSize);
    If (TempSize < MIN_SIZE_VALUE) Or (TempSize > MAX_SIZE_VALUE) Then
        Signal := False;

    If Signal Then
        For I := 0 To TempSize - 1 Do
        Begin
            Read(TestFile, TestInt);
            If Not((TestInt > MIN_MASSIVE_VALUE) And (TestInt < MAX_MASSIVE_VALUE)) Then
                Signal := False;
        End;

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
    Readln(MyFile, Size);
    MainForm.Font.Color := ClBlack;
    MainForm.MassiveSizeEdit.Text := IntToStr(Size);
    MainForm.CreateMassiveButton.Click;
    InputMassive(MyFile, Size);
End;

Procedure ReadFromFile(IsCorrect: Boolean; FileWay: String);
Var
    MyFile: TextFile;
Begin
    If Not IsCorrect And (Error = 0) Then
        MessageBox(0, 'Данные в выбранном файле не корректны!', 'Ошибка', MB_ICONERROR);

    If (Error = 0) And IsCorrect Then
    Begin
        AssignFile(MyFile, FileWay);
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

        EnablingStatusCheck(ResultLabel, ResultButton);
        GridMassive.Visible := True;

        Key := NULL_POINT;
    End;
End;

Procedure TMainForm.GridMassiveKeyPress(Sender: TObject; Var Key: Char);
Const
    NULL_POINT: Char = #0;
    GOOD_VALUES: Set Of Char = ['0' .. '9'];
Var
    Minus: Integer;
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

    If (Length(GridMassive.Cells[GridMassive.Col, GridMassive.Row]) >= 1) And
        (GridMassive.Cells[GridMassive.Col, GridMassive.Row][1] = '-') Then
        Minus := 1
    Else
        Minus := 0;

    If (Length(GridMassive.Cells[GridMassive.Col, GridMassive.Row]) >= 6 + Minus) Then
        Key := NULL_POINT;

    If (Key <> NULL_POINT) Then
    Begin
        GridMassive.Cells[GridMassive.Col, GridMassive.Row] := GridMassive.Cells[GridMassive.Col, GridMassive.Row] + Key;

        EnablingStatusCheck(ResultLabel, ResultButton);
        GridMassive.Visible := True;
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
