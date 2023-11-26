object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1041#1077#1090#1077#1085#1103' '#1050#1086#1085#1089#1090#1072#1085#1090#1080#1085' 351005 '#1083#1072#1073'. 1.1'
  ClientHeight = 199
  ClientWidth = 366
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MainMenu1
  Position = poScreenCenter
  OnClick = FormClick
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  TextHeight = 15
  object Label1: TLabel
    Left = 24
    Top = 8
    Width = 31
    Height = 15
    Align = alCustom
    Caption = 'label1'
  end
  object Label2: TLabel
    Left = 24
    Top = 59
    Width = 48
    Height = 15
    Caption = #1042#1072#1096' '#1087#1086#1083
  end
  object Label3: TLabel
    Left = 175
    Top = 59
    Width = 69
    Height = 15
    Caption = #1042#1072#1096' '#1074#1086#1079#1088#1072#1089#1090
  end
  object Label4: TLabel
    Left = 24
    Top = 159
    Width = 34
    Height = 15
    Caption = 'Label4'
  end
  object Button: TButton
    Left = 24
    Top = 128
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = ButtonClick
  end
  object Button1: TEdit
    Left = 24
    Top = 80
    Width = 121
    Height = 23
    TabOrder = 1
    Text = 'Edit1'
    OnEnter = Button1Enter
    OnExit = Button1Exit
    OnKeyDown = Button1KeyDown
    OnKeyPress = Button1KeyPress
  end
  object Button2: TEdit
    Left = 175
    Top = 80
    Width = 121
    Height = 23
    TabOrder = 2
    Text = 'Edit2'
    OnChange = Button2Change
    OnEnter = Button2Enter
    OnExit = Button2Exit
    OnKeyDown = Button2KeyDown
    OnKeyPress = Button2KeyPress
  end
  object MainMenu1: TMainMenu
    Left = 636
    Top = 65520
    object N1: TMenuItem
      Caption = #1060#1072#1081#1083
      object N4: TMenuItem
        Caption = #1054#1090#1082#1088#1099#1090#1100
        ShortCut = 16463
        OnClick = N4Click
      end
      object N5: TMenuItem
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
        ShortCut = 16467
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object N7: TMenuItem
        Caption = #1042#1099#1081#1090#1080
        OnClick = N7Click
      end
    end
    object N2: TMenuItem
      Caption = #1048#1085#1089#1090#1088#1091#1082#1094#1080#1103
      OnClick = N2Click
    end
    object N3: TMenuItem
      Caption = #1054' '#1088#1072#1079#1088#1072#1073#1086#1090#1095#1080#1082#1077
      OnClick = N3Click
    end
  end
  object SaveDialog1: TSaveDialog
    Left = 248
    Top = 128
  end
  object OpenDialog1: TOpenDialog
    Left = 168
    Top = 128
  end
end
