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
    Vcl.Grids,
    Vcl.Menus;

Type
    TMainForm = Class(TForm)
        ConditionLabel: TLabel;
        SIzeInfoLabel: TLabel;
        CreateMassiveButton: TButton;
        SquareButton: TButton;
        ResultLabel: TLabel;
        PeaksGrid: TStringGrid;
        MainMenu: TMainMenu;
        FileMMButton: TMenuItem;
        InstractionMMButton: TMenuItem;
        OpenMMButton: TMenuItem;
        SaveMMButton: TMenuItem;
        LineMMButton: TMenuItem;
        CloseMMButton: TMenuItem;
        AboutEditorMMButton: TMenuItem;
        SaveDialog: TSaveDialog;
        OpenDialog: TOpenDialog;
        PeaksSizeEdit: TEdit;
        Procedure FormCreate(Sender: TObject);
        Procedure PeaksSizeEditChange(Sender: TObject);
        Procedure PeaksSizeEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
        Procedure PeaksSizeEditKeyPress(Sender: TObject; Var Key: Char);
        Procedure PeaksSizeEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure CreateMassiveButtonClick(Sender: TObject);
        Procedure PeaksGridKeyPress(Sender: TObject; Var Key: Char);
        Procedure PeaksGridKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure SquareButtonClick(Sender: TObject);
        Procedure InstractionMMButtonClick(Sender: TObject);
        Procedure AboutEditorMMButtonClick(Sender: TObject);
        Procedure OpenMMButtonClick(Sender: TObject);
        Procedure PeaksGridKeyUp(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure SaveMMButtonClick(Sender: TObject);
        Procedure FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
        Procedure CloseMMButtonClick(Sender: TObject);
    Private
        { Private declarations }
        IfDataSavedInFile: Boolean;
        Function CreateMultiResult(): String;
        Function CheckOneLine(): Boolean;
        Function IsExistRepeatPoints(): Boolean;
        Function IsExistSelfIntersection(): Boolean;
        Function ConditionCheck(): Boolean;
        Procedure DefultStringGrid();
        Procedure EnablingChange(PeaksGrid: Boolean = False; SquareButton: Boolean = False; ResultLabel: String = '';
            SaveMMButton: Boolean = False);
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

Procedure StringGridRowMake();
Var
    I: Integer;
Begin
    MainForm.PeaksGrid.RowCount := StrToInt(MainForm.PeaksSizeEdit.Text) + 1;
    For I := 1 To StrToInt(MainForm.PeaksSizeEdit.Text) Do
    Begin
        MainForm.PeaksGrid.Cells[0, I] := IntToStr(I);
        MainForm.PeaksGrid.Cells[1, I] := '';
        MainForm.PeaksGrid.Cells[2, I] := '';
    End;
End;

Procedure TMainForm.EnablingChange(PeaksGrid: Boolean = False; SquareButton: Boolean = False; ResultLabel: String = '';
    SaveMMButton: Boolean = False);
Begin
    MainForm.PeaksGrid.Visible := PeaksGrid;
    MainForm.SquareButton.Enabled := SquareButton;
    MainForm.ResultLabel.Caption := ResultLabel;
    MainForm.SaveMMButton.Enabled := SaveMMButton;
    IfDataSavedInFile := False;
End;

Procedure TMainForm.CreateMassiveButtonClick(Sender: TObject);
Begin
    StringGridRowMake();
    EnablingChange(True)
End;

Function TMainForm.CreateMultiResult(): String;
Var
    I, HighI: Integer;
    Area: Real;
Begin
    Area := 0.0;
    HighI := MainForm.PeaksGrid.RowCount - 2;
    For I := 1 To HighI Do
        Area := Area + (StrToInt(MainForm.PeaksGrid.Cells[1, I]) * StrToInt(MainForm.PeaksGrid.Cells[2, I + 1])) -
            (StrToInt(MainForm.PeaksGrid.Cells[1, I + 1]) * StrToInt(MainForm.PeaksGrid.Cells[2, I]));

    Area := Abs(Area + (StrToInt(MainForm.PeaksGrid.Cells[1, MainForm.PeaksGrid.RowCount - 1]) * StrToInt(MainForm.PeaksGrid.Cells[2, 1])) -
        (StrToInt(MainForm.PeaksGrid.Cells[1, 1]) * StrToInt(MainForm.PeaksGrid.Cells[2, MainForm.PeaksGrid.RowCount - 1])));
    Area := Area / 2;
    CreateMultiResult := FormatFloat('0.#####', Area);
End;

Function TMainForm.CheckOneLine(): Boolean;
Var
    SlpFact, YInter: Real;
    I, HighI: Integer;
    Signal, IsOnOneLine: Boolean;
Begin
    {$I-}
    Signal := True;
    HighI := MainForm.PeaksGrid.RowCount - 1;
    I := 3;
    While Signal And Not(I > HighI) Do
    Begin
        IsOnOneLine := StrToInt(MainForm.PeaksGrid.Cells[1, I - 1]) - StrToInt(MainForm.PeaksGrid.Cells[1, I - 2]) <> 0;
        If IsOnOneLine Then
        Begin
            SlpFact := (StrToInt(MainForm.PeaksGrid.Cells[2, I - 1]) - StrToInt(MainForm.PeaksGrid.Cells[2, I - 2])) /
                (StrToInt(MainForm.PeaksGrid.Cells[1, I - 1]) - StrToInt(MainForm.PeaksGrid.Cells[1, I - 2]));
            YInter := StrToInt(MainForm.PeaksGrid.Cells[2, I - 1]) - StrToInt(MainForm.PeaksGrid.Cells[1, I - 1]) * SlpFact;
            If (StrToInt(MainForm.PeaksGrid.Cells[2, I]) = SlpFact * StrToInt(MainForm.PeaksGrid.Cells[1, I]) + YInter) Then
            Begin
                MessageBox(0, 'Три точки не могут быть в одну линию!', 'Ошибка', MB_ICONERROR);
                Signal := False;
            End
        End
        Else
        Begin
            IsOnOneLine := (StrToInt(MainForm.PeaksGrid.Cells[1, I]) = StrToInt(MainForm.PeaksGrid.Cells[1, I - 1])) And
                (StrToInt(MainForm.PeaksGrid.Cells[1, I]) = StrToInt(MainForm.PeaksGrid.Cells[1, I - 2]));
            If IsOnOneLine Then
            Begin
                MessageBox(0, 'Три точки не могут быть в одну линию!', 'Ошибка', MB_ICONERROR);
                Signal := False;
            End;
        End;
        Inc(I);
    End;

    If IOResult <> 0 Then
    Begin
        MessageBox(0, 'Сбой при обработке ввода!', 'Ошибка', MB_ICONERROR);
        Signal := False;
    End;
    {$I+}
    CheckOneLine := Signal;
End;

Function TMainForm.IsExistRepeatPoints(): Boolean;
Var
    I, J, HighI, HighJ: Integer;
    Res: Boolean;
Begin
    {$I-}
    Res := True;
    HighI := MainForm.PeaksGrid.RowCount - 1;
    HighJ := MainForm.PeaksGrid.RowCount - 1;

    I := 1;
    While Res And Not(I > HighI) Do
    Begin
        J := I + 1;
        While Res And Not(J > HighJ) Do
        Begin
            Res := Not((StrToInt(MainForm.PeaksGrid.Cells[1, I]) = StrToInt(MainForm.PeaksGrid.Cells[1, J])) And
                (StrToInt(MainForm.PeaksGrid.Cells[2, I]) = StrToInt(MainForm.PeaksGrid.Cells[2, J])));

            Inc(J);
        End;

        Inc(I);
    End;

    If IOResult <> 0 Then
    Begin
        MessageBox(0, 'Сбой при обработке ввода!', 'Ошибка', MB_ICONERROR);
        Res := False;
    End
    Else
        If Not(Res) Then
            MessageBox(0, 'Точки должны быть уникальными!', 'Ошибка', MB_ICONERROR);
    {$I+}
    IsExistRepeatPoints := Res;
End;

Function TMainForm.IsExistSelfIntersection(): Boolean;
Var
    I, J, HighI, HighJ: Integer;
    IsCorrect: Boolean;
    ZCoef1, ZCoef2: Double;
    X1, Y1, X2, Y2: Integer;
Begin
    {$I-}
    IsCorrect := True;
    HighI := MainForm.PeaksGrid.RowCount - 4;
    HighJ := MainForm.PeaksGrid.RowCount - 2;
    For I := 1 To HighI Do
        For J := I + 2 To HighJ Do
        Begin
            X1 := StrToInt(MainForm.PeaksGrid.Cells[1, I + 1]) - StrToInt(MainForm.PeaksGrid.Cells[1, I]);
            Y1 := StrToInt(MainForm.PeaksGrid.Cells[2, I + 1]) - StrToInt(MainForm.PeaksGrid.Cells[2, I]);

            X2 := StrToInt(MainForm.PeaksGrid.Cells[1, J]) - StrToInt(MainForm.PeaksGrid.Cells[1, I]);
            Y2 := StrToInt(MainForm.PeaksGrid.Cells[2, J]) - StrToInt(MainForm.PeaksGrid.Cells[2, I]);
            ZCoef1 := X1 * Y2 - X2 * Y1;

            X2 := StrToInt(MainForm.PeaksGrid.Cells[1, J + 1]) - StrToInt(MainForm.PeaksGrid.Cells[1, I]);
            Y2 := StrToInt(MainForm.PeaksGrid.Cells[2, J + 1]) - StrToInt(MainForm.PeaksGrid.Cells[2, I]);
            ZCoef2 := X1 * Y2 - X2 * Y1;

            If ((ZCoef1 > 0) And (ZCoef2 < 0)) Or ((ZCoef1 < 0) And (ZCoef2 > 0)) Or (ZCoef1 = 0) Or (Zcoef2 = 0) Then
                IsCorrect := False;
        End;

    If IOResult <> 0 Then
    Begin
        MessageBox(0, 'Сбой при обработке ввода!', 'Ошибка', MB_ICONERROR);
        IsCorrect := False;
    End
    Else
        If Not(IsCorrect) Then
            MessageBox(0, 'Многоугольник не может быть с самопересечениями!', 'Ошибка', MB_ICONERROR);
    {$I+}
    IsExistSelfIntersection := IsCorrect;
End;

Function TMainForm.ConditionCheck(): Boolean;
Begin
    If CheckOneLine() And IsExistRepeatPoints() And IsExistSelfIntersection() Then
        ConditionCheck := True
    Else
        ConditionCheck := False;
End;

Procedure TMainForm.SquareButtonClick(Sender: TObject);
Begin
    If ConditionCheck() Then
    Begin
        ResultLabel.Caption := 'Площадь многоугольника = ' + CreateMultiResult();
        SaveMMButton.Enabled := True;
    End;
End;

Procedure TMainForm.PeaksSizeEditChange(Sender: TObject);
Const
    MIN_SIZE: Integer = 3;
Begin
    Try
        If StrToInt(PeaksSizeEdit.Text) < MIN_SIZE Then
            Raise Exception.Create('Значение меньше необходимого.');
        CreateMassiveButton.Enabled := True;
    Except
        CreateMassiveButton.Enabled := False;
    End;
End;

Procedure TMainForm.PeaksSizeEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := True;
End;

Function CheckDelete(Tempstr: TCaption; Cursor: Integer): Boolean;
Begin
    Delete(Tempstr, Cursor, 1);
    If (Length(Tempstr) > 0) And (Tempstr[1] = '0') Then
        CheckDelete := False
    Else
        CheckDelete := True;
End;

Procedure TMainForm.PeaksSizeEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Const
    NULL_POINT: Word = 0;
Var
    Tempstr: String;
    Cursor: Integer;
Begin
    TEdit(Sender).ReadOnly := (SsShift In Shift) Or (SsCtrl In Shift);

    If Key = VK_DELETE Then
        Key := NULL_POINT;

    If (Key = VK_BACK) And (PeaksSizeEdit.SelText <> '') Then
    Begin
        Tempstr := PeaksSizeEdit.Text;
        PeaksSizeEdit.ClearSelection;
        If (Length(PeaksSizeEdit.Text) > 0) And (PeaksSizeEdit.Text[1] = '0') Then
        Begin
            PeaksSizeEdit.Text := Tempstr;
            PeaksSizeEdit.SelStart := PeaksSizeEdit.SelStart + 1;
        End
        Else
            EnablingChange();

        Key := NULL_POINT;
    End;

    If (Key = VK_BACK) Then
    Begin
        Tempstr := PeaksSizeEdit.Text;
        Cursor := PeaksSizeEdit.SelStart;
        If CheckDelete(Tempstr, Cursor) Then
        Begin
            Delete(Tempstr, Cursor, 1);
            PeaksSizeEdit.Text := Tempstr;
            PeaksSizeEdit.SelStart := Cursor - 1;

            EnablingChange();
        End;
        Key := NULL_POINT;
    End;

    If Key = VK_DOWN Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);
End;

Procedure TMainForm.PeaksSizeEditKeyPress(Sender: TObject; Var Key: Char);
Const
    NULL_POINT: Char = #0;
    MAX_SIZE_LENGTH: Integer = 1;
    GOOD_VALUES: Set Of Char = ['0' .. '9'];
Begin
    If (Key = '0') And (PeaksSizeEdit.SelStart = 0) Then
        Key := NULL_POINT;

    If Not(Key In GOOD_VALUES) Then
        Key := NULL_POINT;

    If (PeaksSizeEdit.SelText <> '') And (Key <> NULL_POINT) Then
        PeaksSizeEdit.ClearSelection;

    If Length(PeaksSizeEdit.Text) > MAX_SIZE_LENGTH Then
        Key := NULL_POINT;

    If Key <> NULL_POINT Then
        EnablingChange();
End;

Procedure TMainForm.DefultStringGrid();
Begin
    MainForm.PeaksGrid.Cells[0, 0] := 'Вершина';
    MainForm.PeaksGrid.Cells[1, 0] := 'X';
    MainForm.PeaksGrid.Cells[2, 0] := 'Y';
    MainForm.PeaksGrid.ColCount := 3;
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

Procedure TMainForm.FormCreate(Sender: TObject);
Begin
    DefultStringGrid();
End;

Procedure TMainForm.InstractionMMButtonClick(Sender: TObject);
Begin
    Instraction.ShowModal;
End;

Function TryRead(Var TestFile: TextFile): Boolean;
Const
    MAX_SIZE: Integer = 99;
    MIN_SIZE: Integer = 3;
    MAX_VALUE: Integer = 1000000;
    MIN_VALUE: Integer = -1000000;
    SPACE_LIMIT: Integer = 4;
Var
    Res, IsNumeral: Boolean;
    BufferSize: Integer;
    BufferValue: Char;
    SpaceCount, NumCount: Integer;
Begin
    {$I-}
    Read(TestFile, BufferSize);

    Res := Not((BufferSize < MIN_SIZE) Or (BufferSize > MAX_SIZE));

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

        Res := Res And Not(NumCount > BufferSize * 2);
    End;
    Res := Res And Not(NumCount < BufferSize * 2);

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
        MainForm.PeaksGrid.Cells[1, I] := IntToStr(Count);
        Read(MyFile, Count);
        MainForm.PeaksGrid.Cells[2, I] := IntToStr(Count);
    End;
    MainForm.SquareButton.Enabled := True;
End;

Procedure ReadingPros(Var MyFile: TextFile);
Var
    Size: Integer;
Begin
    Read(MyFile, Size);
    MainForm.PeaksSizeEdit.Text := IntToStr(Size);
    MainForm.CreateMassiveButton.Click;
    InputMassive(MyFile, Size);
End;

Procedure ReadFromFile(Var IsCorrect: Boolean; FilePath: String);
Var
    MyFile: TextFile;
Begin
    If Not IsCorrect And (Error = 0) Then
        MessageBox(0, 'Данные в выбранном файле не корректны!', 'Ошибка', MB_ICONERROR);

    If (Error = 0) And IsCorrect Then
    Begin
        AssignFile(MyFile, FilePath, CP_UTF8);
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
        Except
            MessageBox(0, 'Ошибка при записи в файл!', 'Ошибка', MB_ICONERROR);
            IsCorrect := False;
        End;
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

Procedure TMainForm.AboutEditorMMButtonClick(Sender: TObject);
Begin
    AboutEditor.ShowModal;
End;

Procedure TMainForm.PeaksGridKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Const
    NULL_POINT: Word = 0;
Var
    Tempstr: String;
Begin
    If (Key = VK_BACK) Then
    Begin
        Tempstr := PeaksGrid.Cells[PeaksGrid.Col, PeaksGrid.Row];
        Delete(Tempstr, Length(Tempstr), 1);
        PeaksGrid.Cells[PeaksGrid.Col, PeaksGrid.Row] := Tempstr;

        EnablingChange(True, True);

        Key := NULL_POINT;
    End;
End;

Procedure TMainForm.PeaksGridKeyPress(Sender: TObject; Var Key: Char);
Const
    GOOD_VALUES: Set Of AnsiChar = ['0' .. '9'];
    NULL_POINT: Char = #0;
    VALUE_MAX_LENGTH: Integer = 3;
Var
    MinusCount: Integer;
    Row, Col: Integer;
Begin
    Col := PeaksGrid.Col;
    Row := PeaksGrid.Row;

    If (Key = '0') And (Length(PeaksGrid.Cells[Col, PeaksGrid.Row]) <> 0) And (PeaksGrid.Cells[Col, PeaksGrid.Row][1] = '-') Then
        Key := NULL_POINT;

    If (Key = '-') And (Length(PeaksGrid.Cells[Col, Row]) <> 0) Then
        Key := NULL_POINT;

    If (PeaksGrid.Cells[Col, Row] = '0') Or (PeaksGrid.Cells[Col, Row] = '-0') Then
        Key := NULL_POINT;

    If Not((Key In GOOD_VALUES) Or (Key = '-')) Then
        Key := NULL_POINT;

    If (Length(PeaksGrid.Cells[Col, Row]) > 0) And (PeaksGrid.Cells[Col, Row][1] = '-') Then
        MinusCount := 1
    Else
        MinusCount := 0;

    If (Length(PeaksGrid.Cells[Col, Row]) > VALUE_MAX_LENGTH + MinusCount) Then
        Key := NULL_POINT;

    If (Key <> NULL_POINT) Then
        PeaksGrid.Cells[Col, Row] := PeaksGrid.Cells[Col, Row] + Key;

    If (Key <> NULL_POINT) Then
        EnablingChange(True, True);
End;

Procedure TMainForm.PeaksGridKeyUp(Sender: TObject; Var Key: Word; Shift: TShiftState);
Var
    I, J: Integer;
Begin
    Try
        For I := 1 To 2 Do
            For J := 1 To StrToInt(PeaksSizeEdit.Text) Do
                StrToInt(PeaksGrid.Cells[I, J]);

        SquareButton.Enabled := True;
    Except
        SquareButton.Enabled := False;
    End;
End;

End.
