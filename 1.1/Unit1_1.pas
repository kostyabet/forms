Unit Unit1_1;

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
    procedure Button2Change(Sender: TObject);

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
    Unit1_1_4;

Procedure TForm1.FormClick(Sender: TObject);
Begin
    ActiveControl := Nil;
End;

Procedure TForm1.FormCreate(Sender: TObject);
Begin
    Label1.Caption := 'Программа рассчитывает иделаьный возраст' + #13#10 + 'для вашей второй половинки по заданным параметрам.';
    Button1.Text := 'M/Ж';
    Button2.Text := '18..99';
    Button1.Font.Color := ClGray;
    Button2.Font.Color := ClGray;
    Button.Caption := 'Рассчитать';
    Button.Enabled := false;
    Label4.Caption := '';
End;

Procedure TForm1.FormKeyPress(Sender: TObject; Var Key: Char);
Begin
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

Procedure TForm1.N4Click(Sender: TObject);
Begin
    If OpenDialog1.Execute() Then
    Begin
        //имя выбранного файла в OpenDialog1.FileName
        MessageBox(Handle, PChar(OpenDialog1.FileName), 'open', MB_OK);
    End
    Else
    Begin
        MessageBox(Handle, '[Отмена]', 'open', MB_OK);
    End;
End;

Procedure TForm1.N7Click(Sender: TObject);
Begin
    Form5.ShowModal;
End;

Function CalculatingTheResult(Gender: String; Age: Integer): String;
Begin
    If (Gender = 'М') Then
        CalculatingTheResult := 'Вы мужчина и вам ' + IntToStr(Age) + ', а вашей второй половинке ' + IntToStr(Trunc((Age / 2) + 7)) + '.'
    Else
        CalculatingTheResult := 'Вы девушка и вам ' + IntToStr(Age) + ', а вашей второй половинке ' + IntToStr((Age * 2) - 14) + '.';
End;

Procedure TForm1.Button1Enter(Sender: TObject);
Begin
    If Button1.Text = 'M/Ж' Then
    Begin
        Button1.Clear;
        Button1.Font.Color := Clblack;
    End;
End;

Procedure TForm1.Button1Exit(Sender: TObject);
Begin
    If Button1.Text = '' Then
    Begin
        Button1.Text := 'M/Ж';
        Button1.Font.Color := ClGray;
    End;
End;

Procedure TForm1.Button1KeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    If (Key = VK_BACK) And (Length(Button1.Text) = 1) Then
        Button1.Clear;
End;

Procedure TForm1.Button1KeyPress(Sender: TObject; Var Key: Char);
Begin
    If (Key <> 'М') And (Key <> 'Ж') Then
        Key := #0
    Else
        If Length(Button1.Text) >= 1 Then
            Key := #0;
End;

procedure TForm1.Button2Change(Sender: TObject);
begin
    if (Length(Button2.Text) = 2) and (Length(Button1.Text) = 1) then
        button.Enabled := true;
end;

Procedure TForm1.Button2Enter(Sender: TObject);
Begin
    If Button2.Text = '18..99' Then
    Begin
        Button2.Clear;
        Button2.Font.Color := Clblack;
    End;
End;

Procedure TForm1.Button2Exit(Sender: TObject);
Begin
    If Button2.Text = '' Then
    Begin
        Button2.Text := '18..99';
        Button2.Font.Color := ClGray;
    End;
End;

Procedure TForm1.Button2KeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Var
    CursorPos: Integer;
Begin
    If (Key = VK_BACK) And (Length(Button2.Text) > 0) Then
    Begin
        CursorPos := Button2.SelStart;
        Button2.Text := Copy(Button2.Text, 1, Length(Button2.Text) - 1); //Удаляем последний символ
        Button2.SelStart := CursorPos - 1;
        Key := 0; //Помечаем событие как обработанное
    End;
End;

Procedure TForm1.Button2KeyPress(Sender: TObject; Var Key: Char);
Var
    Text: String;
Begin
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
        begin
            Key := #0;
        end;
End;

Procedure TForm1.ButtonClick(Sender: TObject);
Var
    Gender: String;
    Age: Integer;
Begin
    Gender := Button1.Text;
    Age := StrToInt(Button2.Text);
    Label4.Caption := CalculatingTheResult(Gender, Age);
End;

End.
