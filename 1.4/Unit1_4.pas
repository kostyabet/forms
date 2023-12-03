unit Unit1_4;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.UITypes, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Menus, Vcl.Grids;

type
  TForm1 = class(TForm)
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
    Label3: TLabel;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Edit1ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure Edit1Enter(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Label1Click(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure StringGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure StringGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Label3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  MinCount: Integer = 0;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  I: Integer;
begin
    Form1.StringGrid1.ColCount := StrToInt(Edit1.Text);

    for I := 0 to StringGrid1.ColCount - 1 do
        StringGrid1.ColWidths[I] := 58;
    
    if StringGrid1.ColCount > 6 then
    begin
        for I := 0 to StringGrid1.ColCount - 1 do
            StringGrid1.ColWidths[I] := 58;
        StringGrid1.RowHeights[0] := 30;
        StringGrid1.ScrollBars := ssHorizontal;
    end
    else
    begin
        for I := 0 to StringGrid1.ColCount - 1 do
            StringGrid1.ColWidths[I] := 355 div StringGrid1.ColCount;
        StringGrid1.RowHeights[0] := 50;    
    end;

    StringGrid1.Options := StringGrid1.Options + [goEditing];
    StringGrid1.Options := StringGrid1.Options + [goAlwaysShowEditor];
    
    Label3.Caption := 'Вводите числа и нажимайте кнопку рассчитать.';
end;

procedure TForm1.Edit1Change(Sender: TObject);
begin
    try
        StrToInt(Edit1.Text);
        Button1.Enabled := true;
    except
        Button1.Enabled := false;
    end;
end;

procedure TForm1.Edit1Click(Sender: TObject);
begin
    Edit1.SelStart := Length(Edit1.Text);
end;

procedure TForm1.Edit1ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin
    Handled := True;
end;

procedure TForm1.Edit1Enter(Sender: TObject);
begin
    If Edit1.Text = 'N' Then
    Begin
        Edit1.Clear;
        Edit1.Font.Color := Clblack;
    End;
end;

procedure TForm1.Edit1Exit(Sender: TObject);
begin
    If Edit1.Text = '' Then
    Begin
        Edit1.Text := 'N';
        Edit1.Font.Color := ClGray;
    End;
end;

procedure TForm1.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    TEdit(Sender).ReadOnly := (SsShift In Shift) Or (SsCtrl In Shift);

    If (Key = VK_BACK) Then
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
end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
    if (Length(Edit1.Text) <> 0) and (Key = '-') then
        Key := #0;
        
    if not (Key in ['0'..'9']) then
        Key := #0
    else if (length(Edit1.Text) >= 2) then
        Key := #0;
end;

procedure TForm1.FormClick(Sender: TObject);
begin
    ActiveControl := Nil;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    Label1.Font.Style := Label1.Font.Style + [FsBold];
    label1.Caption := 'Программа вычисляет сумму эллементов массива' + 
    #13#10 + 'по принципу: А1 + А3 + А5 + ... + А2N-1';
    label2.Caption := 'Введите размер массива: ';
    Edit1.Text := 'N';
    Edit1.Font.Color := ClGray;
    Button1.Caption := 'Создать массив';
    Button1.Enabled := False;
    Form1.StringGrid1.RowCount := 1;
    StringGrid1.ColWidths[0] := 356;
    Form1.StringGrid1.ColCount := 1;
    StringGrid1.RowHeights[0] := 50;
    StringGrid1.ScrollBars := ssNone;
    Label3.Caption := '';
    Button2.Caption := 'Рассчитать';
    Button2.Enabled := false; 
end;

procedure TForm1.Label1Click(Sender: TObject);
begin
    ActiveControl := Nil;
end;

procedure TForm1.Label2Click(Sender: TObject);
begin
    ActiveControl := Nil;
end;

procedure TForm1.Label3Click(Sender: TObject);
begin
    ActiveControl := Nil;
end;

procedure TForm1.N1Click(Sender: TObject);
begin
    ActiveControl := Nil;
end;

procedure TForm1.N6Click(Sender: TObject);
begin
    ActiveControl := Nil;
end;

procedure TForm1.N7Click(Sender: TObject);
begin
    ActiveControl := Nil;
end;

procedure DeletionCheck();
begin
    if copy(Form1.StringGrid1.Cells[Form1.StringGrid1.Col, Form1.StringGrid1.Row], Length(Form1.StringGrid1.Cells[Form1.StringGrid1.Col, Form1.StringGrid1.Row]) - 1, 1) = '-' then
        MinCount := 0;
end;

procedure TForm1.StringGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    TEdit(Sender).ReadOnly := (SsShift In Shift) Or (SsCtrl In Shift);

    If Key = VK_BACK Then
    Begin
        DeletionCheck();
        StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row] := Copy(StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row], 1, Length(StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row]) - 1);
        //StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row].SelStart := Length(StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row]);
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
end;

procedure TForm1.StringGrid1KeyPress(Sender: TObject; var Key: Char);
begin
    StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row];
    if (Key = '-') and (Length(StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row]) <> 0) then
        Key := #0
    else if Key = '-' then
        MinCount := 1;

    if not ((Key in ['0'..'9']) or (Key = '-')) then
        Key := #0
    else if (Length(StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row]) >= 5 + MinCount) then
        Key := #0;
end;

end.
