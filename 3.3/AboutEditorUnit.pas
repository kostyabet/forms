unit AboutEditorUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TAboutEditor = class(TForm)
    AboutEditorLabel: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutEditor: TAboutEditor;

implementation

{$R *.dfm}

end.
