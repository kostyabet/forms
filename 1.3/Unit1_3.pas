Unit Unit1_3;

{ TODO -oOwner -cGeneral : Передвижение на стрелочки }
{ TODO -oOwner -cGeneral : Курсор в EPS }
{ TODO -oOwner -cGeneral : Удаление по эллементам }

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
    Vcl.ExtCtrls,
    Vcl.Menus;

Type
    TForm1 = Class(TForm)
        Label1: TLabel;
        Edit1: TEdit;
        Label2: TLabel;
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
        Label3: TLabel;
        Edit2: TEdit;
        Button1: TButton;
        Label4: TLabel;
        Procedure FormCreate(Sender: TObject);
        Procedure FormClick(Sender: TObject);
        Procedure Label1Click(Sender: TObject);
        Procedure Label2Click(Sender: TObject);
        Procedure Edit1ContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
        Procedure Edit1Enter(Sender: TObject);
        Procedure Edit1Exit(Sender: TObject);
        Procedure N5Click(Sender: TObject);
        Procedure Label3Click(Sender: TObject);
        Procedure Edit2Exit(Sender: TObject);
        Procedure Edit2Enter(Sender: TObject);
        Procedure Label4Click(Sender: TObject);
        Procedure N1Click(Sender: TObject);
        Procedure N7Click(Sender: TObject);
        Procedure N6Click(Sender: TObject);
        Procedure FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
        Procedure N2Click(Sender: TObject);
        Procedure N3Click(Sender: TObject);
        Procedure Button1Click(Sender: TObject);
        Procedure Edit1Change(Sender: TObject);
        Procedure Edit2Change(Sender: TObject);
        Procedure Edit2ContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
        Procedure Edit1KeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure Edit2KeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure Edit1KeyPress(Sender: TObject; Var Key: Char);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    Form1: TForm1;
    DataSaved: Boolean = False;
    MinCount: Integer = 0;
    DotCount: Integer = 0;

Implementation

{$R *.dfm}

Uses
    Unit1_3_1,
    Unit1_3_2;

Function CalcResult(EPS: Real; X: Real): String;
Var
    Eteration: Integer;
    Y0, Y: Real;
Begin
    Y0 := 1.0;
    Eteration := 0;
    If (X = 0) Then
    Begin
        Y := 0;
        Int(Eteration);
    End
    Else
    Begin
        Y := ((Y0 * 2) + (X / (Y0 * Y0))) / 3;
        Inc(Eteration);
        If (Abs(Y - Y0) > EPS) Then
        Begin
            Y0 := Y;
            Y := ((Y0 * 2) + (X / (Y0 * Y0))) / 3;
            Inc(Eteration);
            While (Abs(Y - Y0) > EPS) Do
            Begin
                Y0 := Y;
                Y := ((Y0 * 2) + (X / (Y0 * Y0))) / 3;
                Inc(Eteration);
            End;
        End;
    End;

    CalcResult := 'Корень кубический ' + FloatToStr(X) + ' = ' + FormatFloat('0.#####', Y) + #13#10 +
        'Колличество операций по достижению точности: ' + IntToStr(Eteration);
End;

Procedure TForm1.Button1Click(Sender: TObject);
Var
    EPS: Real;
    X: Real;
Begin
    EPS := StrToFloat(Edit1.Text);
    X := StrToFloat(Edit2.Text);
    Label4.Caption := CalcResult(EPS, X);
    N3.Enabled := True;
End;

Procedure TForm1.Edit1Change(Sender: TObject);
Begin
    Try
        StrToFloat(Edit1.Text);
        StrToFloat(Edit2.Text);
        if Edit1.Text <> '0,0' then
            Button1.Enabled := True;
    Except
        Button1.Enabled := False;
    End;
End;

Procedure TForm1.Edit1ContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := True;
End;

Procedure TForm1.Edit1Enter(Sender: TObject);
Begin
    If Edit1.Text = 'EPS' Then
    Begin
        Edit1.Text := '0,0';
        Edit1.Font.Color := Clblack;
    End;
End;

Procedure TForm1.Edit1Exit(Sender: TObject);
Begin
    If (Edit1.Text = '0,0') Then
    Begin
        Edit1.Text := 'EPS';
        Edit1.Font.Color := ClGray;
    End;
End;

Procedure TForm1.Edit1KeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    TEdit(Sender).ReadOnly := (SsShift In Shift) Or (SsCtrl In Shift);
End;

Procedure TForm1.Edit1KeyPress(Sender: TObject; Var Key: Char);
Begin
    If Not(Key In ['0' .. '9']) Then
        Key := #0
    Else
        If Length(Edit1.Text) >= 8 Then
        Begin
            Key := #0;
        End;
End;

Procedure TForm1.Edit2Change(Sender: TObject);
Begin
    Try
        StrToFloat(Edit2.Text);
        StrToFloat(Edit1.Text);
        Button1.Enabled := True;
    Except
        Button1.Enabled := False;
    End;
End;

Procedure TForm1.Edit2ContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := True;
End;

Procedure TForm1.Edit2Enter(Sender: TObject);
Begin
    If Edit2.Text = 'X' Then
    Begin
        Edit2.Clear;
        Edit2.Font.Color := Clblack;
    End;
End;

Procedure TForm1.Edit2Exit(Sender: TObject);
Begin
    If Edit2.Text = '' Then
    Begin
        Edit2.Text := 'X';
        Edit2.Font.Color := ClGray;
    End;
End;

Procedure TForm1.Edit2KeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    TEdit(Sender).ReadOnly := (SsShift In Shift) Or (SsCtrl In Shift);
End;

procedure TForm1.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
    if (Key = '-') and (Length(Edit2.Text) <> 0) then
        Key := #0
    else if (Key = '-') then
        MinCount := 1;
        
    if not ((Key in ['0'..'9']) or (Key = '-')) then
        Key := #0
    else if (Length(Edit2.Text) > 9 + MinCount + DotCount) then
        Key := #0;
end;

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
                    N3.Click;
            End;
    End;
End;

Procedure TForm1.FormCreate(Sender: TObject);
Begin
    Label1.Font.Style := Label1.Font.Style + [FsBold];
    Label1.Caption := 'Программа вычисляет значение кубического корня' + #13#10 + 'с точностью EPS с использованием итерационной' + #13#10 +
        'формулы Ньютона. А также считает количество' + #13#10 + 'итераций, за которое достигается точность EPS.';
    Label2.Caption := 'Введите ваш EPS: ';
    Label3.Caption := 'Введите ваше X:';
    Edit1.Text := 'EPS';
    Edit1.Font.Color := ClGray;
    Edit2.Text := 'X';
    Edit2.Font.Color := ClGray;
    Button1.Caption := 'Рассчитать';
    Label4.Caption := '';
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

Procedure TForm1.Label3Click(Sender: TObject);
Begin
    ActiveControl := Nil;
End;

Procedure TForm1.Label4Click(Sender: TObject);
Begin
    ActiveControl := Nil;
End;

Procedure TForm1.N1Click(Sender: TObject);
Begin
    ActiveControl := Nil;
End;

Function TryRead(Var TestFile: TextFile): Boolean;
Var
    BufferReal1: Real;
    BufferReal2: Real;
    Signal:boolean;
Begin
    Signal := true;
    BufferReal1 := 0.0;
    BufferReal2 := 0.0;
    try
        Read(TestFile, BufferReal1);
        Read(TestFile, BufferReal2);
    except
        Signal := false;    
    end;
    
    If (BufferReal1 < 0) or (BufferReal1 > 0.1) or (Length(FloatToStr(BufferReal1)) >= 8) Then
        Signal := False
    Else
        If (BufferReal2 < -1000000) Or (BufferReal2 > 1000000) Then
            Signal := False
        Else if Signal then
        Begin
            Form1.Edit1.Font.Color := ClBlack;
            Form1.Edit2.Font.Color := ClBlack;
            Form1.Edit1.Text := FloatToStr(BufferReal1);
            Form1.Edit2.Text := FloatToStr(BufferReal2);
        End;
        
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
            If Not IsCorrect Then
                MessageBox(0, 'Данные в выбранном файле не корректны!', 'Ошибка', MB_ICONERROR);
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
        Writeln(MyFile, Form1.Label4.Caption);
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

Procedure TForm1.N6Click(Sender: TObject);
Begin
    ActiveControl := Nil;
    Form2.ShowModal;
End;

Procedure TForm1.N7Click(Sender: TObject);
Begin
    ActiveControl := Nil;
    Form3.ShowModal;
End;

End.
