Unit MainUnit;

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
    Vcl.StdCtrls,
    Vcl.Menus,
    Vcl.Grids, Vcl.Buttons;

Type
    TMassive = Array Of Integer;
    TForm1 = Class(TForm)
        Label1: TLabel;
        Label2: TLabel;
        Edit1: TEdit;
        Button1: TButton;
        StringGrid1: TStringGrid;
        Button2: TButton;
        Label3: TLabel;
        MainMenu1: TMainMenu;
        N1: TMenuItem;
        N2: TMenuItem;
        N3: TMenuItem;
        N4: TMenuItem;
        N5: TMenuItem;
        N6: TMenuItem;
        N7: TMenuItem;
        OpenDialog1: TOpenDialog;
        SaveDialog1: TSaveDialog;
    BitBtn1: TBitBtn;
        Procedure Edit1Change(Sender: TObject);
        Procedure Edit1ContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
        Procedure Edit1KeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure Edit1KeyPress(Sender: TObject; Var Key: Char);
        Procedure Button1Click(Sender: TObject);
        Procedure StringGrid1KeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
    procedure StringGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure StringGrid1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button2Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    Form1: TForm1;
    Error: Integer = 0;
    DataSaved: Boolean = false;

Implementation

{$R *.dfm}

uses InstractionUnit, AboutEditorUnit, StepByStepUnit;

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

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
    StepByStep.ShowModal;
end;

Procedure TForm1.Button1Click(Sender: TObject);
Begin
    StringGrid1.ColCount := StrToInt(Edit1.Text) + 1;
    StringGrid1.RowCount := 2;
    DefultStringGrid();
    StringGrid1.Visible := True;
    Button2.Visible := true;
    BitBtn1.Visible := true;
End;

Procedure SortMassive(Var ArrOfNumb: TMassive);
Var
    Temp, I, J, K: Integer;
Begin
    For I := 1 To High(ArrOfNumb) Do
    Begin
        Temp := ArrOfNumb[I];

        J := I - 1;
        While (J >= 0) And (ArrOfNumb[J] > Temp) Do
        Begin
            ArrOfNumb[J + 1] := ArrOfNumb[J];
            ArrOfNumb[J] := Temp;
            Dec(J);

            StepByStep.StringGrid1.RowCount := StepByStep.StringGrid1.RowCount + 1;
        StepByStep.StringGrid1.Cells[0,StepByStep.StringGrid1.RowCount - 1] := IntToStr(StepByStep.StringGrid1.RowCount - 2) + '.';
        for K := 1 to StepByStep.StringGrid1.ColCount - 1 do
            StepByStep.StringGrid1.Cells[K, StepByStep.StringGrid1.RowCount - 1] := IntToStr(ArrOfNumb[K-1]);
        End;
    End;
End;

Procedure createMassive(var ArrOfNumb: TMassive);
var
  I: Integer;
begin
    for I := 0 to High(ArrOfNumb) do
    begin
        ArrOfNumb[I] := StrToInt(Form1.StringGrid1.Cells[I + 1,1]);
        StepByStep.StringGrid1.Cells[I + 1,1] := IntToStr(ArrOfNumb[I]);
    end;
end;

Procedure outputInGrid(var ArrOfNumb: TMassive);
var
    I : integer;
begin
    for I := 0 to High(ArrOfNumb) do
        Form1.StringGrid1.Cells[I + 1, 1] := IntToStr(ArrOfNumb[i]);
end;

Procedure StepByStepPreparation(StrGrd: TStringGrid);
var
  I: Integer;
begin
    StrGrd.ColCount := StrToInt(Form1.Edit1.Text) + 1;
    StrGrd.Cells[0,0] := '№';
    StrGrd.Cells[0,1] := '0.';

    StrGrd.RowCount := 2;

    for I := 1 to StrGrd.ColCount do
    begin
        StrGrd.Cells[I, 0] := 'a[' + IntToStr(I - 1) + ']';
        StrGrd.Cells[I, 1] := '';
    end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
    ArrOfNumb:TMassive;
begin                   
    SetLength(ArrOfNumb, StrToInt(Edit1.Text));
    StepByStepPreparation(StepByStep.StringGrid1);
    createMassive(ArrOfNumb);

    SortMassive(ArrOfNumb);

    outputInGrid(ArrOfNumb);
    
    
    Label3.Visible := true;
    N3.Enabled := true;
    BitBtn1.Enabled := true;
    
end;

Procedure TForm1.Edit1Change(Sender: TObject);
Begin
    Try
        StrToInt(Edit1.Text);
        Button1.Enabled := True;
    Except
        Button1.Enabled := False;
    End;
End;

Procedure TForm1.Edit1ContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := True;
End;

Function CheckDelete(Tempstr: Tcaption; Cursor: Integer): Boolean;
Begin
    Delete(Tempstr, Cursor, 1);
    If (Length(Tempstr) >= 1) And (Tempstr[1] = '0') Then
        CheckDelete := False
    Else
        CheckDelete := True;
End;

Procedure TForm1.Edit1KeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
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
End;

Procedure TForm1.Edit1KeyPress(Sender: TObject; Var Key: Char);
Begin
    StringGrid1.Visible := false;
    Label3.Visible := false;
    Button2.Visible := false;
    N3.Enabled := false;
    DataSaved := false;
    BitBtn1.Visible := false;
    
    If (Key = '0') And (Edit1.SelStart = 0) Then
        Key := #0;

    If Not(Key In ['0' .. '9']) Then
        Key := #0;

    If (Edit1.SelText <> '') And (Key <> #0) Then
        Edit1.ClearSelection;

    If Length(Edit1.Text) >= 2 Then
        Key := #0;
End;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
Var
    Key: Integer;
Begin
    Key := Application.Messagebox('Вы уверены, что хотите закрыть набор записей?', 'Выход', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);
    If Key = ID_NO Then
        CanClose := False
    Else
    Begin
        If DataSaved Or (Label3.Visible = false) Then
        Begin
            If Key = ID_NO Then
                CanClose := False
        End
        Else
            If Label3.Visible Then
            Begin
                Key := Application.Messagebox('Вы не сохранили результат. Хотите сделать это?', 'Сохранение',
                    MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);
                If Key = ID_YES Then
                    N3.Click;
            End;
    End;
end;

Function TryRead(Var TestFile: TextFile): Boolean;
Var
    BufferInt, bufferCount, I: Integer;
    ReadStatus: Boolean;
Begin
    ReadStatus := True;
    Readln(TestFile, BufferInt);
    If (BufferInt < 1) Or (BufferInt > 99) Then
        ReadStatus := False
    Else
    Begin
        for I := 0 to bufferInt - 1 do
        begin
            Read(TestFile, bufferCount);
            if (bufferCount < -999999) or (buffercount > 999999) then
                ReadStatus := false;
        end
    End;

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

Procedure ReadMassive(var MyFile: TextFile);
var
    i, size, count: integer;
begin
    Readln(MyFile, size);
    Form1.Edit1.Text := IntToStr(size);
    Form1.Button1.Click;
    for I := 0 to size - 1 do
    begin
        Read(MyFile, count);
        Form1.StringGrid1.Cells[I + 1,1] := IntToStr(count);
    end;
    Form1.Button2.Enabled := true;
end;

Procedure ReadFromFile(IsCorrect: Boolean; Error: Integer; FileWay: String);
Var
    MyFile: TextFile;
Begin
    If Not(IsCorrect) And (Error = 0) Then
        MessageBox(0, 'Данные в выбранном файле не корректны!', 'Ошибка', MB_ICONERROR)
    Else
    Begin
        AssignFile(MyFile, FileWay);
        Reset(MyFile);
        ReadMassive(MyFile);
        Close(MyFile);
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
            ReadFromFile(IsCorrect, Error, OpenDialog1.FileName);
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

Procedure WriteInFile(var MyFile: TextFile; StepByStep: TStringGrid; ResultGrid: TStringGrid);
var
    i, j:integer;
    res:string;
begin
    res := 'Отсортированный массив: ';
    for I := 1 to ResultGrid.ColCount - 1 do
        res := res + ResultGrid.Cells[I,1] + ' ';
        
    res := res + #13#10 + #13#10 + 'Пошаговая детализация' + #13#10;
    for I := 1 to StepByStep.RowCount - 1 do
    begin
        for J := 0 to StepByStep.ColCount - 1 do
            res := res + StepByStep.Cells[J,I] + ' ';
        res := res + #13#10;
    end;

    Write(MyFile, res);
end;

Procedure InputInFile(IsCorrect: Boolean; FileName: String);
Var
    MyFile: TextFile;
Begin
    If IsCorrect Then
    Begin
        DataSaved := True;
        AssignFile(MyFile, FileName, CP_UTF8);
        ReWrite(MyFile);
        WriteInFile(MyFile, StepByStep.StringGrid1, Form1.StringGrid1);
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

procedure TForm1.N6Click(Sender: TObject);
begin
    Instraction.ShowModal;
end;

procedure TForm1.N7Click(Sender: TObject);
begin
    AboutEditor.ShowModal;
end;

Procedure TForm1.StringGrid1KeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Var
    CellText: String;
Begin
    If Key = VK_BACK Then
    Begin
        CellText := StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row];
        Delete(CellText, Length(StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row]), 1);
        StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row] := CellText;

        Key := 0;
    End;
End;

procedure TForm1.StringGrid1KeyPress(Sender: TObject; var Key: Char);
Var
    Minus: Integer;
Begin
    Label3.Visible := false;
    N3.Enabled := false;
    DataSaved := false;
    BitBtn1.Enabled := false;

    If (Key = '0') And (Length(StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row]) <> 0) And
        (StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row][1] = '-') Then
        Key := #0;

    If (Key = '-') And (Length(StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row]) <> 0) Then
        Key := #0;

    If (StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row] = '0') Or (StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row] = '-0') Then
        Key := #0;

    If Not((Key In ['0' .. '9']) Or (Key = '-')) Then
        Key := #0;

    If (Length(StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row]) >= 1) And
        (StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row][1] = '-') Then
        Minus := 1
    Else
        Minus := 0;

    If (Length(StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row]) >= 6 + Minus) Then
        Key := #0;

    If (Key <> #0) Then
        StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row] := StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row] + Key;
end;

procedure TForm1.StringGrid1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
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
end;

End.
