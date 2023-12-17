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
    function FormHelp(Command: Word; Data: NativeInt;
      var CallHelp: Boolean): Boolean;
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

Procedure TMainForm.CreateMassiveButtonClick(Sender: TObject);
Begin
    MassiveGrid.ColCount := StrToInt(NEdit.Text) + 1;
    MassiveGrid.RowCount := 2;
    DefultStringGrid();
    MassiveGrid.Visible := True;
    SortButton.Visible := True;
    DeteilBitBtn.Visible := True;
End;

Procedure SortMassive(Var ArrOfNumb: TMassive);
Var
    Temp, I, J, K: Integer;
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
            For K := 1 To StepByStep.DetailGrid.ColCount - 1 Do
                StepByStep.DetailGrid.Cells[K, StepByStep.DetailGrid.RowCount - 1] := IntToStr(ArrOfNumb[K - 1]);
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

Procedure VisibleEnabledControl(Signal: Boolean);
Begin
    MainForm.SortInfoLabel.Visible := Signal;
    MainForm.SaveMMButton.Enabled := Signal;
    MainForm.DeteilBitBtn.Enabled := Signal;
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

    VisibleEnabledControl(True);
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
Begin
    TEdit(Sender).ReadOnly := (SsShift In Shift) Or (SsCtrl In Shift);

    If Key = VK_DELETE Then
        Key := 0;

    If (Key = VK_BACK) And (NEdit.SelText <> '') Then
    Begin
        Var
        Temp := NEdit.Text;
        NEdit.ClearSelection;
        If (Length(NEdit.Text) >= 1) And (NEdit.Text[1] = '0') Then
        Begin
            NEdit.Text := Temp;
            NEdit.SelStart := NEdit.SelStart + 1;
        End;
        Key := 0;
    End;

    If (Key = VK_BACK) Then
    Begin
        Var
        Tempstr := NEdit.Text;
        Var
        Cursor := NEdit.SelStart;
        If CheckDelete(Tempstr, Cursor) Then
        Begin
            Delete(Tempstr, Cursor, 1);
            NEdit.Text := Tempstr;
            NEdit.SelStart := Cursor - 1;
        End;
        Key := 0;
    End;

    If Key = VK_DOWN Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);
End;

Procedure TMainForm.NEditKeyPress(Sender: TObject; Var Key: Char);
Begin
    MassiveGrid.Visible := False;
    SortButton.Visible := False;
    DataSaved := False;
    VisibleEnabledControl(False);

    If (Key = '0') And (NEdit.SelStart = 0) Then
        Key := #0;

    If Not(Key In ['0' .. '9']) Then
        Key := #0;

    If (NEdit.SelText <> '') And (Key <> #0) Then
        NEdit.ClearSelection;

    If Length(NEdit.Text) >= 2 Then
        Key := #0;
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
        If DataSaved Or (SortInfoLabel.Visible = False) Then
        Begin
            If Key = ID_NO Then
                CanClose := False
        End
        Else
            If SortInfoLabel.Visible Then
            Begin
                Key := Application.Messagebox('Вы не сохранили результат. Хотите сделать это?', 'Сохранение',
                    MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);
                If Key = ID_YES Then
                    SaveMMButton.Click;
            End;
    End;
End;

function TMainForm.FormHelp(Command: Word; Data: NativeInt;
  var CallHelp: Boolean): Boolean;
begin
    CallHelp := False;
end;

Function TryRead(Var TestFile: TextFile): Boolean;
Var
    BufferInt, BufferCount, I: Integer;
    ReadStatus: Boolean;
Begin
    ReadStatus := True;
    Readln(TestFile, BufferInt);
    If (BufferInt < 1) Or (BufferInt > 99) Then
        ReadStatus := False
    Else
    Begin
        For I := 0 To BufferInt - 1 Do
        Begin
            Read(TestFile, BufferCount);
            If (BufferCount < -999999) Or (Buffercount > 999999) Then
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
    For I := 0 To Size - 1 Do
    Begin
        Read(MyFile, Count);
        MainForm.MassiveGrid.Cells[I + 1, 1] := IntToStr(Count);
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
    I, J: Integer;
    Res: String;
Begin
    Res := 'Отсортированный массив: ';
    For I := 1 To ResultGrid.ColCount - 1 Do
        Res := Res + ResultGrid.Cells[I, 1] + ' ';

    Res := Res + #13#10 + #13#10 + 'Пошаговая детализация' + #13#10;
    For I := 1 To StepByStep.RowCount - 1 Do
    Begin
        For J := 0 To StepByStep.ColCount - 1 Do
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
Var
    CellText: String;
Begin
    If Key = VK_BACK Then
    Begin
        CellText := MassiveGrid.Cells[MassiveGrid.Col, MassiveGrid.Row];
        Delete(CellText, Length(MassiveGrid.Cells[MassiveGrid.Col, MassiveGrid.Row]), 1);
        MassiveGrid.Cells[MassiveGrid.Col, MassiveGrid.Row] := CellText;

        Key := 0;
    End;
End;

Procedure TMainForm.MassiveGridKeyPress(Sender: TObject; Var Key: Char);
Var
    Minus: Integer;
Begin
    DataSaved := False;
    VisibleEnabledControl(False);

    If (Key = '0') And (Length(MassiveGrid.Cells[MassiveGrid.Col, MassiveGrid.Row]) <> 0) And
        (MassiveGrid.Cells[MassiveGrid.Col, MassiveGrid.Row][1] = '-') Then
        Key := #0;

    If (Key = '-') And (Length(MassiveGrid.Cells[MassiveGrid.Col, MassiveGrid.Row]) <> 0) Then
        Key := #0;

    If (MassiveGrid.Cells[MassiveGrid.Col, MassiveGrid.Row] = '0') Or (MassiveGrid.Cells[MassiveGrid.Col, MassiveGrid.Row] = '-0') Then
        Key := #0;

    If Not((Key In ['0' .. '9']) Or (Key = '-')) Then
        Key := #0;

    If (Length(MassiveGrid.Cells[MassiveGrid.Col, MassiveGrid.Row]) >= 1) And
        (MassiveGrid.Cells[MassiveGrid.Col, MassiveGrid.Row][1] = '-') Then
        Minus := 1
    Else
        Minus := 0;

    If (Length(MassiveGrid.Cells[MassiveGrid.Col, MassiveGrid.Row]) >= 6 + Minus) Then
        Key := #0;

    If (Key <> #0) Then
        MassiveGrid.Cells[MassiveGrid.Col, MassiveGrid.Row] := MassiveGrid.Cells[MassiveGrid.Col, MassiveGrid.Row] + Key;
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
