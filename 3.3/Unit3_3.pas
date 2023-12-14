Unit Unit3_3;

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
    Vcl.Grids;

Type
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
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    Form1: TForm1;

Implementation

{$R *.dfm}

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
    StringGrid1.ColCount := StrToInt(Edit1.Text) + 1;
    StringGrid1.RowCount := 2;
    DefultStringGrid();
    StringGrid1.Visible := True;
    Button2.Visible := true;
End;

procedure TForm1.Button2Click(Sender: TObject);
begin
    Label3.Visible := true;
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
    
    If (Key = '0') And (Edit1.SelStart = 0) Then
        Key := #0;

    If Not(Key In ['0' .. '9']) Then
        Key := #0;

    If (Edit1.SelText <> '') And (Key <> #0) Then
        Edit1.ClearSelection;

    If Length(Edit1.Text) >= 2 Then
        Key := #0;
End;

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
