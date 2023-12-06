unit Unit1_4_1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm2 = class(TForm)
    Label1: TLabel;
    
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.FormCreate(Sender: TObject);
begin
    label1.caption := 'Инструкции:' + 
    #13#10 + '1. Введите размер массива, он находится в' + 
    #13#10 + '   пределах [0, 99] и является целым числом;' +
    #13#10 + '2. Затем нажимайте кнопку ''Создать массив''' +
    #13#10 + '3. Вводите числа в ваш массив, числа должны' +
    #13#10 + '   быть целыми и в пределах (-1000000;1000000);' +
    #13#10 + '4. Нажимайте кнопку расчитать.' + #13#10 +
    #13#10 + 'Дополнительные инструкции для файлов:' +
    #13#10 + '1. Первым идёт размер массива;' +
    #13#10 + '2. Затем идут все числа массива.' +
    #13#10 + 'Файл должен быть строго формата .txt!!!';
end;

end.
