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
    InstractionLabel.Caption := 'Инструкции:' + 
    #13#10 + '1. K - строго натуральное число;' +
    #13#10 + '2. К находится в пределах от [1;10000).' + 
    #13#10 + '3. После того, как вы ввели К, нажимайте кнопку K.' + #13#10 +
    #13#10 + 'Дополнительные инструкции для файла:' + 
    #13#10 + '1. Файл должен быть формата *.txt.';
end;

end.
