Unit AboutEditorUnit;

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
    Vcl.StdCtrls;

Type
    TAboutEditor = Class(TForm)
        AboutEditorLabel: TLabel;
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    AboutEditor: TAboutEditor;

Implementation

{$R *.dfm}

End.
