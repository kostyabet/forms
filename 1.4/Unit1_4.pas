Unit Unit1_4;

{ TODO -oOwner -cGeneral : Выделение текста при стирании }
{ TODO -oOwner -cGeneral : Более точный контроль активности кнопки, если изменить
  значение и н езакрыть ячейку то кнопка активна }
{ TODO -oOwner -cGeneral : Открытие через файл }

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
    Vcl.Menus,
    Vcl.Grids;

Type
    TForm1 = Class(TForm)
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
        StringGrid1: TStringGrid;
        Button2: TButton;
        Label4: TLabel;
        OpenDialog1: TOpenDialog;
        SaveDialog1: TSaveDialog;
        Procedure FormCreate(Sender: TObject);
        Procedure Edit1ContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
        Procedure Edit1Click(Sender: TObject);
        Procedure Edit1KeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure Label1Click(Sender: TObject);
        Procedure Label2Click(Sender: TObject);
        Procedure FormClick(Sender: TObject);
        Procedure N1Click(Sender: TObject);
        Procedure N6Click(Sender: TObject);
        Procedure N7Click(Sender: TObject);
        Procedure Edit1KeyPress(Sender: TObject; Var Key: Char);
        Procedure Edit1Change(Sender: TObject);
        Procedure Button1Click(Sender: TObject);
        Procedure Label3Click(Sender: TObject);
        Procedure Button2Click(Sender: TObject);
        Procedure Edit1Exit(Sender: TObject);
        Procedure Edit1Enter(Sender: TObject);
        Procedure N3Click(Sender: TObject);
        Procedure N2Click(Sender: TObject);
        Procedure FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
        Procedure N5Click(Sender: TObject);
        Procedure StringGrid1KeyPress(Sender: TObject; Var Key: Char);
        Procedure StringGrid1KeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer; Var CanSelect: Boolean);
        Procedure StringGrid1SetEditText(Sender: TObject; ACol, ARow: Integer; Const Value: String);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    Form1: TForm1;
    MinCount: Integer = 0;
    DataSaved: Boolean = False;

Implementation

{$R *.dfm}

Uses
    Unit1_4_1,
    Unit1_4_2;

Procedure DefultStringGrid();
Var
    Col: Integer;
Begin
    Form1.StringGrid1.Cells[0, 0] := '№';
    Form1.StringGrid1.Cells[0, 1] := 'Элемент';

    For Col := 1 To StrToInt(Form1.Edit1.Text) Do
        Form1.StringGrid1.Cells[Col, 0] := IntToStr(Col);

    For Col := 1 To StrToInt(Form1.Edit1.Text) Do
        Form1.StringGrid1.Cells[Col, 1] := '';

    Form1.StringGrid1.FixedCols := 1;
    Form1.StringGrid1.FixedRows := 1;
End;

Procedure TForm1.Button1Click(Sender: TObject);
Begin
    Button2.Enabled := False;
    StringGrid1.ColCount := StrToInt(Edit1.Text) + 1;
    StringGrid1.RowCount := 2;
    StringGrid1.Options := StringGrid1.Options + [GoEditing];
    DefultStringGrid();
    StringGrid1.Options := StringGrid1.Options - [GoDrawFocusSelected];
    StringGrid1.Visible := True;
End;

Function CulcRes(): String;
Var
    Sum, I: Integer;
Begin
    Sum := 0;
    For I := 1 To StrToInt(Form1.Edit1.Text) Do
        If I Mod 2 <> 0 Then
            Sum := Sum + StrToInt(Form1.StringGrid1.Cells[I, 1]);

    CulcRes := IntToStr(Sum);
End;

Procedure TForm1.Button2Click(Sender: TObject);
Begin
    N3.Enabled := True;
    Label4.Caption := 'Сумма всех нечётных эллементов' + #13#10 + 'массива = ' + CulcRes;
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

Procedure TForm1.Edit1Enter(Sender: TObject);
Begin
    If Edit1.Text = 'N' Then
    Begin
        Edit1.Text := '';
        Edit1.Font.Color := ClBlack;
    End;
End;

Procedure TForm1.Edit1Exit(Sender: TObject);
Begin
    If Edit1.Text = '' Then
    Begin
        Edit1.Text := 'N';
        Edit1.Font.Color := ClSilver;
    End;
End;

Procedure TForm1.Edit1KeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    TEdit(Sender).ReadOnly := (SsShift In Shift) Or (SsCtrl In Shift);

    If (Key = VK_BACK) Then
    Begin
        StringGrid1.Visible := False;
        Button2.Enabled := False;
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
    StringGrid1.Visible := False;
    If (Length(Edit1.Text) <> 0) And (Key = '-') Then
        Key := #0;

    If Not(Key In ['0' .. '9']) Then
        Key := #0
    Else
        If (Length(Edit1.Text) >= 2) Then
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
    Label1.Caption := 'Программа вычисляет сумму эллементов массива' + #13#10 + 'по принципу: А1 + А3 + А5 + ... + А2N-1.';
    Label2.Caption := 'Введите размер массива: ';
    Button1.Caption := 'Создать массив';
    Button1.Enabled := False;
    Edit1.Text := 'N';
    Edit1.Font.Color := ClSilver;
    StringGrid1.Visible := False;
    Button2.Caption := 'Рассчитать';
    Button2.Enabled := False;
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

Procedure TForm1.N1Click(Sender: TObject);
Begin
    ActiveControl := Nil;
End;

Function TryRead(Var TestFile: TextFile): Boolean;
Var
    Signal: Boolean;
Begin
    Signal := True;

    /// /////////////////////////////////////////////////////////////////////////////

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

Procedure ReadFromFile(IsCorrect: Boolean; FileWay: String);
Var
    MyFile: TextFile;
Begin
    If Not IsCorrect Then
        MessageBox(0, 'Данные в выбранном файле не корректны!', 'Ошибка', MB_ICONERROR)
    Else
    Begin
        AssignFile(MyFile, FileWay);
        Try
            Reset(MyFile);
            /// /////////////////////////////////////////////////////////////////////////////
        Finally
            Close(Myfile);
        End;
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
            ReadFromFile(IsCorrect, OpenDialog1.FileName);
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

Procedure TForm1.StringGrid1KeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Var
    CurrentCol, CurrentRow: Integer;
    CellText: String;
Begin
    If (Key = VK_BACK) And (StringGrid1.Col > 0) Then
    Begin
        CurrentCol := StringGrid1.Col;
        CurrentRow := StringGrid1.Row;

        CellText := StringGrid1.Cells[CurrentCol, CurrentRow];
        If Length(CellText) > 0 Then
        Begin
            Delete(CellText, Length(CellText), 1);
            StringGrid1.Cells[CurrentCol, CurrentRow] := CellText;
        End;

        Key := 0; //Отменяем действие по умолчанию для клавиши Backspace
    End
    Else
        If Key = VK_RIGHT Then
        Begin
            //Получаем текущую позицию ячейки
            Var
            Col := StringGrid1.Col;
            Var
            Row := StringGrid1.Row;

            //Переходим на следующую ячейку в строке
            If Col < StringGrid1.ColCount - 1 Then
                StringGrid1.Col := Col + 1
            Else
                If Row < StringGrid1.RowCount - 1 Then
                Begin
                    StringGrid1.Col := 0;
                    StringGrid1.Row := Row + 1;
                End;

            //Предотвращаем дальнейшую обработку клавиши-стрелки
            Key := 0;
        End
        Else
            If Key = VK_LEFT Then
            Begin
                //Получаем текущую позицию ячейки
                Var
                Col := StringGrid1.Col;

                //Переходим к предыдущей ячейке в строке
                If Col > 1 Then
                    StringGrid1.Col := Col - 1;

                //Предотвращаем дальнейшую обработку клавиши-стрелки
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

Procedure TForm1.StringGrid1KeyPress(Sender: TObject; Var Key: Char);
Var
    K: Integer;
Begin

    K := 0;
    If (Key = '-') And (Length(StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row]) <> 0) Then
        Key := #0;

    If Not((Key In ['0' .. '9']) Or (Key = '-')) Then
        Key := #0
    Else
    Begin
        If (Length(StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row]) > 3) And
            (StrToInt(StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row]) < 0) Then
            K := 1;
        If Length(StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row]) >= 6 + K Then
            Key := #0;
    End;
End;

Procedure TForm1.StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer; Var CanSelect: Boolean);
Begin
    //Проверяем, является ли текущая ячейка пустой
    If (ACol >= 0) And (ARow >= 0) And (StringGrid1.Cells[ACol, ARow] <> '') Then
        StringGrid1.Options := StringGrid1.Options - [GoRangeSelect]//Отключаем возможность выделения диапазона
    Else

End;

Procedure TForm1.StringGrid1SetEditText(Sender: TObject; ACol, ARow: Integer; Const Value: String);
Var
    Col: Integer;
Begin
    Try
        For Col := 1 To StrToInt(Form1.Edit1.Text) Do
            StrToInt(Form1.StringGrid1.Cells[Col, 1]);

        Button2.Enabled := True;
    Except
        Button2.Enabled := False;
    End;

End;

End.
