﻿Unit MainUnit;

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
    Vcl.Grids,
    Vcl.Buttons;

Type
    TMassive = Array Of Integer;

    TMainForm = Class(TForm)
        ConditionLabel: TLabel;
        NInfoLabel: TLabel;
        NEdit: TEdit;
        CreateMassiveButton: TButton;
        MassiveGrid: TStringGrid;
        SortButton: TButton;
        SortInfoLabel: TLabel;
        MainMenu: TMainMenu;
        FileMMButton: TMenuItem;
        OpenMMButton: TMenuItem;
        SaveMMButton: TMenuItem;
        LineMM: TMenuItem;
        CloseMMButton: TMenuItem;
        InstractionMMButton: TMenuItem;
        AboutEditorMMButton: TMenuItem;
        OpenDialog: TOpenDialog;
        SaveDialog: TSaveDialog;
        DeteilBitBtn: TBitBtn;
        Procedure NEditChange(Sender: TObject);
        Procedure NEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
        Procedure NEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure NEditKeyPress(Sender: TObject; Var Key: Char);
        Procedure CreateMassiveButtonClick(Sender: TObject);
        Procedure MassiveGridKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure MassiveGridKeyPress(Sender: TObject; Var Key: Char);
        Procedure MassiveGridKeyUp(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure SortButtonClick(Sender: TObject);
        Procedure InstractionMMButtonClick(Sender: TObject);
        Procedure AboutEditorMMButtonClick(Sender: TObject);
        Procedure OpenMMButtonClick(Sender: TObject);
        Procedure DeteilBitBtnClick(Sender: TObject);
        Procedure SaveMMButtonClick(Sender: TObject);
        Procedure FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
        Function FormHelp(Command: Word; Data: NativeInt; Var CallHelp: Boolean): Boolean;
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    MainForm: TMainForm;
    Error: Integer = 0;
    DataSaved: Boolean = False;

Implementation

{$R *.dfm}

Uses
    InstractionUnit,
    AboutEditorUnit,
    StepByStepUnit;

Procedure DefultStringGrid();
Var
    Col: Integer;
Begin
    MainForm.MassiveGrid.Cells[0, 0] := '№';
    MainForm.MassiveGrid.Cells[0, 1] := 'Элемент';

    For Col := 1 To StrToInt(MainForm.NEdit.Text) Do
        MainForm.MassiveGrid.Cells[Col, 0] := IntToStr(Col);

    For Col := 1 To StrToInt(MainForm.NEdit.Text) Do
        MainForm.MassiveGrid.Cells[Col, 1] := '';

    MainForm.MassiveGrid.FixedCols := 1;
    MainForm.MassiveGrid.FixedRows := 1;
End;

Procedure TMainForm.DeteilBitBtnClick(Sender: TObject);
Begin
    StepByStep.ShowModal;
End;

Procedure VisibleEnabledControl(MassiveGrid: Boolean = False; SortButton: Boolean = False; SortInfoLabel: Boolean = False;
    SaveMMButton: Boolean = False; DeteilBitBtn: Boolean = False);
Begin
    MainForm.MassiveGrid.Visible := MassiveGrid;
    MainForm.SortButton.Visible := SortButton;
    MainForm.SortInfoLabel.Visible := SortInfoLabel;
    MainForm.SaveMMButton.Enabled := SaveMMButton;
    MainForm.DeteilBitBtn.Enabled := DeteilBitBtn;
    DataSaved := False;
End;

Procedure TMainForm.CreateMassiveButtonClick(Sender: TObject);
Begin
    MassiveGrid.ColCount := StrToInt(NEdit.Text) + 1;
    MassiveGrid.RowCount := 2;
    DefultStringGrid();

    VisibleEnabledControl(True, True);
End;

Procedure SortMassive(Var ArrOfNumb: TMassive);
Var
    Temp, I, J, K, HighK, RowK: Integer;
Begin
    For I := 1 To High(ArrOfNumb) Do
    Begin
        Temp := ArrOfNumb[I];

        J := I - 1;
        While (J >= 0) And (ArrOfNumb[J] > Temp) Do
        Begin
            ArrOfNumb[J + 1] := ArrOfNumb[J];
            ArrOfNumb[J] := Temp;
            Dec(J);

            StepByStep.DetailGrid.RowCount := StepByStep.DetailGrid.RowCount + 1;
            StepByStep.DetailGrid.Cells[0, StepByStep.DetailGrid.RowCount - 1] := IntToStr(StepByStep.DetailGrid.RowCount - 2) + '.';
            HighK := StepByStep.DetailGrid.ColCount - 1;
            RowK := StepByStep.DetailGrid.RowCount - 1;
            For K := 1 To HighK Do
                StepByStep.DetailGrid.Cells[K, RowK] := IntToStr(ArrOfNumb[K - 1]);
        End;
    End;
End;

Procedure CreateMassive(Var ArrOfNumb: TMassive);
Var
    I: Integer;
Begin
    For I := 0 To High(ArrOfNumb) Do
    Begin
        ArrOfNumb[I] := StrToInt(MainForm.MassiveGrid.Cells[I + 1, 1]);
        StepByStep.DetailGrid.Cells[I + 1, 1] := IntToStr(ArrOfNumb[I]);
    End;
End;

Procedure OutputInGrid(Var ArrOfNumb: TMassive);
Var
    I: Integer;
Begin
    For I := 0 To High(ArrOfNumb) Do
        MainForm.MassiveGrid.Cells[I + 1, 1] := IntToStr(ArrOfNumb[I]);
End;

Procedure StepByStepPreparation(StrGrd: TStringGrid);
Var
    I: Integer;
Begin
    StrGrd.ColCount := StrToInt(MainForm.NEdit.Text) + 1;
    StrGrd.Cells[0, 0] := '№';
    StrGrd.Cells[0, 1] := '0.';

    StrGrd.RowCount := 2;

    For I := 1 To StrGrd.ColCount Do
    Begin
        StrGrd.Cells[I, 0] := 'a[' + IntToStr(I - 1) + ']';
        StrGrd.Cells[I, 1] := '';
    End;
End;

Procedure TMainForm.SortButtonClick(Sender: TObject);
Var
    ArrOfNumb: TMassive;
Begin
    SetLength(ArrOfNumb, StrToInt(NEdit.Text));
    StepByStepPreparation(StepByStep.DetailGrid);
    CreateMassive(ArrOfNumb);

    SortMassive(ArrOfNumb);

    OutputInGrid(ArrOfNumb);

    VisibleEnabledControl(True, True, True, True, True);
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

Procedure TMainForm.NEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
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
        If (Length(NEdit.Text) >= 1) And (NEdit.Text[1] = '0') Then
        Begin
            NEdit.Text := Temp;
            NEdit.SelStart := NEdit.SelStart + 1;

            VisibleEnabledControl();
        End;

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

            VisibleEnabledControl();
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
    MAX_N_LENGTH: Integer = 2;
    GOOD_VALUES: Set Of Char = ['0' .. '9'];
Begin
    If (Key = '0') And (NEdit.SelStart = 0) Then
        Key := NULL_POINT;

    If Not(Key In GOOD_VALUES) Then
        Key := NULL_POINT;

    If (NEdit.SelText <> '') And (Key <> NULL_POINT) Then
        NEdit.ClearSelection;

    If Length(NEdit.Text) >= MAX_N_LENGTH Then
        Key := NULL_POINT;

    If Key <> NULL_POINT Then
        VisibleEnabledControl();
End;

Procedure TMainForm.FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
Var
    Key: Integer;
Begin
    Key := Application.Messagebox('Вы уверены, что хотите закрыть набор записей?', 'Выход', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);

    If Key = ID_NO Then
        CanClose := False;

    If SortInfoLabel.Visible And (Key = ID_YES) And Not DataSaved Then
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
    MIN_N: Integer = 1;
    MAX_N: Integer = 99;
    MIN_VALUE: Integer = -999999;
    MAX_VALUE: Integer = 999999;
Var
    BufferInt, BufferCount, I: Integer;
    ReadStatus: Boolean;
Begin
    ReadStatus := True;
    Readln(TestFile, BufferInt);
    If (BufferInt < MIN_N) Or (BufferInt > MAX_N) Then
        ReadStatus := False;

    If ReadStatus Then
    Begin
        For I := 1 To BufferInt Do
        Begin
            Read(TestFile, BufferCount);
            If (BufferCount < MIN_VALUE) Or (Buffercount > MAX_VALUE) Then
                ReadStatus := False;
        End
    End;

    TryRead := ReadStatus;
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

Procedure ReadMassive(Var MyFile: TextFile);
Var
    I, Size, Count: Integer;
Begin
    Readln(MyFile, Size);
    MainForm.NEdit.Text := IntToStr(Size);
    MainForm.CreateMassiveButton.Click;
    For I := 1 To Size Do
    Begin
        Read(MyFile, Count);
        MainForm.MassiveGrid.Cells[I, 1] := IntToStr(Count);
    End;
    MainForm.SortButton.Enabled := True;
End;

Procedure ReadFromFile(IsCorrect: Boolean; Error: Integer; FileWay: String);
Var
    MyFile: TextFile;
Begin
    If Not(IsCorrect) And (Error = 0) Then
        MessageBox(0, 'Данные в выбранном файле не корректны!', 'Ошибка', MB_ICONERROR)
    Else
    Begin
        AssignFile(MyFile, FileWay);
        Reset(MyFile);
        ReadMassive(MyFile);
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

Procedure WriteInFile(Var MyFile: TextFile; StepByStep: TStringGrid; ResultGrid: TStringGrid);
Var
    I, J, HighI, HighJ: Integer;
    Res: String;
Begin
    Res := 'Отсортированный массив: ';
    HighI := ResultGrid.ColCount - 1;
    For I := 1 To HighI Do
        Res := Res + ResultGrid.Cells[I, 1] + ' ';

    Res := Res + #13#10 + #13#10 + 'Пошаговая детализация' + #13#10;
    HighI := StepByStep.RowCount - 1;
    HighJ := StepByStep.ColCount - 1;
    For I := 1 To HighI Do
    Begin
        For J := 0 To HighJ Do
            Res := Res + StepByStep.Cells[J, I] + ' ';
        Res := Res + #13#10;
    End;

    Write(MyFile, Res);
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
        WriteInFile(MyFile, StepByStep.DetailGrid, MainForm.MassiveGrid);
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

Procedure TMainForm.InstractionMMButtonClick(Sender: TObject);
Begin
    Instraction.ShowModal;
End;

Procedure TMainForm.AboutEditorMMButtonClick(Sender: TObject);
Begin
    AboutEditor.ShowModal;
End;

Procedure TMainForm.MassiveGridKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Const
    NULL_POINT: Word = 0;
Var
    CellText: String;
Begin
    If Key = VK_BACK Then
    Begin
        CellText := MassiveGrid.Cells[MassiveGrid.Col, MassiveGrid.Row];
        Delete(CellText, Length(MassiveGrid.Cells[MassiveGrid.Col, MassiveGrid.Row]), 1);
        MassiveGrid.Cells[MassiveGrid.Col, MassiveGrid.Row] := CellText;

        VisibleEnabledControl(True, True);

        Key := NULL_POINT;
    End;
End;

Procedure TMainForm.MassiveGridKeyPress(Sender: TObject; Var Key: Char);
Const
    NULL_POINT: Char = #0;
    GOOD_VALUES: Set Of Char = ['0' .. '9'];
    MAX_VALUE_LEN: Integer = 6;
Var
    MinusCount: Integer;
Begin
    If (Key = '0') And (Length(MassiveGrid.Cells[MassiveGrid.Col, MassiveGrid.Row]) <> 0) And
        (MassiveGrid.Cells[MassiveGrid.Col, MassiveGrid.Row][1] = '-') Then
        Key := NULL_POINT;

    If (Key = '-') And (Length(MassiveGrid.Cells[MassiveGrid.Col, MassiveGrid.Row]) <> 0) Then
        Key := NULL_POINT;

    If (MassiveGrid.Cells[MassiveGrid.Col, MassiveGrid.Row] = '0') Then
        Key := NULL_POINT;

    If Not((Key In GOOD_VALUES) Or (Key = '-')) Then
        Key := NULL_POINT;

    If (Length(MassiveGrid.Cells[MassiveGrid.Col, MassiveGrid.Row]) >= 1) And
        (MassiveGrid.Cells[MassiveGrid.Col, MassiveGrid.Row][1] = '-') Then
        MinusCount := 1
    Else
        MinusCount := 0;

    If (Length(MassiveGrid.Cells[MassiveGrid.Col, MassiveGrid.Row]) >= MAX_VALUE_LEN + MinusCount) Then
        Key := NULL_POINT;

    If (Key <> NULL_POINT) Then
        MassiveGrid.Cells[MassiveGrid.Col, MassiveGrid.Row] := MassiveGrid.Cells[MassiveGrid.Col, MassiveGrid.Row] + Key;

    If (Key <> NULL_POINT) Then
        VisibleEnabledControl(True, True);
End;

Procedure TMainForm.MassiveGridKeyUp(Sender: TObject; Var Key: Word; Shift: TShiftState);
Var
    Col: Integer;
Begin
    Try
        For Col := 1 To StrToInt(MainForm.NEdit.Text) Do
            StrToInt(MainForm.MassiveGrid.Cells[Col, 1]);

        SortButton.Enabled := True;
    Except
        SortButton.Enabled := False;
    End;
End;

End.
