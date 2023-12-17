Unit MainUnit;

Interface

Uses
    Clipbrd,
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
        ConditionLabel: TLabel;
        MainMenu: TMainMenu;
        FileMMButton: TMenuItem;
        OpenMMButton: TMenuItem;
        SaveMMButton: TMenuItem;
        LineMM: TMenuItem;
        CloseMMButton: TMenuItem;
        InstractionMMButton: TMenuItem;
        AboutEditorMMButton: TMenuItem;
        SubsequenceLabel: TLabel;
        SubsequenceEdit: TEdit;
        CreateSetButton: TButton;
        SaveDialog: TSaveDialog;
        OpenDialog: TOpenDialog;
        SetGrid: TStringGrid;
        ResultSetLabel: TLabel;
        CopyLabel: TLabel;
        Procedure SubsequenceEditKeyPress(Sender: TObject; Var Key: Char);
        Procedure SubsequenceEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure SubsequenceEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
        Procedure SubsequenceEditChange(Sender: TObject);
        Procedure CreateSetButtonClick(Sender: TObject);
        Procedure SetGridKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure OpenMMButtonClick(Sender: TObject);
        Procedure SaveMMButtonClick(Sender: TObject);
        Procedure CloseMMButtonClick(Sender: TObject);
        Procedure FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
        Procedure InstractionMMButtonClick(Sender: TObject);
        Procedure AboutEditorMMButtonClick(Sender: TObject);
    function FormHelp(Command: Word; Data: NativeInt;
      var CallHelp: Boolean): Boolean;
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Type
    TArrOfElements = Array Of AnsiChar;
    TAnsiChar = Set Of AnsiChar;

Const
    Entitlements: TAnsiChar = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '-', '*', '/', '^'];

Var
    MainForm: TMainForm;
    Error: Integer = 0;
    DataSaved: Boolean = False;

Implementation

{$R *.dfm}

Uses
    InstractionUnit,
    AboutEditorUnit;

Procedure VisibleControle(BoolParam: Boolean);
Begin
    MainForm.SetGrid.Visible := BoolParam;
    MainForm.ResultSetLabel.Visible := BoolParam;
    MainForm.CopyLabel.Visible := BoolParam;
    MainForm.SaveMMButton.Enabled := BoolParam;
End;

Procedure RenderingSet(ArrOfElements: TArrOfElements; Var ResultSet: TAnsiChar);
Var
    I: Integer;
Begin
    ResultSet := [];
    For I := 0 To High(ArrOfElements) Do
        If AnsiChar(ArrOfElements[I]) In Entitlements Then
            Include(ResultSet, ArrOfElements[I]);
End;

Procedure CreateArrOfElements(Var ArrOfElements: TArrOfElements; InputString: AnsiString);
Var
    I: Integer;
Begin
    For I := 1 To Length(InputString) Do
        ArrOfElements[I - 1] := AnsiChar(InputString[I]);
End;

Procedure InputInSetGrid(ResultSet: TAnsiChar);
Var
    Current: Char;
    I: Integer;
Begin
    I := 0;
    For Current In ResultSet Do
    Begin
        MainForm.SetGrid.ColCount := I + 1;
        MainForm.SetGrid.Cells[I, 0] := Current;
        Inc(I);
    End;

    If ResultSet = [] Then
        MainForm.CopyLabel.Caption := 'Пустое множество.';
End;

Procedure TMainForm.CreateSetButtonClick(Sender: TObject);
Var
    ArrOfElements: TArrOfElements;
    ResultSet: TAnsiChar;
Begin
    SetLength(ArrOfElements, Length(SubsequenceEdit.Text));
    CreateArrOfElements(ArrOfElements, AnsiString(SubsequenceEdit.Text));
    RenderingSet(ArrOfElements, ResultSet);
    InputInSetGrid(ResultSet);
    VisibleControle(True);
End;

Procedure TMainForm.SubsequenceEditChange(Sender: TObject);
Begin
    If (MainForm.SubsequenceEdit.Text <> '') Then
        MainForm.CreateSetButton.Enabled := True
    Else
        MainForm.CreateSetButton.Enabled := False;
End;

Procedure TMainForm.SubsequenceEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := False;
End;

Procedure TMainForm.SubsequenceEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    If (((Shift = [SsCtrl]) And (Key = Ord('V'))) Or ((Shift = [SsShift]) And (Key = VK_INSERT))) And
        (Length(Clipboard.AsText + SubsequenceEdit.Text) >= 50) Then
        Clipboard.AsText := '';

    if (Key = VK_BACK) or (Key = VK_DELETE) then
        VisibleControle(False);
        
    If (Key = VK_DOWN) Or (Key = VK_RETURN) Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);
End;

Procedure TMainForm.SubsequenceEditKeyPress(Sender: TObject; Var Key: Char);
Var
    I: Integer;
Begin
    CopyLabel.Caption := 'Вы можете копировать содержимое ячеек.';
    For I := 0 To SetGrid.ColCount - 1 Do
        SetGrid.Cells[I, 0] := '';
    SetGrid.ColCount := 1;

    If (Length(SubsequenceEdit.Text) >= 50) And (SubsequenceEdit.SelText = '') And (Key <> #08) Then
        Key := #0
    else
        VisibleControle(False);
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
        If DataSaved Or (SetGrid.Cells[0, 0] = '') Then
        Begin
            If Key = ID_NO Then
                CanClose := False
        End
        Else
            If SetGrid.Cells[0, 0] <> '' Then
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
    BufferStr: String;
    ReadStatus: Boolean;
Begin
    ReadStatus := True;

    Readln(TestFile, BufferStr);
    If Length(BufferStr) > 50 Then
        ReadStatus := False;

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

Procedure ReadFromFile(IsCorrect: Boolean; Error: Integer; FileWay: String);
Var
    MyFile: TextFile;
    BufferStr: String;
Begin
    If Not(IsCorrect) And (Error = 0) Then
        MessageBox(0, 'Данные в выбранном файле не корректны!', 'Ошибка', MB_ICONERROR)
    Else
    Begin
        AssignFile(MyFile, FileWay);
        Reset(MyFile);
        Readln(MyFile, BufferStr);
        MainForm.SubsequenceEdit.Text := BufferStr;
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

Procedure WriteInFile(Var MyFile: TextFile);
Var
    I: Integer;
    StrBuild: String;
Begin
    StrBuild := 'Ваш результат: ';
    If (MainForm.SetGrid.Cells[0, 0] <> '') Then
        For I := 0 To MainForm.SetGrid.ColCount - 1 Do
            StrBuild := StrBuild + ('''' + MainForm.SetGrid.Cells[I, 0] + '''; ')
    Else
        StrBuild := StrBuild + 'пустое множество.';

    Write(MyFile, StrBuild);
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
        WriteInFile(MyFile);
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

Procedure TMainForm.SetGridKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    If (Shift = [SsCtrl]) And (Key = Ord('C')) And (SetGrid.Cells[SetGrid.Col, SetGrid.Row] <> '') Then
    Begin
        Clipboard.AsText := SetGrid.Cells[SetGrid.Col, SetGrid.Row];
        CopyLabel.Caption := 'Число ''' + SetGrid.Cells[SetGrid.Col, SetGrid.Row] + ''' скопировано в буфер обмена.';
    End;
End;

End.
