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
    InstractionUnit,
    AboutEditorUnit;

Procedure TMainForm.CreateMassiveButtonClick(Sender: TObject);
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
    SequenceGrid.Visible := True;
End;

Function IsArrIncreasing(): Boolean;
Var
    I: Integer;
    IsConditionYes: Boolean;
Begin
    IsConditionYes := True;

    For I := 2 To MainForm.SequenceGrid.ColCount - 1 Do
        If Not(MainForm.SequenceGrid.Cells[I, 1] <= MainForm.SequenceGrid.Cells[I - 1, 1]) Then
            IsConditionYes := False;

    IsArrIncreasing := IsConditionYes;
End;

Procedure TMainForm.ResultButtonClick(Sender: TObject);
Var
    Res: String;
Begin
    If IsArrIncreasing() Then
        Res := 'невозростающая.'
    Else
        Res := 'возростающая.';
    ResultLabel.Caption := 'Числовая последовательност ' + Res;
    SaveMMButton.Enabled := True;
    ResultLabel.Visible := True;
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
    If (Length(TempStr) >= 1) And (Tempstr[1] = '0') Then
        CheckDelete := False
    Else
        CheckDelete := True;
End;

Procedure TMainForm.NEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := True;
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
            SequenceGrid.Visible := False;
            ResultButton.Enabled := False;
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
            SequenceGrid.Visible := False;
            ResultButton.Enabled := False;
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
    SequenceGrid.Visible := False;
    ResultButton.Enabled := False;

    If (Key = '0') And (NEdit.SelStart = 0) Then
        Key := #0;

    If Not(Key In ['0' .. '9']) Then
        Key := #0;

    If (NEdit.SelText <> '') And (Key <> #0) Then
        NEdit.ClearSelection;

    If Length(NEdit.Text) >= 3 Then
        Key := #0;
End;

Procedure TMainForm.FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
Var
    Key: Integer;
Begin
    Key := Application.Messagebox('Вы уверены, что хотите закрыть набор записей?', 'Выход', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);

    If Key = ID_NO Then
        CanClose := False;

    If (ResultLabel.Caption <> '') And (Key = ID_YES) And Not DataSaved Then
    Begin
        Key := Application.Messagebox('Вы не сохранили результат. Хотите сделать это?', 'Сохранение',
            MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);

        If Key = ID_YES Then
            SaveMMButton.Click
    End;
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
        MainForm.SequenceGrid.Cells[I + 1, 1] := IntToStr(Count);
        MainForm.ResultButton.Enabled := True;
    End;
End;

Procedure ReadingPros(Var MyFile: TextFile);
Var
    Size: Integer;
Begin
    Read(MyFile, Size);
    MainForm.Font.Color := ClBlack;
    MainForm.NEdit.Text := IntToStr(Size);
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

Procedure TMainForm.SequenceGridKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    If (Key = VK_BACK) Then
    Begin
        Var
        Tempstr := SequenceGrid.Cells[SequenceGrid.Col, SequenceGrid.Row];
        Delete(Tempstr, Length(Tempstr), 1);
        SequenceGrid.Cells[SequenceGrid.Col, SequenceGrid.Row] := Tempstr;
        Key := 0;
    End;
End;

Procedure TMainForm.SequenceGridKeyPress(Sender: TObject; Var Key: Char);
Var
    Minus: Integer;
Begin
    If (Key = '0') And (Length(SequenceGrid.Cells[SequenceGrid.Col, SequenceGrid.Row]) <> 0) And
        (SequenceGrid.Cells[SequenceGrid.Col, SequenceGrid.Row][1] = '-') Then
        Key := #0;

    If (Key = '-') And (Length(SequenceGrid.Cells[SequenceGrid.Col, SequenceGrid.Row]) <> 0) Then
        Key := #0;

    If (SequenceGrid.Cells[SequenceGrid.Col, SequenceGrid.Row] = '0') Or
        (SequenceGrid.Cells[SequenceGrid.Col, SequenceGrid.Row] = '-0') Then
        Key := #0;

    If Not((Key In ['0' .. '9']) Or (Key = '-')) Then
        Key := #0;

    If (Length(SequenceGrid.Cells[SequenceGrid.Col, SequenceGrid.Row]) >= 1) And
        (SequenceGrid.Cells[SequenceGrid.Col, SequenceGrid.Row][1] = '-') Then
        Minus := 1
    Else
        Minus := 0;

    If (Length(SequenceGrid.Cells[SequenceGrid.Col, SequenceGrid.Row]) >= 6 + Minus) Then
        Key := #0;

    If (Key <> #0) Then
        SequenceGrid.Cells[SequenceGrid.Col, SequenceGrid.Row] := SequenceGrid.Cells[SequenceGrid.Col, SequenceGrid.Row] + Key;
End;

Procedure TMainForm.SequenceGridKeyUp(Sender: TObject; Var Key: Word; Shift: TShiftState);
Var
    Col: Integer;
    Temp: Boolean;
Begin
    Temp := True;
    For Col := 1 To SequenceGrid.ColCount - 1 Do
        If MainForm.SequenceGrid.Cells[Col, 1] = '' Then
            Temp := False;

    ResultButton.Enabled := Temp;
End;

End.
