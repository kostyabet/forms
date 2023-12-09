Unit Unit1_1;

Interface

Uses
    Clipbrd,
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
        Button1: TEdit;
        Button2: TEdit;
        Button: TButton;
        Label1: TLabel;
        Label4: TLabel;
        OpenDialog1: TOpenDialog;
        SaveDialog1: TSaveDialog;
        Label2: TLabel;
        Label3: TLabel;

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
        Procedure Label1Click(Sender: TObject);
        Procedure Button2Click(Sender: TObject);

    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    Form1: TForm1;
    DataSaved: Boolean = False;
    Error: Integer = 0;

Implementation

{$R *.dfm}

Uses
    Unit1_1_1,
    Unit1_1_2;

Procedure TForm1.FormClick(Sender: TObject);
Begin
    ActiveControl := Nil;
End;

Procedure TForm1.FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
Var
    Key: Integer;
Begin
    Key := Application.Messagebox('Вы уверены, что хотите закрыть приложение?', 'Выход', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);
    If Key = ID_NO Then
        CanClose := False
    Else
    Begin
        If DataSaved Or (Label4.Caption = '') Then
        Begin
            If Key = ID_NO Then
                CanClose := False
        End
        Else
            If Label4.Caption <> '' Then
            Begin
                Key := Application.Messagebox('Вы не сохранили результат. Хотите сделать это?', 'Сохранение',
                    MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);
                If Key = ID_YES Then
                    N5.Click;
            End;
    End;
End;

Procedure TForm1.FormCreate(Sender: TObject);
Begin
    Label1.Font.Style := Label1.Font.Style + [FsBold];
    Label1.Caption := 'Программа рассчитывает иделаьный возраст для' + #13#10 + 'вашей второй половинки по заданным параметрам.';
    Label2.Caption := 'Ваш пол';
    Label3.Caption := 'Ваш возраст';
    Button1.Text := 'м или ж';
    Button2.Text := 'от 18 до 59';
    Button1.Font.Color := ClGray;
    Button2.Font.Color := ClGray;
    Button.Caption := 'Рассчитать';
    Button.Enabled := False;
    Label4.Caption := '';
    N5.Enabled := False;
End;

Procedure TForm1.FormKeyPress(Sender: TObject; Var Key: Char);
Begin
    If Key = #13 Then
        Button.Click;
End;

Procedure TForm1.Label1Click(Sender: TObject);
Begin
    ActiveControl := Nil;
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
    If (BufferChar <> 'м') And (BufferChar <> 'ж') Then
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
        Error := 1;
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
        DataSaved := True;
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
        Begin
            IsCorrect := IsCanRead(OpenDialog1.FileName);
            If Not(IsCorrect And (Error = 0)) Then
                MessageBox(0, 'Данные в выбранном файле не корректны!', 'Ошибка', MB_ICONERROR);
        End
        Else
            IsCorrect := True;
        Error := 0;
    Until IsCorrect;
End;

Procedure TForm1.N7Click(Sender: TObject);
Begin
    Form1.Close;
End;

Function CalculatingTheResult(Gender: String; Age: Integer): String;
Begin
    If (Gender = 'м') Then
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
    If Button1.Text = 'м или ж' Then
    Begin
        Button1.Clear;
        Button1.Font.Color := Clblack;
    End;
End;

Procedure TForm1.Button1Exit(Sender: TObject);
Begin
    If Button1.Text = '' Then
    Begin
        Button1.Text := 'м или ж';
        Button1.Font.Color := ClGray;
    End;
End;

Procedure TForm1.Button1KeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    TEdit(Sender).ReadOnly := (SsShift In Shift) Or (SsCtrl In Shift);

    If (Key = VK_BACK) And (Length(Button1.Text) = 1) Then
        Button1.Clear;
        
    If Key = VK_DOWN Then
    Begin
        SelectNext(ActiveControl, True, True);
        Key := 0;
    End;

    If Key = VK_UP Then
    Begin
        SelectNext(ActiveControl, False, True);
        Key := 0;
    End;
End;

Procedure TForm1.Button1KeyPress(Sender: TObject; Var Key: Char);
Begin

    If (Key <> 'м') And (Key <> 'ж') Then
        Key := #0
    Else
        If (Button1.SelText = Button1.Text) And (Button1.Text <> '') Then
        Begin
            Button1.Clear;
        End
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

Procedure TForm1.Button2Click(Sender: TObject);
Begin
    Button2.SelStart := Length(Button2.Text);
End;

Procedure TForm1.Button2ContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := True;
End;

Procedure TForm1.Button2Enter(Sender: TObject);
Begin
    If Button2.Text = 'от 18 до 59' Then
    Begin
        Button2.Clear;
        Button2.Font.Color := Clblack;
    End;
End;

Procedure TForm1.Button2Exit(Sender: TObject);
Begin
    If Button2.Text = '' Then
    Begin
        Button2.Text := 'от 18 до 59';
        Button2.Font.Color := ClGray;
    End;
End;

Function CheckDelete(Tempstr: Tcaption; Cursor: Integer): Boolean;
Begin
    Delete(Tempstr, Cursor, 1);
    If (Tempstr = '0') Or (Tempstr = '6') Or (Tempstr = '7') Or (Tempstr = '8') Or (Tempstr = '9') Then
        CheckDelete := False
    Else
        CheckDelete := True;
End;

Procedure TForm1.Button2KeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    TEdit(Sender).ReadOnly := (SsShift In Shift) Or (SsCtrl In Shift);

    If (Key = VK_DELETE) Then
        Key := 0;

    If (Key = VK_BACK) And (Button2.SelText <> '') Then
    Begin
        Button2.ClearSelection;
        Key := 0;
    End;

    If (Key = VK_BACK) Then
    Begin
        Var
        Tempstr := Button2.Text;
        Var
        Cursor := Button2.SelStart;
        If CheckDelete(Tempstr, Cursor) Then
        Begin
            Delete(Tempstr, Cursor, 1);
            Button2.Text := Tempstr;
            Button2.SelStart := Cursor - 1;
        End;
        Key := 0;
    End;

    If Key = VK_DOWN Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);

End;

Procedure TForm1.Button2KeyPress(Sender: TObject; Var Key: Char);
Begin
    If (Key = '0') And (Button2.SelStart = 0) Then
        Key := #0;
    if (Key = '1') and not ((button2.Text[2] = '8') or (button2.Text[2] = '9')) And (Button2.SelStart = 0) then
        Key := #0;
        
    If (Button2.SelStart = 0) And ((Button2.Text = '0') Or (Button2.Text = '1') Or (Button2.Text = '2') Or (Button2.Text = '3') Or (Button2.Text = '4') Or
        (Button2.Text = '5') Or (Button2.Text = '6') Or (Button2.Text = '7')) And (Key = '1') Then
        Key := #0;

    If (Length(Button2.Text) = 0) And Not(Key In ['1' .. '5']) And (Button2.SelStart = Length(Button2.Text)) Then
        Key := #0;

    If (Length(Button2.Text) = 1) And (Button2.Text = '1') And Not(Key In ['8' .. '9']) And (Button2.SelStart = Length(Button2.Text)) Then
        Key := #0;

    If (Length(Button2.Text) = 1) And (Button2.Text <> '1') And Not(Key In ['0' .. '9']) And (Button2.SelStart = Length(Button2.Text)) Then
        Key := #0;

    If (Button2.Text <> '') And (Button2.SelText <> '') And (Key <> #0) Then
        Button2.ClearSelection
    Else
        If Length(Button2.Text) >= 2 Then
            Key := #0;
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
