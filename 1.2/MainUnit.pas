﻿Unit MainUnit;

Interface

Uses
    Clipbrd,
    Winapi.Windows,
    Winapi.Messages,
    System.SysUtils,
    System.Variants,
    System.Classes,
    Vcl.Graphics,
    Vcl.Controls,
    Vcl.Forms,
    Vcl.Dialogs,
    Vcl.Menus,
    Vcl.StdCtrls,
    Vcl.Grids;

Type
    TMainForm = Class(TForm)
        MainMenu: TMainMenu;
        FileMMButton: TMenuItem;
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
        Procedure FormCreate(Sender: TObject);
        Procedure ResultButtonClick(Sender: TObject);
        Procedure CheeseCostTabelKeyPress(Sender: TObject; Var Key: Char);
        Procedure CheeseCostTabelKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure ConditionMMButtonClick(Sender: TObject);
        Procedure AboutEditorMMButtonClick(Sender: TObject);
        Procedure SaveMMButtonClick(Sender: TObject);
        Procedure FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
        Procedure CloseMMButtonClick(Sender: TObject);
        Function FormHelp(Command: Word; Data: NativeInt; Var CallHelp: Boolean): Boolean;
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    MainForm: TMainForm;
    DataSaved: Boolean = False;

Implementation

{$R *.dfm}

Uses
    ConditionUnit,
    EditorUnit;

Procedure CreateGrid();
Const
    Mith: Integer = 50;
    ONEKILOCOST: Integer = 280;
    GRAMINKILO: Integer = 1000;
Var
    I, HighI: Integer;
Begin
    HighI := GRAMINKILO Div Mith;
    For I := 1 To HighI Do
    Begin
        MainForm.CheeseCostTabel.Cells[0, I] := IntToStr(I * Mith);
        MainForm.CheeseCostTabel.Cells[1, I] := IntToStr((I * Mith * ONEKILOCOST) Div (GRAMINKILO));
    End;
End;

Procedure DefultGrid();
Begin
    MainForm.CheeseCostTabel.RowCount := 21;
    MainForm.CheeseCostTabel.ColCount := 2;
    MainForm.CheeseCostTabel.Cells[0, 0] := 'Вес (г)';
    MainForm.CheeseCostTabel.Cells[1, 0] := 'Цена (р)';
End;

Procedure TMainForm.ResultButtonClick(Sender: TObject);
Begin
    CreateGrid();

    ResultButton.Enabled := False;
    CheeseCostTabel.Enabled := True;
    SaveMMButton.Enabled := True;
End;

Procedure TMainForm.FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
Var
    Key: Integer;
Begin
    Key := Application.Messagebox('Вы уверены, что хотите закрыть набор записей?', 'Выход', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);

    If (Key = ID_NO) Then
        CanClose := False;

    If (Key = ID_YES) And Not DataSaved And (ResultButton.Enabled = False) Then
    Begin
        Key := Application.Messagebox('Вы не сохранили результат. Хотите сделать это?', 'Сохранение',
            MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);
        If Key = ID_YES Then
            SaveMMButton.Click;
    End;
End;

Procedure TMainForm.FormCreate(Sender: TObject);
Begin
    DefultGrid();
End;

Function TMainForm.FormHelp(Command: Word; Data: NativeInt; Var CallHelp: Boolean): Boolean;
Begin
    CallHelp := False;
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

Procedure WritingInFile(Var MyFile: TextFile);
Var
    I, HighI: Integer;
    Temp1, Temp2: String;
Begin
    Writeln(MyFile, ' _____________________');
    Writeln(MyFile, '|          |          |');
    Writeln(MyFile, '| Вес (г)  | Цена (р) |');
    Writeln(MyFile, '|__________|__________|');
    Writeln(MyFile, '|          |          |');

    HighI := MainForm.CheeseCostTabel.RowCount - 1;
    For I := 1 To HighI Do
    Begin
        Temp1 := MainForm.CheeseCostTabel.Cells[0, I];
        Temp2 := MainForm.CheeseCostTabel.Cells[1, I];
        Writeln(MyFile, '| ', Temp1:6, '   | ', Temp2:6, '   |');
    End;

    Writeln(MyFile, '|__________|__________|');
End;

Procedure InputInFile(IsCorrect: Boolean; FileName: String);
Var
    MyFile: TextFile;
Begin
    If IsCorrect Then
    Begin
        AssignFile(MyFile, FileName, CP_UTF8);
        ReWrite(MyFile);
        WritingInFile(MyFile);
        Close(MyFile);

        DataSaved := True;
    End;
End;

Procedure TMainForm.SaveMMButtonClick(Sender: TObject);
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
End;

Procedure TMainForm.CloseMMButtonClick(Sender: TObject);
Begin
    MainForm.Close;
End;

Procedure TMainForm.ConditionMMButtonClick(Sender: TObject);
Begin
    Instraction.ShowModal;
End;

Procedure TMainForm.AboutEditorMMButtonClick(Sender: TObject);
Begin
    AboutEditor.ShowModal;
End;

Procedure TMainForm.CheeseCostTabelKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    If (Shift = [SsCtrl]) And (Key = Ord('C')) Then
    Begin
        Clipboard.AsText := CheeseCostTabel.Cells[CheeseCostTabel.Col, CheeseCostTabel.Row];
        CopyLabel.Caption := 'Число ''' + CheeseCostTabel.Cells[CheeseCostTabel.Col, CheeseCostTabel.Row] +
            ''' скопировано в буфер обмена.';
    End;
    If Not((Key = VK_UP) Or (Key = VK_DOWN)) Then
        Key := 0;
End;

Procedure TMainForm.CheeseCostTabelKeyPress(Sender: TObject; Var Key: Char);
Begin
    If (Key = #13) And (CheeseCostTabel.Row < CheeseCostTabel.RowCount - 1) Then
        CheeseCostTabel.Row := CheeseCostTabel.Row + 1;

    Key := #0;
End;

End.
