object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Monocraft Framework Demo'
  ClientHeight = 89
  ClientWidth = 280
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 11
    Width = 30
    Height = 13
    Caption = #1051#1086#1075#1080#1085
  end
  object Label2: TLabel
    Left = 8
    Top = 35
    Width = 37
    Height = 13
    Caption = #1055#1072#1088#1086#1083#1100
  end
  object Label3: TLabel
    Left = 8
    Top = 66
    Width = 37
    Height = 13
    Caption = #1055#1072#1084#1103#1090#1100
  end
  object Edit1: TEdit
    Left = 72
    Top = 8
    Width = 121
    Height = 21
    TabOrder = 0
    Text = 'test'
  end
  object Edit2: TEdit
    Left = 72
    Top = 32
    Width = 121
    Height = 21
    PasswordChar = '*'
    TabOrder = 1
    Text = 'test'
  end
  object Button1: TButton
    Left = 199
    Top = 8
    Width = 75
    Height = 45
    Caption = #1048#1075#1088#1072#1090#1100
    TabOrder = 2
    OnClick = Button1Click
  end
  object Edit3: TEdit
    Left = 72
    Top = 63
    Width = 90
    Height = 21
    NumbersOnly = True
    TabOrder = 3
    Text = '512'
  end
  object Edit4: TEdit
    Left = 168
    Top = 63
    Width = 108
    Height = 21
    NumbersOnly = True
    TabOrder = 4
    Text = '4096'
  end
end
