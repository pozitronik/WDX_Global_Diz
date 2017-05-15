object Form2: TForm2
  Left = 326
  Top = 214
  BorderIcons = [biSystemMenu]
  BorderStyle = bsToolWindow
  Caption = 'Plugin settings'
  ClientHeight = 300
  ClientWidth = 433
  Color = clBtnFace
  DefaultMonitor = dmMainForm
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Status: TStatusBar
    Left = 0
    Top = 281
    Width = 433
    Height = 19
    Panels = <
      item
        Text = 'IniFileName:'
        Width = 50
      end>
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 433
    Height = 49
    Caption = 'Folder with description files (leave blank for current)'
    TabOrder = 1
    object Foldername: TEdit
      Left = 8
      Top = 16
      Width = 353
      Height = 21
      TabOrder = 0
      OnKeyDown = FoldernameKeyDown
    end
    object Button1: TButton
      Left = 368
      Top = 16
      Width = 57
      Height = 22
      Caption = '&Select'
      TabOrder = 1
      OnClick = Button1Click
      OnKeyDown = FoldernameKeyDown
    end
  end
  object RefCh: TCheckBox
    Left = 8
    Top = 56
    Width = 249
    Height = 17
    Caption = 'Refresh TC panels after program execution'
    TabOrder = 2
    OnKeyDown = FoldernameKeyDown
  end
  object ChCh: TCheckBox
    Left = 8
    Top = 80
    Width = 273
    Height = 17
    Caption = 'Change group confirmation dialog'
    TabOrder = 3
    OnKeyDown = FoldernameKeyDown
  end
  object GroupBox3: TGroupBox
    Left = 0
    Top = 104
    Width = 433
    Height = 177
    Caption = 'File context menu item'
    TabOrder = 4
    object groupbox: TComboBox
      Left = 8
      Top = 40
      Width = 417
      Height = 21
      ItemHeight = 13
      TabOrder = 0
      OnKeyDown = FoldernameKeyDown
    end
    object RadioButton1: TRadioButton
      Left = 8
      Top = 16
      Width = 153
      Height = 17
      Caption = 'Add selected file to group'
      Checked = True
      TabOrder = 1
      TabStop = True
      OnClick = RadioButton1Click
      OnKeyDown = FoldernameKeyDown
    end
    object RadioButton2: TRadioButton
      Left = 160
      Top = 16
      Width = 177
      Height = 17
      Caption = 'Add selected file to user column'
      TabOrder = 2
      OnClick = RadioButton2Click
      OnKeyDown = FoldernameKeyDown
    end
    object RadioButton3: TRadioButton
      Left = 344
      Top = 16
      Width = 81
      Height = 17
      Caption = 'Show GUI'
      TabOrder = 3
      OnClick = RadioButton3Click
      OnKeyDown = FoldernameKeyDown
    end
    object GroupBox4: TGroupBox
      Left = 9
      Top = 72
      Width = 416
      Height = 49
      Caption = 'Description for selected file (leave blank for none)'
      TabOrder = 4
      object DIZT: TEdit
        Left = 8
        Top = 18
        Width = 401
        Height = 21
        TabOrder = 0
        OnKeyDown = FoldernameKeyDown
      end
    end
    object GroupBox5: TGroupBox
      Left = 8
      Top = 120
      Width = 417
      Height = 49
      Caption = 'Menu item name'
      TabOrder = 5
      object Edit2: TEdit
        Left = 8
        Top = 18
        Width = 321
        Height = 21
        TabOrder = 0
        Text = 'Add_diz execution'
        OnChange = Edit2Change
        OnKeyDown = FoldernameKeyDown
      end
      object Add: TButton
        Left = 336
        Top = 16
        Width = 73
        Height = 25
        Caption = '&Set'
        TabOrder = 1
        OnClick = AddClick
        OnKeyDown = FoldernameKeyDown
      end
    end
  end
  object Button2: TButton
    Left = 352
    Top = 56
    Width = 75
    Height = 25
    Caption = '&OK'
    TabOrder = 5
    OnClick = Button2Click
    OnKeyDown = FoldernameKeyDown
  end
  object Button3: TButton
    Left = 270
    Top = 56
    Width = 75
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 6
    OnClick = Button3Click
    OnKeyDown = FoldernameKeyDown
  end
end
