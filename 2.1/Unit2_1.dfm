object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1041#1077#1090#1077#1085#1103' '#1050'.'#1057'. 351005 '#1083#1072#1073'. 2.1'
  ClientHeight = 219
  ClientWidth = 370
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
  TextHeight = 15
  object Label1: TLabel
    Left = 8
    Top = 0
    Width = 349
    Height = 30
    Caption = 
      #1055#1088#1086#1075#1088#1072#1084#1084#1072' '#1085#1072#1093#1086#1076#1080#1090' '#1087#1083#1086#1097#1072#1076#1100' '#1084#1085#1086#1075#1086#1091#1075#1086#1083#1100#1085#1080#1082#1072' '#1087#1086' '#1079#1072#1076#1072#1085#1085#1099#1084' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083 +
      #1077#1084' '#1074#1077#1088#1096#1080#1085#1072#1084'.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
    OnClick = Label1Click
  end
  object Label2: TLabel
    Left = 8
    Top = 36
    Width = 265
    Height = 15
    Caption = #1042#1074#1077#1076#1080#1090#1077' '#1082#1086#1083#1083#1080#1095#1077#1089#1090#1074#1086' '#1074#1077#1088#1096#1080#1085' '#1084#1085#1086#1075#1086#1091#1075#1086#1083#1100#1085#1080#1082#1072': '
    WordWrap = True
    OnClick = Label2Click
  end
  object Label3: TLabel
    Left = 8
    Top = 199
    Width = 312
    Height = 15
    Caption = #1055#1083#1086#1097#1072#1076#1100' '#1084#1085#1086#1075#1086#1091#1075#1086#1083#1100#1085#1080#1082#1072' '#1073#1077#1079' '#1089#1072#1084#1086#1087#1077#1088#1077#1089#1077#1095#1077#1085#1080#1081' '#1088#1072#1074#1085#1072': '
    WordWrap = True
  end
  object Edit1: TEdit
    Left = 279
    Top = 36
    Width = 83
    Height = 23
    TabOrder = 0
    Text = 'Edit1'
    OnChange = Edit1Change
    OnClick = Edit1Click
    OnContextPopup = Edit1ContextPopup
    OnEnter = Edit1Enter
    OnExit = Edit1Exit
    OnKeyDown = Edit1KeyDown
    OnKeyPress = Edit1KeyPress
  end
  object Button1: TButton
    Left = 240
    Top = 65
    Width = 122
    Height = 40
    Caption = #1047#1072#1076#1072#1090#1100' '#1074#1077#1088#1096#1080#1085#1099' '#1084#1085#1086#1075#1086#1091#1075#1086#1083#1100#1085#1080#1082#1072
    TabOrder = 1
    WordWrap = True
    OnClick = Button1Click
  end
  object StringGrid1: TStringGrid
    Left = 8
    Top = 65
    Width = 217
    Height = 128
    ScrollBars = ssVertical
    TabOrder = 2
    OnKeyDown = StringGrid1KeyDown
    OnKeyPress = StringGrid1KeyPress
    OnSetEditText = StringGrid1SetEditText
  end
  object Button2: TButton
    Left = 239
    Top = 151
    Width = 123
    Height = 42
    Caption = #1053#1072#1081#1090#1080' '#1087#1083#1086#1097#1072#1076#1100' '#1084#1085#1086#1075#1086#1091#1075#1086#1083#1100#1085#1080#1082#1072
    TabOrder = 3
    WordWrap = True
  end
  object MainMenu1: TMainMenu
    Left = 288
    Top = 104
    object N1: TMenuItem
      Caption = #1060#1072#1081#1083
      object N2: TMenuItem
        Caption = #1054#1090#1082#1088#1099#1090#1100
        ShortCut = 16463
      end
      object N3: TMenuItem
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
        ShortCut = 16467
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object N5: TMenuItem
        Caption = #1042#1099#1081#1090#1080
      end
    end
    object N6: TMenuItem
      Caption = #1048#1085#1089#1090#1088#1091#1082#1094#1080#1103
    end
    object N7: TMenuItem
      Caption = #1054' '#1088#1072#1079#1088#1072#1073#1086#1090#1095#1080#1082#1077
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = '|*.txt'
    Left = 320
    Top = 104
  end
  object SaveDialog1: TSaveDialog
    Filter = '|*.txt'
    Left = 256
    Top = 104
  end
end
