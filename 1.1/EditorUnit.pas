﻿unit EditorUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TAboutEditor = class(TForm)
    AboutEditor: TLabel;
    
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutEditor: TAboutEditor;

implementation

{$R *.dfm}

procedure TAboutEditor.FormCreate(Sender: TObject);
begin
    Label1.Caption := 'Выполнил студент группы 351005 Бетеня Констатин.';
end;

end.
