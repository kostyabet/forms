Unit Unit1_2;

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
    Vcl.Menus,
    Vcl.StdCtrls,
    Vcl.Grids;

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
        SaveDialog1: TSaveDialog;
        Button1: TButton;
        StringGrid1: TStringGrid;
        Procedure N2Click(Sender: TObject);
        Procedure FormCreate(Sender: TObject);
        Procedure N3Click(Sender: TObject);
        Procedure N7Click(Sender: TObject);
        Procedure FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
        Procedure N5Click(Sender: TObject);
        Procedure FormClick(Sender: TObject);
        Procedure Button1Click(Sender: TObject);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    Form1: TForm1;
    DataSaved: Boolean = False;

Implementation

{$R *.dfm}

Uses
    Unit1_2_1,
    Unit1_2_2;

Procedure MakingStringGrid();
Var
    J: Integer;
Begin
    Form1.StringGrid1.RowCount := 21;
    Form1.StringGrid1.ColCount := 2;
    For J := 0 To Form1.StringGrid1.ColCount - 1 Do
        Form1.StringGrid1.ColWidths[J] := 202;
    Form1.StringGrid1.Cells[0, 0] := 'Вес (кг)';
    Form1.StringGrid1.Cells[1, 0] := 'Цена (р)';
End;

Procedure InputResult();
Var
    I, Weight, DefultWeight, OneKiloCost, Cost, GRAMINKILO: Integer;
Begin
    Weight := 0;
    DefultWeight := 50;
    OneKiloCost := 280;
    GRAMINKILO := 1000;
    For I := 1 To 20 Do
    Begin
        Weight := Weight + DefultWeight;
        Cost := I * DefultWeight * OneKiloCost Div GRAMINKILO;
        Form1.StringGrid1.Cells[0, I] := IntToStr(Weight);
        Form1.StringGrid1.Cells[1, I] := IntToStr(Cost);
    End;
End;

Procedure TForm1.Button1Click(Sender: TObject);
Begin
    N5.Enabled := True;
    InputResult();
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
        If DataSaved Or (Form1.StringGrid1.Cells[1, 1] = '') Then
        Begin
            If Key = ID_NO Then
                CanClose := False
        End
        Else
            If Form1.StringGrid1.Cells[1, 1] <> '' Then
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
    Label1.Caption := 'Программа выводит таблицу стоимости порций сыра' + #13#10 + 'весом 50, 100, 150, ..., 1000 г (цена 1кг 280р.)';
    N4.Enabled := False;
    N5.Enabled := False;
    Button1.Caption := 'Рассчитать';
    MakingStringGrid();
End;

Procedure TForm1.N2Click(Sender: TObject);
Begin
    Form2.ShowModal;
End;

Procedure TForm1.N3Click(Sender: TObject);
Begin
    Form3.ShowModal;
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

Procedure OutputFromStrigGrid(Var MyFile: TextFile);
Var
    I: Integer;
Begin
    Write(MyFile, ' _____________________ ' + #13#10);
    Write(MyFile, '|          |          |' + #13#10);
    Write(MyFile, '| ' + 'Вес (кг)' + ' | ' + 'Цена (р)' + ' |' + #13#10);
    Write(MyFile, '|__________|__________|' + #13#10);
    Write(MyFile, '|          |          |' + #13#10);
    For I := 1 To 20 Do
    Begin
        Write(MyFile, '|  ');
        Write(MyFile, Form1.StringGrid1.Cells[0, I]:5);
        Write(MyFile, '   |  ');
        Write(MyFile, Form1.StringGrid1.Cells[1, I]:5);
        Write(MyFile, '   |' + #13#10);
    End;
    Write(MyFile, '|__________|__________|');
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
        OutputFromStrigGrid(MyFile);
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

Procedure TForm1.N7Click(Sender: TObject);
Begin
    Form1.Close;
End;

End.
