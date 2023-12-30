Unit EditorUnit;

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

        Procedure FormCreate(Sender: TObject);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    AboutEditor: TAboutEditor;

Implementation

{$R *.dfm}

Procedure TAboutEditor.FormCreate(Sender: TObject);
Begin
    AboutEditorLabel.Caption := 'Выполнил студент группы 351005 Бетеня Констатин.';
End;

End.
