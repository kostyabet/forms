unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Menus;

type
  TMainForm = class(TForm)
    ConditionLabel: TLabel;
    NumberInfoLabel: TLabel;
    NumberEdit: TEdit;
    MainMenu: TMainMenu;
    FileMMButton: TMenuItem;
    OpenMMButton: TMenuItem;
    SaveMMButton: TMenuItem;
    LineMMButton: TMenuItem;
    CloseMMButton: TMenuItem;
    InstractionMMButton: TMenuItem;
    AboutEditorMMButton: TMenuItem;
    ResultButton: TButton;
    ResultLabel: TLabel;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    procedure InstractionMMButtonClick(Sender: TObject);
    procedure AboutEditorMMButtonClick(Sender: TObject);
    procedure NumberEditContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure NumberEditChange(Sender: TObject);
    procedure NumberEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure NumberEditKeyPress(Sender: TObject; var Key: Char);
    procedure ResultButtonClick(Sender: TObject);
    procedure CloseMMButtonClick(Sender: TObject);
    procedure OpenMMButtonClick(Sender: TObject);
    procedure SaveMMButtonClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  Error: Integer = 0;
  DataSaved: Boolean = False;

implementation

{$R *.dfm}

uses InstractionUnit, AboutEditorUnit;

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

procedure TMainForm.ResultButtonClick(Sender: TObject);
begin
    if StrToInt(NumberEdit.Text) >= 0 then
        ResultLabel.Caption := 'Ваше число ' + PalinCheack(StrToInt(NumberEdit.Text))
    else
        ResultLabel.Caption := 'Ваше число не палиндром.'; 
    SaveMMButton.Enabled := True;
    ResultLabel.Visible := true;
end;

procedure TMainForm.NumberEditChange(Sender: TObject);
begin
        Try
            StrToInt(NumberEdit.Text);
            ResultButton.Enabled := True;
        Except
            ResultButton.Enabled := False;
        End;
end;

procedure TMainForm.NumberEditContextPopup(Sender: TObject; MousePos: TPoint;
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

procedure TMainForm.NumberEditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    TEdit(Sender).ReadOnly := (SsShift In Shift) Or (SsCtrl In Shift);

    If Key = VK_DELETE Then
        Key := 0;

    If (Key = VK_BACK) And (NumberEdit.SelText <> '') Then
    Begin
        Var
        Temp := NumberEdit.Text;
        NumberEdit.ClearSelection;
        If (Length(NumberEdit.Text) >= 1) And (NumberEdit.Text[1] = '0') Then
        Begin
            NumberEdit.Text := Temp;
            NumberEdit.SelStart := NumberEdit.SelStart + 1;
        End;
        Key := 0;
    End;

    If (Key = VK_BACK) Then
    Begin
        Var
        Tempstr := NumberEdit.Text;
        Var
        Cursor := NumberEdit.SelStart;
        If CheckDelete(Tempstr, Cursor) Then
        Begin
            Delete(Tempstr, Cursor, 1);
            NumberEdit.Text := Tempstr;
            NumberEdit.SelStart := Cursor - 1;
        End;
        Key := 0;
    End;

    If Key = VK_DOWN Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);
end;

procedure TMainForm.NumberEditKeyPress(Sender: TObject; var Key: Char);
Var
    MinCount: Integer;
Begin
    MinCount := 0;

    If (Key = '0') And (Length(NumberEdit.Text) >= 2) And (NumberEdit.SelStart = 0) Then
        Key := #0;

    If (Key = '0') And (Length(NumberEdit.Text) >= 2) And (NumberEdit.Text[1] = '-') And (NumberEdit.SelStart = 1) Then
        Key := #0;

    If (Key = '-') And (NumberEdit.SelStart <> 0) Then
        Key := #0;

    If ((Length(NumberEdit.Text) <> 0) And (NumberEdit.Text[1] = '-')) Or (Key = '-') Then
        MinCount := 1;

    If (NumberEdit.Text = '0') Or (NumberEdit.Text = '-0') Then
        Key := #0;

    If Not((Key In ['0' .. '9']) Or (Key = '-')) Then
        Key := #0;

    If (NumberEdit.SelText <> '') And (Key <> #0) Then
        NumberEdit.ClearSelection
    Else
        If (Length(NumberEdit.Text) >= 9 + MinCount) Then
            Key := #0;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
Var
    Key: Integer;
Begin
    Key := Application.Messagebox('Вы уверены, что хотите закрыть набор записей?', 'Выход', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);
    If Key = ID_NO Then
        CanClose := False
    Else
    Begin
        If DataSaved Or (ResultLabel.caption = '') Then
        Begin
            If Key = ID_NO Then
                CanClose := False
        End
        Else
            If ResultLabel.caption <> '' Then
            Begin
                Key := Application.Messagebox('Вы не сохранили результат. Хотите сделать это?', 'Сохранение',
                    MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);
                If Key = ID_YES Then
                    SaveMMButton.Click;
            End;
    End;
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
        MainForm.NumberEdit.Text := IntToStr(BufferInt);
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

procedure TMainForm.OpenMMButtonClick(Sender: TObject);
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
        Write(MyFile, MainForm.ResultLabel.caption);
        Close(MyFile);
    End;
End;

procedure TMainForm.SaveMMButtonClick(Sender: TObject);
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
end;

procedure TMainForm.CloseMMButtonClick(Sender: TObject);
begin
    MainForm.Close;
end;

procedure TMainForm.InstractionMMButtonClick(Sender: TObject);
begin
    Instraction.ShowModal;
end;

procedure TMainForm.AboutEditorMMButtonClick(Sender: TObject);
begin
    AboutEditor.ShowModal;
end;

end.
