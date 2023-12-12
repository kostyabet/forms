unit InstractionUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TInstraction = class(TForm)
    InstractionLabel: TLabel;
    
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Instraction: TInstraction;

implementation

{$R *.dfm}

procedure TInstraction.FormCreate(Sender: TObject);
begin
    InstractionLabel.Caption := 'Инструкция:' + 
    #13#10 + '1. Точность EPS должна быть в пределах (0,1; 0,000001];' + 
    #13#10 + '2. X - число в пределах (-1000000; 1000000);' +
    #13#10 + '3. EPS нужно писать через '',''.' + #13#10 +
    #13#10 + 'Дополнительные инструкции для файла:' +
    #13#10 + '1. EPS пишется первым;' +
    #13#10 + '2. После EPS пишется Х.';
end;

end.
