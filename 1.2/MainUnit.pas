unit MainUnit;

interface

uses
  Clipbrd, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls, Vcl.Grids;

type
  TMainForm = class(TForm)
    MainMenu: TMainMenu;
    FileMMButton: TMenuItem;
    OpenMMButton: TMenuItem;
    SaveMMButton: TMenuItem;
    LineMM: TMenuItem;
    CloseMMButton: TMenuItem;
    ConditionMMButton: TMenuItem;
    AboutEditorMMButton: TMenuItem;
    TaskLabel: TLabel;
    ResultButton: TButton;
    CheeseCostTabel: TStringGrid;
    CopyLabel: TLabel;
    SaveDialog: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure ResultButtonClick(Sender: TObject);
    procedure CheeseCostTabelKeyPress(Sender: TObject; var Key: Char);
    procedure CheeseCostTabelKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ConditionMMButtonClick(Sender: TObject);
    procedure AboutEditorMMButtonClick(Sender: TObject);
    procedure SaveMMButtonClick(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CloseMMButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  DataSaved: Boolean = false;

implementation

{$R *.dfm}

uses ConditionUnit, EditorUnit;

procedure createGrid();
const
    Mith:Integer = 50;
    ONEKILOCOST: Integer = 280;
    GRAMINKILO: Integer = 1000;
var
    i:integer;
begin
    for I := 1 to 20 do
    begin
        MainForm.CheeseCostTabel.Cells[0, I] := IntToStr(I * Mith); 
        MainForm.CheeseCostTabel.Cells[1, I] := IntToStr((I * Mith * ONEKILOCOST) Div (GRAMINKILO));    
    end;
end;

procedure defultGrid();
begin
    MainForm.CheeseCostTabel.RowCount := 21;
    MainForm.CheeseCostTabel.ColCount := 2;
    MainForm.CheeseCostTabel.Cells[0,0] := 'Вес (г)';
    MainForm.CheeseCostTabel.Cells[1,0] := 'Цена (р)';
    
end;

procedure TMainForm.ResultButtonClick(Sender: TObject);
begin
    ResultButton.Enabled := false;
    createGrid();
    CheeseCostTabel.Options := CheeseCostTabel.Options + [goEditing, goAlwaysShowEditor];
    CheeseCostTabel.Enabled := true;
    SaveMMButton.Enabled := True;
end;

procedure TMainForm.FormClick(Sender: TObject);
begin
    ActiveControl := Nil;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
Var
    Key: Integer;
Begin
    Key := Application.Messagebox('Вы уверены, что хотите закрыть набор записей?', 'Выход', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);
    If Key = ID_NO Then
        CanClose := False
    Else
    Begin
        If DataSaved Or (ResultButton.Enabled = true) Then
        Begin
            If Key = ID_NO Then
                CanClose := False
        End
        Else
            If ResultButton.Enabled = false Then
            Begin
                Key := Application.Messagebox('Вы не сохранили результат. Хотите сделать это?', 'Сохранение',
                    MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);
                If Key = ID_YES Then
                    SaveMMButton.Click;
            End;
    End;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
    defultGrid();
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

Procedure WritingInFile(var MyFile : TextFile);
var
  I: Integer;
begin
    Writeln(MyFile, ' _____________________');
    Writeln(MyFile, '|          |          |');
    Writeln(MyFile, '| Вес (г)  | Цена (р) |');
    Writeln(MyFile, '|__________|__________|');
    Writeln(MyFile, '|          |          |');
    for I := 1 to MainForm.CheeseCostTabel.RowCount - 1 do
    begin
        var temp1 := MainForm.CheeseCostTabel.Cells[0,I];
        var temp2 := MainForm.CheeseCostTabel.Cells[1,I];
        Writeln(MyFile, '| ', temp1:6, '   | ', temp2:6, '   |');
    end;
    Writeln(MyFile, '|__________|__________|');
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
        WritingInFile(MyFile);
        Close(MyFile);
    End;
End;

procedure TMainForm.SaveMMButtonClick(Sender: TObject);
Var
    IsCorrect: Boolean;
Begin
    Repeat
        If SaveDialog.Execute Then
        Begin
            IsCorrect := IsCanWrite(SaveDialog.FileName);
            InputInFile(IsCorrect, SaveDialog.FileName);
        End
        Else
            IsCorrect := True;
    Until IsCorrect;
end;

procedure TMainForm.CloseMMButtonClick(Sender: TObject);
begin
    MainForm.Close;
end;

procedure TMainForm.ConditionMMButtonClick(Sender: TObject);
begin
    Instraction.ShowModal;
end;

procedure TMainForm.AboutEditorMMButtonClick(Sender: TObject);
begin
    AboutEditor.ShowModal;
end;

procedure TMainForm.CheeseCostTabelKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if (Shift = [ssCtrl]) and (Key = Ord('C')) then
    begin
        Clipboard.AsText := CheeseCostTabel.Cells[CheeseCostTabel.Col, CheeseCostTabel.Row];
        CopyLabel.Caption := 'число ''' + CheeseCostTabel.Cells[CheeseCostTabel.Col, CheeseCostTabel.Row] + ''' скопировано в буфер обмена.';
    end;
    if not ((Key = VK_UP) or (Key = VK_DOWN)) then
        Key := 0;
end;

procedure TMainForm.CheeseCostTabelKeyPress(Sender: TObject; var Key: Char);
begin
    if (Key = #13) and (CheeseCostTabel.Row < CheeseCostTabel.RowCount - 1) then
        CheeseCostTabel.Row := CheeseCostTabel.Row + 1;        
    Key := #0;
end;

end.
