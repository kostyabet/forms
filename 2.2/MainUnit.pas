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
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    MainForm: TMainForm;
    DataSaved: Boolean = False;
    MAX_N: Integer = 1000000;
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

Function CheckSum(Sum: Integer; K: Integer; NutNumb: Integer): Boolean;
Begin
    If K * Sum = NutNumb Then
        CheckSum := True
    Else
        CheckSum := False;
End;

Procedure SearchNum(K: Integer);
Var
    Sum, NutNumb, I: Integer;
Begin
    MainForm.ResultGrid.Cells[0, 0] := 'Числа';
    MainForm.ResultGrid.RowCount := 1;
    NutNumb := K;
    I := 1;
    While (NutNumb <= MAX_N) Do
    Begin
        Sum := SumOfDigits(NutNumb);
        If (CheckSum(Sum, K, NutNumb)) Then
        Begin
            MainForm.ResultGrid.Cells[I, 0] := IntToStr(NutNumb);
            Inc(I);
        End;
        NutNumb := NutNumb + K;
    End;
    MainForm.ResultGrid.ColCount := I;
End;

Procedure TMainForm.ResultButtonClick(Sender: TObject);
Begin
    SearchNum(StrToInt(KEdit.Text));
    SaveMMButton.Enabled := True;
    ResultGrid.Visible := True;
    CopyLabel.Visible := True;
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
    If (Length(TempStr) >= 1) And (Tempstr[1] = '0') Then
        CheckDelete := False
    Else
        CheckDelete := True;
End;

Procedure TMainForm.KEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := True;
End;

Procedure TMainForm.KEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    TEdit(Sender).ReadOnly := (SsShift In Shift) Or (SsCtrl In Shift);

    If Key = VK_DELETE Then
        Key := 0;

    If (Key = VK_BACK) And (KEdit.SelText <> '') Then
    Begin
        Var
        Temp := KEdit.Text;
        KEdit.ClearSelection;
        If (Length(KEdit.Text) >= 1) And (KEdit.Text[1] = '0') Then
        Begin
            KEdit.Text := Temp;
            KEdit.SelStart := KEdit.SelStart + 1;
            ResultGrid.Visible := False;
            ResultButton.Enabled := False;
        End;
        Key := 0;
    End;

    If (Key = VK_BACK) Then
    Begin
        Var
        Tempstr := KEdit.Text;
        Var
        Cursor := KEdit.SelStart;
        If CheckDelete(Tempstr, Cursor) Then
        Begin
            Delete(Tempstr, Cursor, 1);
            KEdit.Text := Tempstr;
            KEdit.SelStart := Cursor - 1;
            ResultGrid.Visible := False;
        End;
        Key := 0;
    End;

    If Key = VK_DOWN Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);
End;

Procedure TMainForm.KEditKeyPress(Sender: TObject; Var Key: Char);
Begin
    ResultGrid.Visible := False;

    If (Key = '0') And (KEdit.SelStart = 0) Then
        Key := #0;

    If Not(Key In ['0' .. '9']) Then
        Key := #0;

    If (KEdit.SelText <> '') And (Key <> #0) Then
        KEdit.ClearSelection;

    If Length(KEdit.Text) >= 4 Then
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
        If DataSaved Or (ResultGrid.Cells[1, 0] = '') Then
        Begin
            If Key = ID_NO Then
                CanClose := False
        End
        Else
            If ResultGrid.Cells[1, 0] <> '' Then
            Begin
                Key := Application.Messagebox('Вы не сохранили результат. Хотите сделать это?', 'Сохранение',
                    MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);
                If Key = ID_YES Then
                    SaveMMButton.Click;
            End;
    End;
End;

Function TryRead(Var TestFile: TextFile): Boolean;
Var
    BufferInt: Integer;
Begin
    Read(TestFile, BufferInt);
    If (BufferInt < 1) Or (BufferInt > 9999) Then
        TryRead := False
    Else
    Begin
        TryRead := True;
        MainForm.KEdit.Text := IntToStr(BufferInt);
    End;
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

Procedure TMainForm.OpenMMButtonClick(Sender: TObject);
Var
    IsCorrect: Boolean;
Begin
    Repeat
        If OpenDialog.Execute() Then
        Begin
            IsCorrect := IsCanRead(OpenDialog.FileName);
            If Not(IsCorrect) And (Error = 0) Then
                MessageBox(0, 'Данные в выбранном файле не корректны!', 'Ошибка', MB_ICONERROR);
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

Procedure InputInFile(IsCorrect: Boolean; FileName: String);
Var
    MyFile: TextFile;
    I: Integer;
Begin
    If IsCorrect Then
    Begin
        DataSaved := True;
        AssignFile(MyFile, FileName, CP_UTF8);
        ReWrite(MyFile);
        For I := 1 To MainForm.ResultGrid.ColCount - 1 Do
            Write(MyFile, MainForm.ResultGrid.Cells[I, 0] + ' ');
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

Procedure TMainForm.ResultGridKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    If (Shift = [SsCtrl]) And (Key = Ord('C')) Then
    Begin
        Clipboard.AsText := ResultGrid.Cells[ResultGrid.Col, ResultGrid.Row];
        CopyLabel.Caption := 'число ''' + ResultGrid.Cells[ResultGrid.Col, ResultGrid.Row] + ''' скопировано в буфер обмена.';
    End;
    If Not((Key = VK_RIGHT) Or (Key = VK_LEFT)) Then
        Key := 0;
End;

End.
