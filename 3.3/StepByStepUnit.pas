Unit StepByStepUnit;

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
    Vcl.Grids;

Type
    TStepByStep = Class(TForm)
        DetailGrid: TStringGrid;
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    StepByStep: TStepByStep;

Implementation

{$R *.dfm}

End.
