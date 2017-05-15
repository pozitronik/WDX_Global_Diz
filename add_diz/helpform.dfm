object Form3: TForm3
  Left = 264
  Top = 201
  AutoSize = True
  BorderIcons = [biSystemMenu, biMaximize]
  BorderStyle = bsToolWindow
  Caption = 'Plugin help'
  ClientHeight = 306
  ClientWidth = 641
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 2
    Top = 0
    Width = 639
    Height = 17
    AutoSize = False
    Caption = 'Plugin settings file:'
    WordWrap = True
  end
  object Label2: TLabel
    Left = 2
    Top = 24
    Width = 639
    Height = 17
    AutoSize = False
    Caption = 'Data files stored in'
  end
  object Label3: TLabel
    Left = 0
    Top = 48
    Width = 641
    Height = 16
    Alignment = taCenter
    AutoSize = False
    Caption = 'Command line parameters:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label7: TLabel
    Left = 2
    Top = 72
    Width = 311
    Height = 16
    AutoSize = False
    Caption = '/? - show that window'
    WordWrap = True
  end
  object Label8: TLabel
    Left = 2
    Top = 96
    Width = 311
    Height = 16
    AutoSize = False
    Caption = '/O - show options window'
    WordWrap = True
  end
  object Label9: TLabel
    Left = 2
    Top = 120
    Width = 311
    Height = 16
    AutoSize = False
    Caption = '/G or /GUI - run program in window mode'
    WordWrap = True
  end
  object Label10: TLabel
    Left = 2
    Top = 144
    Width = 311
    Height = 16
    AutoSize = False
    Caption = '/C or /CLEAR - clear database for dead entries'
    WordWrap = True
  end
  object Label11: TLabel
    Left = 320
    Top = 96
    Width = 313
    Height = 17
    AutoSize = False
    Caption = '/DIZ="File description" - add description for file.'
    WordWrap = True
  end
  object Label12: TLabel
    Left = 320
    Top = 120
    Width = 313
    Height = 16
    AutoSize = False
    Caption = '/GROUP="Group name" - add file to group'
    WordWrap = True
  end
  object Label13: TLabel
    Left = 320
    Top = 144
    Width = 313
    Height = 16
    AutoSize = False
    Caption = '/USER="User column name" - add file to user column'
    WordWrap = True
  end
  object Label14: TLabel
    Left = 320
    Top = 72
    Width = 313
    Height = 16
    AutoSize = False
    Caption = '/D or /DELETE delete file from group or user column'
    WordWrap = True
  end
  object Label15: TLabel
    Left = 2
    Top = 208
    Width = 311
    Height = 16
    AutoSize = False
    Caption = '/FILE=c:\some\file.txt - specify file for operation'
    WordWrap = True
  end
  object Label16: TLabel
    Left = 320
    Top = 208
    Width = 313
    Height = 16
    AutoSize = False
    Caption = '/LIST=c:\some\file.tmp - specify list-file for operation'
    WordWrap = True
  end
  object Label17: TLabel
    Left = 2
    Top = 168
    Width = 611
    Height = 32
    Caption = 
      'File or listfile can be recognized automatically. But if you hav' +
      'e troubles with recognition - following specials options can be ' +
      'used:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 232
    Width = 641
    Height = 74
    Caption = 'About'
    TabOrder = 0
    object Label4: TLabel
      Left = 320
      Top = 48
      Width = 228
      Height = 16
      Caption = 'add_diz '#169' 2004-2005 Pavel Dubrovsky'
    end
    object Label5: TLabel
      Left = 8
      Top = 16
      Width = 427
      Height = 16
      Caption = 
        'Global Description WDX plugin for Total Commander filemanager V ' +
        '0.8b'
    end
    object Label6: TLabel
      Left = 8
      Top = 40
      Width = 259
      Height = 16
      Caption = 'For more information, see readme file'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Button1: TButton
      Left = 560
      Top = 40
      Width = 75
      Height = 25
      Caption = 'OK'
      TabOrder = 0
      OnClick = Button1Click
      OnKeyDown = Button1KeyDown
    end
  end
end
