Unit MainUnit;

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
    Vcl.StdCtrls,
    Vcl.Menus;

Type
    TMainForm = Class(TForm)
        ConditionLabel: TLabel;
        KEdit: TEdit;
        St1Edit: TEdit;
        St2Edit: TEdit;
        KLabel: TLabel;
        St1Label: TLabel;
        St2Label: TLabel;
        ResultButton: TButton;
        ResultLabel: TLabel;
        MainMenu: TMainMenu;
        FileMMButton: TMenuItem;
        OpenMMButton: TMenuItem;
        SaveMMButton: TMenuItem;
        LineMM: TMenuItem;
        CloseMMButton: TMenuItem;
        InstractionMMButton: TMenuItem;
        AboutEditorMMButton: TMenuItem;
        SaveDialog: TSaveDialog;
        OpenDialog: TOpenDialog;
        Procedure KEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure KEditKeyPress(Sender: TObject; Var Key: Char);
        Procedure St1EditKeyPress(Sender: TObject; Var Key: Char);
        Procedure St2EditKeyPress(Sender: TObject; Var Key: Char);
        Procedure KEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
        Procedure KEditChange(Sender: TObject);
        Procedure St1EditChange(Sender: TObject);
        Procedure St2EditChange(Sender: TObject);
        Procedure St2EditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure St1EditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure St1EditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
        Procedure St2EditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
        Procedure ResultButtonClick(Sender: TObject);
        Procedure InstractionMMButtonClick(Sender: TObject);
        Procedure AboutEditorMMButtonClick(Sender: TObject);
        Procedure SaveMMButtonClick(Sender: TObject);
        Procedure OpenMMButtonClick(Sender: TObject);
        Procedure CloseMMButtonClick(Sender: TObject);
        Procedure FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
        Function FormHelp(Command: Word; Data: NativeInt; Var CallHelp: Boolean): Boolean;
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    MainForm: TMainForm;
    DataSaved: Boolean = False;
    Error: Integer = 0;

Implementation

{$R *.dfm}

Uses
    InstractionUnit,
    AboutEditorUnit;

Procedure ButtonStat();
Begin
    If (MainForm.KEdit.Text <> '') And (MainForm.St1Edit.Text <> '') And (MainForm.St2Edit.Text <> '') Then
        MainForm.ResultButton.Enabled := True
    Else
        MainForm.ResultButton.Enabled := False;
End;

Function CheckDelete(Tempstr: Tcaption; Cursor: Integer): Boolean;
Begin
    Delete(Tempstr, Cursor, 1);
    If (Length(Tempstr) >= 1) And ((Tempstr[1] = '0') Or (Tempstr[1] = '5') Or (Tempstr[1] = '6') Or (Tempstr[1] = '7') Or
        (Tempstr[1] = '8') Or (Tempstr[1] = '9')) Then
        CheckDelete := False
    Else
        CheckDelete := True;
End;

Function IsStringsEqual(Str1, Str2: String; I: Integer): Boolean;
Var
    J: Integer;
    IsCorrect: Boolean;
Begin
    IsCorrect := True;
    For J := 2 To Length(Str1) Do
        If (I + J - 1 <= Length(Str2)) Then
        Begin
            If IsCorrect And (Str2[I + J - 1] <> Str1[J]) Then
                IsCorrect := False;
        End
        Else
            IsCorrect := False;
    IsStringsEqual := IsCorrect;
End;

Function CalculationOfTheResult(K: Integer; Str1, Str2: String): Integer;
Var
    Res, I: Integer;
    IsCorrect: Boolean;
Begin
    Res := -1;
    For I := 1 To Length(Str2) Do
        If (Length(Str1) <= Length(Str2)) And (Str2[I] = Str1[1]) And (K > 0) Then
        Begin
            IsCorrect := IsStringsEqual(Str1, Str2, I);
            If IsCorrect Then
                Dec(K);
            If ((K = 0) And IsCorrect) Then
                Res := I;
        End;
    CalculationOfTheResult := Res;
End;

Procedure TMainForm.ResultButtonClick(Sender: TObject);
Begin
    ResultLabel.Caption := 'Результат: ' + IntToStr(CalculationOfTheResult(StrToInt(KEdit.Text), St1Edit.Text, St2Edit.Text));
    SaveMMButton.Enabled := True;
End;

Procedure TMainForm.KEditChange(Sender: TObject);
Begin
    ButtonStat();
End;

Procedure TMainForm.KEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := True;
End;

Procedure TMainForm.KEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    TEdit(Sender).ReadOnly := (SsShift In Shift) Or (SsCtrl In Shift);

    If Key = VK_DELETE Then
        Key := 0;

    If (Key = VK_BACK) And (KEdit.SelText <> '') Then
    Begin
        Var
        Temp := KEdit.Text;
        KEdit.ClearSelection;
        If (Length(KEdit.Text) >= 1) And (KEdit.Text[1] = '0') Then
        Begin
            KEdit.Text := Temp;
            KEdit.SelStart := KEdit.SelStart + 1;
        End
        Else
        Begin
            SaveMMButton.Enabled := False;
            ResultLabel.Caption := '';
        End;
        Key := 0;
    End;

    If (Key = VK_BACK) Then
    Begin
        Var
        Tempstr := KEdit.Text;
        Var
        Cursor := KEdit.SelStart;
        If CheckDelete(Tempstr, Cursor) Then
        Begin
            Delete(Tempstr, Cursor, 1);
            KEdit.Text := Tempstr;
            KEdit.SelStart := Cursor - 1;
            SaveMMButton.Enabled := False;
            ResultLabel.Caption := '';
        End;
        Key := 0;
    End;

    If Key = VK_DOWN Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);
End;

Procedure TMainForm.KEditKeyPress(Sender: TObject; Var Key: Char);
Begin
    If (Key = '4') And (KEdit.SelStart = 0) And (Length(KEdit.Text) >= 2) And (KEdit.Text[2] <> '0') Then
        Key := #0;

    If (KEdit.Text = '4') And (Key <> '0') Then
        Key := #0;

    If (Key = '0') And (KEdit.SelStart = 0) Then
        Key := #0;

    If (Kedit.SelStart = 0) And Not(Key In ['0' .. '4']) Then
        Key := #0;

    If (KEdit.SelStart <> 0) And Not(Key In ['0' .. '9']) Then
        Key := #0;

    If (KEdit.SelText <> '') And (Key <> #0) Then
        KEdit.ClearSelection;

    If Length(KEdit.Text) >= 2 Then
        Key := #0;

    If Key <> #0 Then
    Begin
        SaveMMButton.Enabled := False;
        ResultLabel.Caption := '';
    End;
End;

Procedure TMainForm.St1EditChange(Sender: TObject);
Begin
    ButtonStat();
End;

Procedure TMainForm.St1EditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := False;
End;

Procedure TMainForm.St1EditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    If (((Shift = [SsCtrl]) And (Key = Ord('V'))) Or ((Shift = [SsShift]) And (Key = VK_INSERT))) And
        (Length(Clipboard.AsText + St1Edit.Text) >= 40) Then
        Clipboard.AsText := '';

    if (Key = VK_BACK) or (Key = VK_DELETE) then
    begin
        SaveMMButton.Enabled := false;
        ResultLabel.Caption := '';
    end;
        
    If Key = VK_DOWN Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);
End;

Procedure TMainForm.St1EditKeyPress(Sender: TObject; Var Key: Char);
Begin
    If (Length(St1Edit.Text) >= 40) And (St1Edit.SelText = '') Then
        Key := #0
    Else
    Begin
        SaveMMButton.Enabled := False;
        ResultLabel.Caption := '';
    End;
End;

Procedure TMainForm.St2EditChange(Sender: TObject);
Begin
    ButtonStat();
End;

Procedure TMainForm.St2EditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := False;
End;

Procedure TMainForm.St2EditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    If (((Shift = [SsCtrl]) And (Key = Ord('V'))) Or ((Shift = [SsShift]) And (Key = VK_INSERT))) And
        (Length(Clipboard.AsText + St2Edit.Text) >= 40) Then
        Clipboard.AsText := '';
        
    if (Key = VK_BACK) or (Key = VK_DELETE) then
    begin
        SaveMMButton.Enabled := false;
        ResultLabel.Caption := '';
    end;
    
    If (Key = VK_DOWN) And (Key = VK_INSERT) Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);
End;

Procedure TMainForm.St2EditKeyPress(Sender: TObject; Var Key: Char);
Begin
    If (Length(St2Edit.Text) >= 40) And (St2Edit.SelText = '') Then
        Key := #0
    Else
    Begin
        SaveMMButton.Enabled := False;
        ResultLabel.Caption := '';
    End;
End;

Procedure TMainForm.FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
Var
    Key: Integer;
Begin
    Key := Application.Messagebox('Вы уверены, что хотите закрыть набор записей?', 'Выход', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);
    If Key = ID_NO Then
        CanClose := False
    Else
    Begin
        If DataSaved Or (ResultLabel.Caption = '') Then
        Begin
            If Key = ID_NO Then
                CanClose := False
        End
        Else
            If ResultLabel.Caption <> '' Then
            Begin
                Key := Application.Messagebox('Вы не сохранили результат. Хотите сделать это?', 'Сохранение',
                    MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);
                If Key = ID_YES Then
                    SaveMMButton.Click;
            End;
    End;
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

Procedure InputInFile(IsCorrect: Boolean; FileName: String);
Var
    MyFile: TextFile;
Begin
    If IsCorrect Then
    Begin
        DataSaved := True;
        AssignFile(MyFile, FileName, CP_UTF8);
        ReWrite(MyFile);
        Write(MyFile, MainForm.ResultLabel.Caption);
        Close(MyFile);
    End;
End;

Function TryRead(Var TestFile: TextFile): Boolean;
Var
    BufferInt: Integer;
    BufferStr1, BufferStr2: String;
    ReadStatus: Boolean;
Begin
    ReadStatus := True;
    Readln(TestFile, BufferInt);
    If (BufferInt < 1) Or (BufferInt > 40) Then
        ReadStatus := False
    Else
    Begin
        Readln(TestFile, BufferStr1);
        Readln(TestFile, BufferStr2);
        If (Length(BufferStr1) > 40) And (Length(BufferStr2) > 40) Then
            ReadStatus := False;
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

Procedure ReadFromFile(IsCorrect: Boolean; Error: Integer; FileWay: String);
Var
    MyFile: TextFile;
    BufferInt: Integer;
    BufferStr: String;
Begin
    If Not(IsCorrect) And (Error = 0) Then
        MessageBox(0, 'Данные в выбранном файле не корректны!', 'Ошибка', MB_ICONERROR)
    Else
    Begin
        AssignFile(MyFile, FileWay);
        Reset(MyFile);
        Readln(MyFile, BufferInt);
        MainForm.KEdit.Text := IntToStr(BufferInt);
        Readln(MyFile, BufferStr);
        MainForm.St1Edit.Text := BufferStr;
        Readln(MyFile, BufferStr);
        MainForm.St2Edit.Text := BufferStr;
        Close(MyFile);
    End;
End;

Procedure TMainForm.OpenMMButtonClick(Sender: TObject);
Var
    IsCorrect: Boolean;
Begin
    Repeat
        If OpenDialog.Execute() Then
        Begin
            IsCorrect := IsCanRead(OpenDialog.FileName);
            ReadFromFile(IsCorrect, Error, OpenDialog.FileName);
        End
        Else
            IsCorrect := True;
        Error := 0;
    Until IsCorrect;
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

Procedure TMainForm.InstractionMMButtonClick(Sender: TObject);
Begin
    Instraction.ShowModal;
End;

Procedure TMainForm.AboutEditorMMButtonClick(Sender: TObject);
Begin
    AboutEditor.ShowModal;
End;

End.
