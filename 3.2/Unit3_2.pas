Unit Unit3_2;

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
    TForm1 = Class(TForm)
        Label1: TLabel;
        MainMenu1: TMainMenu;
        N1: TMenuItem;
        N2: TMenuItem;
        N3: TMenuItem;
        N4: TMenuItem;
        N5: TMenuItem;
        N6: TMenuItem;
        N7: TMenuItem;
        Label2: TLabel;
        Edit1: TEdit;
        Button1: TButton;
        SaveDialog1: TSaveDialog;
        OpenDialog1: TOpenDialog;
        StringGrid1: TStringGrid;
        Label3: TLabel;
        Label4: TLabel;
        Procedure Edit1KeyPress(Sender: TObject; Var Key: Char);
        Procedure Edit1KeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure Edit1ContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
        Procedure Edit1Change(Sender: TObject);
        Procedure Button1Click(Sender: TObject);
        Procedure StringGrid1KeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure N2Click(Sender: TObject);
        Procedure N3Click(Sender: TObject);
        Procedure N5Click(Sender: TObject);
        Procedure FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Type
    TArrOfElements = Array Of Char;
    TAnsiChar = Set Of AnsiChar;

Const
    Entitlements: TAnsiChar = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '-', '*', '/'];

Var
    Form1: TForm1;
    Error: Integer = 0;
    DataSaved: Boolean = False;

Implementation

{$R *.dfm}

Procedure VisibleControle(BoolParam: Boolean);
Begin
    Form1.StringGrid1.Visible := BoolParam;
    Form1.Label3.Visible := BoolParam;
    Form1.Label4.Visible := BoolParam;
    Form1.N3.Enabled := BoolParam;
End;

Procedure RenderingSet(ArrOfElements: TArrOfElements; Var ResultSet: TAnsiChar);
Var
    I: Integer;
Begin
    ResultSet := [];
    For I := 0 To High(ArrOfElements) Do
        If AnsiChar(ArrOfElements[I]) In Entitlements Then
            Include(ResultSet, AnsiChar(ArrOfElements[I]));
End;

Procedure CreateArrOfElements(Var ArrOfElements: TArrOfElements; InputString: String);
Var
    I: Integer;
Begin
    For I := 1 To Length(InputString) Do
        ArrOfElements[I - 1] := InputString[I];
End;

Procedure InputInSetGrid(ResultSet: TAnsiChar);
Var
    Current: Char;
    I: Integer;
Begin
    I := 0;
    For Current In ResultSet Do
    Begin
        Form1.StringGrid1.ColCount := I + 1;
        Form1.StringGrid1.Cells[I, 0] := Current;
        Inc(I);
    End;

    if ResultSet = [] then
        Form1.Label4.Caption := 'Пустое множество.';
End;

Procedure TForm1.Button1Click(Sender: TObject);
Var
    ArrOfElements: TArrOfElements;
    ResultSet: TAnsiChar;
Begin
    SetLength(ArrOfElements, Length(Edit1.Text));
    CreateArrOfElements(ArrOfElements, Edit1.Text);
    RenderingSet(ArrOfElements, ResultSet);
    InputInSetGrid(ResultSet);
    VisibleControle(True);
End;

Procedure TForm1.Edit1Change(Sender: TObject);
Begin
    If (Form1.Edit1.Text <> '') Then
        Form1.Button1.Enabled := True
    Else
        Form1.Button1.Enabled := False;
End;

Procedure TForm1.Edit1ContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := False;
End;

Procedure TForm1.Edit1KeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    If (Key = VK_DOWN) Or (Key = VK_RETURN) Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);
End;

Procedure TForm1.Edit1KeyPress(Sender: TObject; Var Key: Char);
var
    I : integer;
Begin
    VisibleControle(False);
    Label4.Caption := 'Вы можете копировать содержимое ячеек.';
    For I := 0 To StringGrid1.ColCount - 1 Do
        StringGrid1.Cells[I, 0] := '';
    StringGrid1.ColCount := 1;

    If (Length(Edit1.Text) >= 50) And (Edit1.SelText = '') And (Key <> #08) Then
        Key := #0;
End;

Procedure TForm1.FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
Var
    Key: Integer;
Begin
    Key := Application.Messagebox('Вы уверены, что хотите закрыть набор записей?', 'Выход', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);
    If Key = ID_NO Then
        CanClose := False
    Else
    Begin
        If DataSaved Or (StringGrid1.Cells[0, 0] = '') Then
        Begin
            If Key = ID_NO Then
                CanClose := False
        End
        Else
            If StringGrid1.Cells[0, 0] <> '' Then
            Begin
                Key := Application.Messagebox('Вы не сохранили результат. Хотите сделать это?', 'Сохранение',
                    MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);
                If Key = ID_YES Then
                    N3.Click;
            End;
    End;
End;

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
        Form1.Edit1.Text := BufferStr;
        Close(MyFile);
    End;
End;

Procedure TForm1.N2Click(Sender: TObject);
Var
    IsCorrect: Boolean;
Begin
    Repeat
        If OpenDialog1.Execute() Then
        Begin
            IsCorrect := IsCanRead(OpenDialog1.FileName);
            ReadFromFile(IsCorrect, Error, OpenDialog1.FileName);
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
    If (Form1.StringGrid1.Cells[0, 0] <> '') Then
        For I := 0 To Form1.StringGrid1.ColCount - 1 Do
            StrBuild := StrBuild + ('''' + Form1.StringGrid1.Cells[I, 0] + '''; ')
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

Procedure TForm1.N3Click(Sender: TObject);
Var
    IsCorrect: Boolean;
Begin
    Repeat
        If SaveDialog1.Execute Then
        Begin
            IsCorrect := IsCanWrite(SaveDialog1.FileName);
            InputInFile(IsCorrect, SaveDialog1.FileName);
        End
        Else
            IsCorrect := True;
    Until IsCorrect;
End;

Procedure TForm1.N5Click(Sender: TObject);
Begin
    Form1.Close;
End;

Procedure TForm1.StringGrid1KeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    If (Shift = [SsCtrl]) And (Key = Ord('C')) And (StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row] <> '') Then
    Begin
        Clipboard.AsText := StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row];
        Label4.Caption := 'Число ''' + StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row] + ''' скопировано в буфер обмена.';
    End;
End;

End.
