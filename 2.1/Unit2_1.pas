Unit Unit2_1;

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
    Vcl.Grids,
    Vcl.Menus;

Type
    TForm1 = Class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    Label3: TLabel;
    StringGrid1: TStringGrid;
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
        Procedure FormCreate(Sender: TObject);
        Procedure Edit1Enter(Sender: TObject);
        Procedure Edit1Exit(Sender: TObject);
        Procedure Label2Click(Sender: TObject);
        Procedure Label1Click(Sender: TObject);
        Procedure FormClick(Sender: TObject);
        Procedure Edit1Change(Sender: TObject);
        Procedure Edit1ContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
        Procedure Edit1Click(Sender: TObject);
        Procedure Edit1KeyPress(Sender: TObject; Var Key: Char);
        Procedure Edit1KeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure Button1Click(Sender: TObject);
        Procedure StringGrid1KeyPress(Sender: TObject; Var Key: Char);
        Procedure StringGrid1KeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure StringGrid1SetEditText(Sender: TObject; ACol, ARow: Integer; Const Value: String);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    Form1: TForm1;

Implementation

{$R *.dfm}

Procedure StringGridRowMake();
Var
    I, J: Integer;
Begin
    Form1.StringGrid1.RowCount := StrToInt(Form1.Edit1.Text) + 1;
    For I := 1 To StrToInt(Form1.Edit1.Text) Do
        Form1.StringGrid1.Cells[0, I] := IntToStr(I);
End;

Procedure TForm1.Button1Click(Sender: TObject);
Begin
    StringGridRowMake();
    StringGrid1.Visible := True;
    StringGrid1.Options := StringGrid1.Options + [GoEditing];
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
        Edit1.Clear;
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
        Edit1.Text := Copy(Edit1.Text, 1, Length(Edit1.Text) - 1);
        Edit1.SelStart := Length(Edit1.Text);

        StringGrid1.Visible := False;
    End;

    If Key = VK_RIGHT Then
        SelectNext(ActiveControl, True, True);
    If Key = VK_LEFT Then
        SelectNext(ActiveControl, False, True);
    If Key = VK_DOWN Then
        SelectNext(ActiveControl, True, True);
    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);
End;

Procedure TForm1.Edit1KeyPress(Sender: TObject; Var Key: Char);
Const
    ValidValues1: Set Of AnsiChar = ['0' .. '2'];
    ValidValues2: Set Of AnsiChar = ['0' .. '9'];
Begin
    If (Key In ValidValues1) And (Length(Edit1.Text) = 0) Then
        Key := #0;
    If Not(Key In ValidValues2) Then
        Key := #0;
    If Length(Edit1.Text) >= 2 Then
        Key := #0;
End;

Procedure DefultStringGrid();
Begin
    Form1.StringGrid1.Cells[0, 0] := 'Вершина';
    Form1.StringGrid1.Cells[1, 0] := 'X';
    Form1.StringGrid1.Cells[2, 0] := 'Y';
    Form1.StringGrid1.ColCount := 3;
End;

Procedure TForm1.FormClick(Sender: TObject);
Begin
    ActiveControl := Nil;
End;

Procedure TForm1.FormCreate(Sender: TObject);
Begin
    Edit1.Text := 'N';
    Edit1.Font.Color := ClSilver;
    Button1.Enabled := False;
    Button2.Enabled := False;
    StringGrid1.Visible := False;
    DefultStringGrid();
End;

Procedure TForm1.Label1Click(Sender: TObject);
Begin
    ActiveControl := Nil;
End;

Procedure TForm1.Label2Click(Sender: TObject);
Begin
    ActiveControl := Nil;
End;

Procedure NextCell(Row, Col: Integer);
Begin
    If Col = 1 Then
        Form1.StringGrid1.Col := Col + 1
    Else
        If Row < Form1.StringGrid1.RowCount - 1 Then
        Begin
            Form1.StringGrid1.Row := Row + 1;
            Form1.StringGrid1.Col := Col - 1;
        End;
End;

Procedure CheckCellLen(Row, Col: Integer; Var Key: Char);
Var
    MinCount: Integer;
Begin
    If (Length(Form1.StringGrid1.Cells[Col, Row]) > 2) And (Form1.StringGrid1.Cells[Col, Row][1] = '-') Then
        MinCount := 1
    Else
        MinCount := 0;

    If Length(Form1.StringGrid1.Cells[Col, Row]) >= 5 + MinCount Then
        Key := #0;
End;

Procedure DeleteElInCell(Row, Col: Integer; Var Key: Char);
Var
    TempString: String;
Begin
    TempString := Form1.StringGrid1.Cells[Col, Row];
    Delete(TempString, Length(TempString), 1);
    Form1.StringGrid1.Cells[Col, Row] := TempString;
    If TempString = '' Then
        Form1.Button2.Enabled := False;
    Key := #0;
End;

Procedure TForm1.StringGrid1KeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Var
    Col: Integer;
Begin
    Col := StringGrid1.Col;

    If Key = VK_RIGHT Then
    Begin
        If Col < StringGrid1.ColCount - 1 Then
            StringGrid1.Col := Col + 1;
    End;

    If Key = VK_LEFT Then
    Begin
        If Col > 1 Then
            StringGrid1.Col := Col - 1;
    End;
End;

Procedure TForm1.StringGrid1KeyPress(Sender: TObject; Var Key: Char);
Const
    ValidValues: Set Of AnsiChar = ['0' .. '9'];
Var
    Row, Col: Integer;
Begin
    Row := StringGrid1.Row;
    Col := StringGrid1.Col;

    If Key = #13 Then
        NextCell(Row, Col);
    If Key = #08 Then
        DeleteElInCell(Row, Col, Key);

    If (Key = '-') And (Length(StringGrid1.Cells[Col, Row]) <> 0) Then
        Key := #0;

    If (StringGrid1.Cells[Col, Row] = '-0') Or (StringGrid1.Cells[Col, Row] = '0') Then
        Key := #0;

    If Not((Key In ValidValues) Or (Key = '-')) Then
        Key := #0;

    CheckCellLen(Row, Col, Key);
End;

Procedure TForm1.StringGrid1SetEditText(Sender: TObject; ACol, ARow: Integer; Const Value: String);
Var
    I, J: Integer;
Begin
    Try
        For I := 1 To 2 Do
            For J := 1 To StrToInt(Edit1.Text) Do
                StrToInt(StringGrid1.Cells[I, J]);

        Button2.Enabled := True;
    Except
        Button2.Enabled := False;
    End;
End;

End.
