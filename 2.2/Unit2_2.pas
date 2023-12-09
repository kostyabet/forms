Unit Unit2_2;

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
    Vcl.Menus;

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
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Label3: TLabel;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
        Procedure FormCreate(Sender: TObject);
        Procedure Edit1ContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
        Procedure Edit1Change(Sender: TObject);
        Procedure Label2Click(Sender: TObject);
        Procedure Label1Click(Sender: TObject);
        Procedure N1Click(Sender: TObject);
        Procedure N6Click(Sender: TObject);
        Procedure N7Click(Sender: TObject);
        Procedure FormClick(Sender: TObject);
        Procedure Edit1KeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure Edit1KeyPress(Sender: TObject; Var Key: Char);
        Procedure Button1Click(Sender: TObject);
        Procedure Edit1Click(Sender: TObject);
        Procedure N2Click(Sender: TObject);
        Procedure N3Click(Sender: TObject);
        Procedure FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
        Procedure N5Click(Sender: TObject);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    Form1: TForm1;
    DataSaved: Boolean = False;
    MAX_N : Integer = 1000000;

Implementation

{$R *.dfm}

Uses
    Unit2_2_1, Unit2_2_2;

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

Function SearchNum(K: Integer):string;
Var
    Sum, NutNumb: Integer;
    res: string;
Begin
    NutNumb := k;
    While (NutNumb <= MAX_N) Do
    Begin
        Sum := SumOfDigits(NutNumb);
        If (CheckSum(Sum, K, NutNumb)) Then
            res := res + IntToStr(NutNumb) + ' ';
        NutNumb := NutNumb + k;
    End;

    SearchNum := res;
End;

Procedure TForm1.Button1Click(Sender: TObject);
Begin
    Label3.Caption := '' + SearchNum(StrToInt(Edit1.Text));
    N3.Enabled := True;
End;

Procedure TForm1.Edit1Change(Sender: TObject);
Begin
    Try
        StrToInt(Edit1.Text);
        Button1.Enabled := True;
    Except
        Button1.Enabled := False;
    End;
End;

Procedure TForm1.Edit1Click(Sender: TObject);
Begin
    Edit1.SelStart := Length(Edit1.Text);
End;

Procedure TForm1.Edit1ContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := True;
End;

Procedure TForm1.Edit1KeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    TEdit(Sender).ReadOnly := (SsShift In Shift) Or (SsCtrl In Shift);

    If Key = VK_BACK Then
    Begin
        Edit1.Text := Copy(Edit1.Text, 1, Length(Edit1.Text) - 1);
        Edit1.SelStart := Length(Edit1.Text);
        Key := 0;
    End
    Else
        If Key = VK_RIGHT Then
        Begin
            If ActiveControl Is TEdit Then
                SelectNext(ActiveControl, True, True)
            Else
                If ActiveControl Is TButton Then
                    SelectNext(ActiveControl, True, True);
            Key := 0;
        End
        Else
            If Key = VK_LEFT Then
            Begin
                If ActiveControl Is TEdit Then
                    SelectNext(ActiveControl, False, True)
                Else
                    If ActiveControl Is TButton Then
                        SelectNext(ActiveControl, False, True);
                Key := 0;
            End
            Else
                If Key = VK_DOWN Then
                Begin
                    SelectNext(ActiveControl, True, True);
                    Key := 0;
                End
                Else
                    If Key = VK_UP Then
                    Begin
                        SelectNext(ActiveControl, False, True);
                        Key := 0;
                    End;
End;

Procedure TForm1.Edit1KeyPress(Sender: TObject; Var Key: Char);
Begin
    If Not(Key In ['0' .. '9']) Then
        Key := #0
    Else
        If (Length(Edit1.Text) >= 4) Then
            Key := #0;
End;

Procedure TForm1.FormClick(Sender: TObject);
Begin
    ActiveControl := Nil;
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
        If DataSaved Or (Label3.Caption = '') Then
        Begin
            If Key = ID_NO Then
                CanClose := False
        End
        Else
            If Label3.Caption <> '' Then
            Begin
                Key := Application.Messagebox('Вы не сохранили результат. Хотите сделать это?', 'Сохранение',
                    MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);
                If Key = ID_YES Then
                    N3.Click;
            End;
    End;
End;

Procedure TForm1.FormCreate(Sender: TObject);
Begin
    Label1.Font.Style := Label1.Font.Style + [FsBold];
    Label1.Caption := 'Программа находит все натуральные числа, которые' + #13#10 + 'в k раз больше суммы своих цифр.';
    Label2.Caption := 'Введите коэфициент K: ';
    Button1.Caption := 'Рассчитать';
    Button1.Enabled := False;
    Label3.Caption := '';
    N3.Enabled := False;
End;

Procedure TForm1.Label1Click(Sender: TObject);
Begin
    ActiveControl := Nil;
End;

Procedure TForm1.Label2Click(Sender: TObject);
Begin
    ActiveControl := Nil;
End;

Procedure TForm1.N1Click(Sender: TObject);
Begin
    ActiveControl := Nil;
End;

Procedure TForm1.N2Click(Sender: TObject);
Begin
    If OpenDialog1.Execute Then
    Begin

    End;
End;

Procedure TForm1.N3Click(Sender: TObject);
Begin
    If SaveDialog1.Execute Then
    Begin
        DataSaved := True;
    End;
End;

Procedure TForm1.N5Click(Sender: TObject);
Begin
    Form1.Close;
End;

Procedure TForm1.N6Click(Sender: TObject);
Begin
    ActiveControl := Nil;
    Form2.ShowModal;
    Form2.Free;
End;

Procedure TForm1.N7Click(Sender: TObject);
Begin
    ActiveControl := Nil;
    Form3.ShowModal;
    Form3.Free;
End;

End.
