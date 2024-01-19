Unit TGoodEdit;

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
    Vcl.Menus,
    Vcl.Mask,
    Vcl.ExtCtrls;

Type
    TGoodEdit = Class(TEdit)
    Private
        { Private declarations }
    Protected
        { Protected declarations }
    Public
        { Public declarations }
        Procedure WMPaste(Var Msg: TMessage); Message WM_PASTE;
    Published
        { Published declarations }
    End;

Procedure Register;

Implementation

Procedure TGoodEdit.WMPaste(Var Msg: TMessage);
Begin
    If Clipboard.HasFormat(CF_TEXT) Then
    Begin
        Try
            If Length(Clipboard.AsText) > 40 Then
            Begin
                Raise Exception.Create('Слишком длинная строка!');
            End;
        Except
            On E: Exception Do
            Begin
                MessageBox(0, PWideChar(E.Message), 'Ошибка', MB_ICONERROR);
                Exit;
            End;
        End;
    End;
    Inherited;
End;

Procedure Register;
Begin
    RegisterComponents('Samples', [TGoodEdit]);
End;

End.
