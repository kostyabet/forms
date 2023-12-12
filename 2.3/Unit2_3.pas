unit Unit2_3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Menus;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    Button1: TButton;
    Label3: TLabel;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    procedure N6Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure Edit1ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure Edit1Change(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  Error: Integer = 0;
  DataSaved: Boolean = False;

implementation

{$R *.dfm}

uses Unit2_3_1, Unit2_3_2;

Procedure PutInMassive(Var ArrPalin: Array Of Integer; Palindrome: Integer);
Var
    I: Integer;
Begin
    I := 0;
    While Palindrome > 0 Do
    Begin
        ArrPalin[I] := Palindrome Mod 10;
        Inc(I);
        Palindrome := Palindrome Div 10;
    End;
End;

Function PalinIsPalin(Var ArrPalin: Array Of Integer; PalinLen: Integer; Palindrome: Integer): Boolean;
Var
    IsCorrect: Boolean;
    I: Integer;
Begin
    IsCorrect := True;
    For I := 0 To PalinLen Div 2 Do
        If (ArrPalin[I] <> ArrPalin[PalinLen - I - 1]) Then
            IsCorrect := False;
    If Palindrome < 0 Then
        IsCorrect := False;

    PalinIsPalin := IsCorrect;
End;

Function LengthOfPalin(Palindrome: Integer): Integer;
Var
    PalinLen: Integer;
Begin
    PalinLen := 0;
    While (Palindrome > 0) Do
    Begin
        Inc(PalinLen);
        Palindrome := Palindrome Div 10;
    End;

    LengthOfPalin := PalinLen;
End;

Function PalinCheack(Palindrome: Integer): string;
Var
    PalinLen: Integer;
    Res: Boolean;
    ArrPalin: Array Of Integer;
Begin
    PalinLen := LengthOfPalin(Palindrome);
    SetLength(ArrPalin, PalinLen);
    PutInMassive(ArrPalin, Abs(Palindrome));

    Res := PalinIsPalin(ArrPalin, PalinLen, Palindrome);

    ArrPalin := Nil;

    if res then
        PalinCheack := 'палиндором.'
    else
        PalinCheack := 'не палиндром.';
End;

procedure TForm1.Button1Click(Sender: TObject);
begin
    if StrToInt(Edit1.Text) >= 0 then
        Label3.Caption := 'Ваше число ' + PalinCheack(StrToInt(Edit1.Text))
    else
        Label3.Caption := 'Ваше число не палиндром.'; 
    N3.Enabled := True;
    Label3.Visible := true;
end;

procedure TForm1.Edit1Change(Sender: TObject);
begin
        Try
            StrToInt(Edit1.Text);
            Button1.Enabled := True;
        Except
            Button1.Enabled := False;
        End;
end;

procedure TForm1.Edit1ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin
    Handled := True;
end;

Function CheckDelete(Tempstr: Tcaption; Cursor: Integer): Boolean;
Begin
    Delete(Tempstr, Cursor, 1);
    If ((Length(TempStr) >= 1) And (Tempstr[1] = '0')) Or ((Length(TempStr) >= 2) And (Tempstr[1] = '-') And (Tempstr[2] = '0')) Then
        CheckDelete := False
    Else
        CheckDelete := True;
End;

procedure TForm1.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    TEdit(Sender).ReadOnly := (SsShift In Shift) Or (SsCtrl In Shift);

    If Key = VK_DELETE Then
        Key := 0;

    If (Key = VK_BACK) And (Edit1.SelText <> '') Then
    Begin
        Var
        Temp := Edit1.Text;
        Edit1.ClearSelection;
        If (Length(Edit1.Text) >= 1) And (Edit1.Text[1] = '0') Then
        Begin
            Edit1.Text := Temp;
            Edit1.SelStart := Edit1.SelStart + 1;
        End;
        Key := 0;
    End;

    If (Key = VK_BACK) Then
    Begin
        Var
        Tempstr := Edit1.Text;
        Var
        Cursor := Edit1.SelStart;
        If CheckDelete(Tempstr, Cursor) Then
        Begin
            Delete(Tempstr, Cursor, 1);
            Edit1.Text := Tempstr;
            Edit1.SelStart := Cursor - 1;
        End;
        Key := 0;
    End;

    If Key = VK_DOWN Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);
end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
Var
    MinCount: Integer;
Begin
    MinCount := 0;

    If (Key = '0') And (Length(Edit1.Text) >= 2) And (Edit1.SelStart = 0) Then
        Key := #0;

    If (Key = '0') And (Length(Edit1.Text) >= 2) And (Edit1.Text[1] = '-') And (Edit1.SelStart = 1) Then
        Key := #0;

    If (Key = '-') And (Edit1.SelStart <> 0) Then
        Key := #0;

    If ((Length(Edit1.Text) <> 0) And (Edit1.Text[1] = '-')) Or (Key = '-') Then
        MinCount := 1;

    If (Edit1.Text = '0') Or (Edit1.Text = '-0') Then
        Key := #0;

    If Not((Key In ['0' .. '9']) Or (Key = '-')) Then
        Key := #0;

    If (Edit1.SelText <> '') And (Key <> #0) Then
        Edit1.ClearSelection
    Else
        If (Length(Edit1.Text) >= 9 + MinCount) Then
            Key := #0;
end;

procedure TForm1.FormClick(Sender: TObject);
begin
    ActiveControl := Nil;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
Var
    Key: Integer;
Begin
    Key := Application.Messagebox('Вы уверены, что хотите закрыть набор записей?', 'Выход', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);
    If Key = ID_NO Then
        CanClose := False
    Else
    Begin
        If DataSaved Or (label3.caption = '') Then
        Begin
            If Key = ID_NO Then
                CanClose := False
        End
        Else
            If label3.caption <> '' Then
            Begin
                Key := Application.Messagebox('Вы не сохранили результат. Хотите сделать это?', 'Сохранение',
                    MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);
                If Key = ID_YES Then
                    N3.Click;
            End;
    End;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    Button1.Enabled := false;
    N3.Enabled := False;
end;

procedure TForm1.Label1Click(Sender: TObject);
begin
    ActiveControl := Nil;
end;

procedure TForm1.Label2Click(Sender: TObject);
begin
    ActiveControl := Nil;
end;

procedure TForm1.N1Click(Sender: TObject);
begin
    ActiveControl := Nil;
end;

Function TryRead(Var TestFile: TextFile): Boolean;
Var
    BufferInt: Integer;
Begin
    Read(TestFile, BufferInt);
    If (BufferInt < 1) Or (BufferInt > 999999999) Then
        TryRead := False
    Else
    Begin
        TryRead := True;
        Form1.Edit1.Text := IntToStr(BufferInt);
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

procedure TForm1.N2Click(Sender: TObject);
Var
    IsCorrect: Boolean;
Begin
    Repeat
        If OpenDialog1.Execute() Then
        Begin
            IsCorrect := IsCanRead(OpenDialog1.FileName);
            If Not(IsCorrect) And (Error = 0) Then
                MessageBox(0, 'Данные в выбранном файле не корректны!', 'Ошибка', MB_ICONERROR);
        End
        Else
            IsCorrect := True;
        Error := 0;
    Until IsCorrect;
end;

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
        Write(MyFile, Form1.Label3.caption);
        Close(MyFile);
    End;
End;

procedure TForm1.N3Click(Sender: TObject);
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
end;

procedure TForm1.N5Click(Sender: TObject);
begin
    Form1.Close;
end;

procedure TForm1.N6Click(Sender: TObject);
begin
    ActiveControl := Nil;
    Form2.ShowModal;
end;

procedure TForm1.N7Click(Sender: TObject);
begin
    ActiveControl := Nil;
    Form3.ShowModal;
end;

end.
