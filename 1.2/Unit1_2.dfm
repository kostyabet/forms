object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1041#1077#1090#1077#1085#1103' '#1050#1086#1085#1089#1090#1072#1085#1090#1080#1085' 351005 '#1083#1072#1073'1.2'
  ClientHeight = 221
  ClientWidth = 379
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MainMenu1
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  TextHeight = 15
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 34
    Height = 15
    Caption = 'Label1'
  end
  object ListBox1: TListBox
    Left = 16
    Top = 61
    Width = 121
    Height = 97
    ItemHeight = 15
    TabOrder = 0
  end
  object MainMenu1: TMainMenu
    Left = 152
    Top = 8
    object N1: TMenuItem
      Caption = #1060#1072#1081#1083
      object N4: TMenuItem
        Caption = #1054#1090#1082#1088#1099#1090#1100
        ShortCut = 16463
      end
      object N5: TMenuItem
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
        ShortCut = 16467
        OnClick = N5Click
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
    Filter = '|*.txt'
    Left = 72
    Top = 8
  end
end
