unit Unit2_3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Menus;

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
    Label3: TLabel;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    procedure N6Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure Edit1ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure Edit1Change(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses Unit2_3_1, Unit2_3_2;

Procedure PutInMassive(Var ArrPalin: Array Of Integer; Palindrome: Integer);
Var
    I: Integer;
Begin
    I := 0;
    While Palindrome > 0 Do
    Begin
        ArrPalin[I] := Palindrome Mod 10;
        Inc(I);
        Palindrome := Palindrome Div 10;
    End;
End;

Function PalinIsPalin(Var ArrPalin: Array Of Integer; PalinLen: Integer; Palindrome: Integer): Boolean;
Var
    IsCorrect: Boolean;
    I: Integer;
Begin
    IsCorrect := True;
    For I := 0 To PalinLen Div 2 Do
        If (ArrPalin[I] <> ArrPalin[PalinLen - I - 1]) Then
            IsCorrect := False;
    If Palindrome < 0 Then
        IsCorrect := False;

    PalinIsPalin := IsCorrect;
End;

Function LengthOfPalin(Palindrome: Integer): Integer;
Var
    PalinLen: Integer;
Begin
    PalinLen := 0;
    While (Palindrome > 0) Do
    Begin
        Inc(PalinLen);
        Palindrome := Palindrome Div 10;
    End;

    LengthOfPalin := PalinLen;
End;

Function PalinCheack(Palindrome: Integer): string;
Var
    PalinLen: Integer;
    Res: Boolean;
    ArrPalin: Array Of Integer;
Begin
    PalinLen := LengthOfPalin(Palindrome);
    SetLength(ArrPalin, PalinLen);
    PutInMassive(ArrPalin, Abs(Palindrome));

    Res := PalinIsPalin(ArrPalin, PalinLen, Palindrome);

    ArrPalin := Nil;

    if res then
        PalinCheack := 'палиндором.'
    else
        PalinCheack := 'не палиндром.';
End;

procedure TForm1.Button1Click(Sender: TObject);
begin
    Label3.Caption := 'Ваше число ' + PalinCheack(StrToInt(Edit1.Text));
    N3.Enabled := True;
    Label3.Visible := true;
end;

procedure TForm1.Edit1Change(Sender: TObject);
begin
    Try
        StrToInt(Edit1.Text);
        Button1.Enabled := True;
    Except
        Button1.Enabled := False;
    End;
end;

procedure TForm1.Edit1ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin
    Handled := True;
end;

Function CheckDelete(Tempstr: Tcaption; Cursor: Integer): Boolean;
Begin
    Delete(Tempstr, Cursor, 1);
    ////////////////////////////////////////////////////////////////////////////
    If (Tempstr = '0') Or (Tempstr = '00') Or (Tempstr = '000') Or ((Length(Tempstr) >= 2) And (Tempstr[1] = '0') And (TempStr[2] <> '0'))
        Or ((Length(Tempstr) >= 3) And (Tempstr[1] = '0') And (Tempstr[2] = '0') And (TempStr[3] <> '0')) Then
        CheckDelete := False
    Else
        CheckDelete := True;
End;

procedure TForm1.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    TEdit(Sender).ReadOnly := (SsShift In Shift) Or (SsCtrl In Shift);

    If Key = VK_DELETE Then
        Key := 0;

    If (Key = VK_BACK) And (Edit1.SelText <> '') Then
    Begin
        Edit1.ClearSelection;
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
end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
    If (Key = '0') And (Edit1.SelStart = 0) Then
        Key := #0;

    If Not(Key In ['0' .. '9']) Then
        Key := #0
    Else
        If (Length(Edit1.Text) >= 10) Then
            Key := #0;
end;

procedure TForm1.FormClick(Sender: TObject);
begin
    ActiveControl := Nil;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    Button1.Enabled := false;
    N3.Enabled := False;
end;

procedure TForm1.Label1Click(Sender: TObject);
begin
    ActiveControl := Nil;
end;

procedure TForm1.Label2Click(Sender: TObject);
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
    Form2.ShowModal;
    Form2.Free;
end;

procedure TForm1.N7Click(Sender: TObject);
begin
    ActiveControl := Nil;
    Form3.ShowModal;
    Form3.Free;
end;

end.
