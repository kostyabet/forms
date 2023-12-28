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
    ResultButton.Enabled := False;
    GridMassive.ColCount := StrToInt(MassiveSizeEdit.Text) + 1;
    GridMassive.RowCount := 2;
    DefultStringGrid();
    GridMassive.Visible := True;
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
        Begin
            ResultLabel.Caption := '';
            SaveMMButton.Enabled := False;
            DataSaved := False;
        End;
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
            ResultLabel.Caption := '';
            SaveMMButton.Enabled := False;
            GridMassive.Visible := False;
            ResultButton.Enabled := False;
            DataSaved := False;
        End;
        Key := 0;
    End;

    If Key = VK_DOWN Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);
End;

Procedure CheckSelDelete();
Begin
    MainForm.CreateMassiveButton.Caption := MainForm.MassiveSizeEdit.Seltext;
    Var
    Temp := MainForm.MassiveSizeEdit.Text;
    MainForm.MassiveSizeEdit.ClearSelection;
    If (Length(MainForm.MassiveSizeEdit.Text) >= 1) And (MainForm.MassiveSizeEdit.Text[1] = '0') Then
        MainForm.MassiveSizeEdit.Text := Temp;

End;

Procedure TMainForm.MassiveSizeEditKeyPress(Sender: TObject; Var Key: Char);
Begin
    If (Key = '0') And (MassiveSizeEdit.SelStart = 0) Then
        Key := #0;

    If Not(Key In ['0' .. '9']) Then
        Key := #0;

    If (MassiveSizeEdit.SelText <> '') And (Key <> #0) Then
        MassiveSizeEdit.ClearSelection;

    If Length(MassiveSizeEdit.Text) >= 2 Then
        Key := #0;

    If Key <> #0 Then
    Begin
        ResultLabel.Caption := '';
        SaveMMButton.Enabled := False;
        GridMassive.Visible := False;
        ResultButton.Enabled := False;
        DataSaved := False;
    End;
End;

Procedure TMainForm.FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
Var
    Key: Integer;
Begin
    Key := Application.Messagebox('Вы уверены, что хотите закрыть набор записей?', 'Выход', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);

    If Key = ID_NO Then
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
Var
    Signal: Boolean;
    TempSize, TestInt: INteger;
    I: Integer;
Begin
    Signal := True;
    Readln(TestFile, TempSize);
    If (TempSize > 0) And (TempSize < 100) Then
    Begin
        For I := 0 To TempSize - 1 Do
        Begin
            Read(TestFile, TestInt);
            If Not((TestInt > -10000000) And (TestInt < 1000000)) Then
                Signal := False;
        End;
    End
    Else
        Signal := False;

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
    For I := 0 To Size - 1 Do
    Begin
        Read(MyFile, Count);
        MainForm.GridMassive.Cells[I + 1, 1] := IntToStr(Count);
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
        MessageBox(0, 'Данные в выбранном файле не корректны!', 'Ошибка', MB_ICONERROR)
    Else
        If (Error = 0) Then
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
Var
    CellText: String;
Begin
    If Key = VK_BACK Then
    Begin
        CellText := GridMassive.Cells[GridMassive.Col, GridMassive.Row];
        Delete(CellText, Length(GridMassive.Cells[GridMassive.Col, GridMassive.Row]), 1);
        GridMassive.Cells[GridMassive.Col, GridMassive.Row] := CellText;
        ResultLabel.Caption := '';
        ResultButton.Enabled := False;
        SaveMMButton.Enabled := False;
        DataSaved := False;
        Key := 0;
    End;
End;

Procedure TMainForm.GridMassiveKeyPress(Sender: TObject; Var Key: Char);
Var
    Minus: Integer;
Begin
    If (Key = '0') And (Length(GridMassive.Cells[GridMassive.Col, GridMassive.Row]) <> 0) And
        (GridMassive.Cells[GridMassive.Col, GridMassive.Row][1] = '-') Then
        Key := #0;

    If (Key = '-') And (Length(GridMassive.Cells[GridMassive.Col, GridMassive.Row]) <> 0) Then
        Key := #0;

    If (GridMassive.Cells[GridMassive.Col, GridMassive.Row] = '0') Or (GridMassive.Cells[GridMassive.Col, GridMassive.Row] = '-0') Then
        Key := #0;

    If Not((Key In ['0' .. '9']) Or (Key = '-')) Then
        Key := #0;

    If (Length(GridMassive.Cells[GridMassive.Col, GridMassive.Row]) >= 1) And
        (GridMassive.Cells[GridMassive.Col, GridMassive.Row][1] = '-') Then
        Minus := 1
    Else
        Minus := 0;

    If (Length(GridMassive.Cells[GridMassive.Col, GridMassive.Row]) >= 6 + Minus) Then
        Key := #0;

    If (Key <> #0) Then
    Begin
        GridMassive.Cells[GridMassive.Col, GridMassive.Row] := GridMassive.Cells[GridMassive.Col, GridMassive.Row] + Key;
        ResultLabel.Caption := '';
        ResultButton.Enabled := False;
        SaveMMButton.Enabled := False;
        DataSaved := False;
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
