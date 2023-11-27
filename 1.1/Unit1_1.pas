Unit Unit1_1;

Interface

Uses
    Winapi.Windows,
    Winapi.Messages,
    System.SysUtils,
    System.Variants,
    System.Classes,
    System.UITypes,
    Vcl.Graphics,
    Vcl.Controls,
    Vcl.Forms,
    Vcl.Dialogs,
    Vcl.ToolWin,
    Vcl.ComCtrls,
    Vcl.Menus,
    Vcl.StdCtrls;
    

Type
    TForm1 = Class(TForm)
        MainMenu1: TMainMenu;
        N1: TMenuItem;
        N2: TMenuItem;
        N3: TMenuItem;
        N4: TMenuItem;
        N5: TMenuItem;
        N6: TMenuItem;
        N7: TMenuItem;
        SaveDialog1: TSaveDialog;
        OpenDialog1: TOpenDialog;
        Label1: TLabel;
        Button: TButton;
        Label2: TLabel;
        Label3: TLabel;
        Button1: TEdit;
        Button2: TEdit;
        Label4: TLabel;
        PopupMenu1: TPopupMenu;
        Procedure N4Click(Sender: TObject);
        Procedure N2Click(Sender: TObject);
        Procedure N3Click(Sender: TObject);
        Procedure ButtonClick(Sender: TObject);
        Procedure FormCreate(Sender: TObject);
        Procedure FormKeyPress(Sender: TObject; Var Key: Char);
        Procedure FormClick(Sender: TObject);
        Procedure Button1Enter(Sender: TObject);
        Procedure Button2Enter(Sender: TObject);
        Procedure Button1Exit(Sender: TObject);
        Procedure Button2Exit(Sender: TObject);
        Procedure Button1KeyPress(Sender: TObject; Var Key: Char);
        Procedure Button1KeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure Button2KeyPress(Sender: TObject; Var Key: Char);
        Procedure Button2KeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure N7Click(Sender: TObject);
        Procedure Button2Change(Sender: TObject);
        Procedure N5Click(Sender: TObject);
        Procedure Button1Change(Sender: TObject);
        Procedure Button1ContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
        Procedure Button2ContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
        Procedure FormCloseQuery(Sender: TObject; Var CanClose: Boolean);

    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    Form1: TForm1;
    

Implementation

{$R *.dfm}

Uses
    Unit1_1_1,
    Unit1_1_2,
    Unit1_1_4,
    Unit1_1_3;

Procedure TForm1.FormClick(Sender: TObject);
Begin
    ActiveControl := Nil;
End;

Procedure TForm1.FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
Begin
    If MessageDlg('Вы уверены, что хотите закрыть набор записей?', MtConfirmation, [MbYes, MbNo], 0) = MrNo Then
        CanClose := False;
End;

Procedure TForm1.FormCreate(Sender: TObject);
Begin
    Label1.Font.Style := Label1.Font.Style + [FsBold];
    Label1.Caption := 'Программа рассчитывает иделаьный возраст для' + #13#10 + 'вашей второй половинки по заданным параметрам.';
    Button1.Text := 'M или Ж';
    Button2.Text := 'от 18 до 99';
    Button1.Font.Color := ClGray;
    Button2.Font.Color := ClGray;
    Button.Caption := 'Рассчитать';
    Button.Enabled := False;
    Label4.Caption := '';
    N5.Enabled := False;
End;

Procedure TForm1.FormKeyPress(Sender: TObject; Var Key: Char);
begin
    If Key = #13 Then
        Button.Click;
End;

Procedure TForm1.N2Click(Sender: TObject);
Begin
    Form2.ShowModal();
End;

Procedure TForm1.N3Click(Sender: TObject);
Begin
    Form3.ShowModal();
End;

Function TryRead(Var TestFile: TextFile): Boolean;
Var
    BufferInt: Integer;
    BufferChar: Char;
Begin
    Read(TestFile, BufferChar);
    Read(TestFile, BufferInt);
    If (BufferChar <> 'М') And (BufferChar <> 'м') And (BufferChar <> 'Ж') And (BufferChar <> 'ж') Then
        TryRead := False
    Else
        If (BufferInt < 18) Or (BufferInt > 99) Then
            TryRead := False
        Else
        Begin
            TryRead := True;
            Form1.Button1.Font.Color := ClBlack;
            Form1.Button2.Font.Color := ClBlack;
            Form1.Button1.Text := BufferChar;
            Form1.Button2.Text := IntToStr(BufferInt);
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
    End;
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
        AssignFile(MyFile, FileName, CP_UTF8);
        ReWrite(MyFile);
        Writeln(MyFile, Form1.Label4.Caption);
        Close(MyFile);
    End;
End;

Procedure TForm1.N5Click(Sender: TObject);
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

Procedure TForm1.N4Click(Sender: TObject);
Var
    IsCorrect: Boolean;
Begin
    Repeat
        If OpenDialog1.Execute() Then
            IsCorrect := IsCanRead(OpenDialog1.FileName)
        Else
            IsCorrect := True;
    Until IsCorrect;
End;

Procedure TForm1.N7Click(Sender: TObject);
Begin
    Form1.close;
End;

Function CalculatingTheResult(Gender: String; Age: Integer): String;
Begin
    If (Gender = 'М') Or (Gender = 'm') Then
        CalculatingTheResult := 'Вы мужчина и вам ' + IntToStr(Age) + ', а вашей второй половинке ' + IntToStr(Trunc((Age / 2) + 7)) + '.'
    Else
        CalculatingTheResult := 'Вы девушка и вам ' + IntToStr(Age) + ', а вашей второй половинке ' + IntToStr((Age * 2) - 14) + '.';
End;

Procedure TForm1.Button1Change(Sender: TObject);
Begin
    If (Length(Button2.Text) = 2) And (Length(Button1.Text) = 1) Then
        Button.Enabled := True
    Else
        Button.Enabled := False;
End;

Procedure TForm1.Button1ContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := True;
End;

Procedure TForm1.Button1Enter(Sender: TObject);
Begin
    If Button1.Text = 'M или Ж' Then
    Begin
        Button1.Clear;
        Button1.Font.Color := Clblack;
    End;
End;

Procedure TForm1.Button1Exit(Sender: TObject);
Begin
    If Button1.Text = '' Then
    Begin
        Button1.Text := 'M или Ж';
        Button1.Font.Color := ClGray;
    End;
End;

Procedure TForm1.Button1KeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    TEdit(Sender).ReadOnly := (SsShift In Shift) Or (SsCtrl In Shift);
    
    If (Key = VK_BACK) And (Length(Button1.Text) = 1) Then
        Button1.Clear;
End;

Procedure TForm1.Button1KeyPress(Sender: TObject; Var Key: Char);
Begin
    If (Key <> 'М') And (Key <> 'Ж') And (Key <> 'м') And (Key <> 'ж') Then
        Key := #0
    Else
        If Length(Button1.Text) >= 1 Then
        Begin
            Key := #0;
        End;
End;

Procedure TForm1.Button2Change(Sender: TObject);
Begin
    If (Length(Button2.Text) = 2) And (Length(Button1.Text) = 1) Then
        Button.Enabled := True
    Else
        Button.Enabled := False;
End;

Procedure TForm1.Button2ContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := True;
End;

Procedure TForm1.Button2Enter(Sender: TObject);
Begin
    If Button2.Text = 'от 18 до 99' Then
    Begin
        Button2.Clear;
        Button2.Font.Color := Clblack;
    End;
End;

Procedure TForm1.Button2Exit(Sender: TObject);
Begin
    If Button2.Text = '' Then
    Begin
        Button2.Text := 'от 18 до 99';
        Button2.Font.Color := ClGray;
    End;
End;

Procedure TForm1.Button2KeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Var
    CursorPos: Integer;
Begin
    TEdit(Sender).ReadOnly := (SsShift In Shift) Or (SsCtrl In Shift);
    
    If (Key = VK_BACK) And (Length(Button2.Text) > 0) Then
    Begin
        CursorPos := Button2.SelStart;
        Button2.Text := Copy(Button2.Text, 1, Length(Button2.Text) - 1);
        Button2.SelStart := CursorPos - 1;
        Key := 0;
    End;
End;

Procedure TForm1.Button2KeyPress(Sender: TObject; Var Key: Char);
Var
    Text: String;
begin
    Text := Button2.Text;
    If Length(Button2.Text) = 0 Then
        If Key = '0' Then
            Key := #0;

    If Length(Button2.Text) = 1 Then
        If (Text = '1') And (Key In ['0' .. '7']) Then
            Key := #0;

    If Not(Key In ['0' .. '9']) Then
        Key := #0
    Else
        If Length(Button2.Text) > 1 Then
        Begin
            Key := #0;
        End;
End;

Procedure TForm1.ButtonClick(Sender: TObject);
Var
    Gender: String;
    Age: Integer;
Begin
    Gender := Button1.Text;
    Age := StrToInt(Button2.Text);
    Label4.Caption := CalculatingTheResult(Gender, Age);
    N5.Enabled := True;
End;

End.
