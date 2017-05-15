object Form1: TForm1
  Left = 249
  Top = -10000
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsToolWindow
  ClientHeight = 67
  ClientWidth = 614
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 1
    Top = 0
    Width = 616
    Height = 16
    AutoSize = False
    Caption = 'Set description for'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Button1: TButton
    Left = 488
    Top = 45
    Width = 62
    Height = 21
    Caption = 'OK'
    TabOrder = 5
    OnClick = Button1Click
    OnKeyDown = Edit1KeyDown
  end
  object Edit1: TEdit
    Left = 2
    Top = 17
    Width = 611
    Height = 21
    TabOrder = 0
    OnKeyDown = Edit1KeyDown
  end
  object Button2: TButton
    Left = 424
    Top = 45
    Width = 62
    Height = 21
    Caption = 'Cancel'
    ModalResult = 3
    TabOrder = 4
    OnClick = Button2Click
    OnKeyDown = Button2KeyDown
  end
  object groups: TComboBox
    Left = 190
    Top = 45
    Width = 227
    Height = 21
    ItemHeight = 13
    TabOrder = 3
    OnKeyDown = Edit1KeyDown
    Items.Strings = (
      'NONE')
  end
  object RBGroup: TRadioButton
    Left = 2
    Top = 45
    Width = 68
    Height = 17
    Caption = 'Group'
    Checked = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    TabStop = True
    OnClick = RBGroupClick
    OnKeyDown = Edit1KeyDown
  end
  object RBUser: TRadioButton
    Left = 72
    Top = 45
    Width = 113
    Height = 17
    Caption = 'User Column'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = RBUserClick
    OnKeyDown = Edit1KeyDown
  end
  object SettingsBtn: TButton
    Left = 552
    Top = 45
    Width = 62
    Height = 21
    Caption = 'Options'
    TabOrder = 6
    OnClick = SettingsBtnClick
    OnKeyDown = Edit1KeyDown
  end
  object OpenFileD: TOpenDialog
    Title = 'Open file'
    Left = 584
    Top = 8
  end
  object XPManifest1: TXPManifest
    Left = 512
  end
end
