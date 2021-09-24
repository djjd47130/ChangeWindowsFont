object frmMain: TfrmMain
  Left = 0
  Top = 0
  Cursor = crHandPoint
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Change Windows Font'
  ClientHeight = 390
  ClientWidth = 884
  Color = clWhite
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object pBottom: TPanel
    Left = 0
    Top = 353
    Width = 884
    Height = 37
    Align = alBottom
    TabOrder = 0
    object btnApply: TBitBtn
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 105
      Height = 29
      Cursor = crHandPoint
      Hint = 'Apply the selected font'
      Align = alLeft
      Caption = 'Apply'
      ModalResult = 1
      NumGlyphs = 2
      TabOrder = 0
      OnClick = btnApplyClick
    end
    object btnReset: TBitBtn
      AlignWithMargins = True
      Left = 115
      Top = 4
      Width = 98
      Height = 29
      Cursor = crHandPoint
      Hint = 'Reset back to default font'
      Align = alLeft
      Caption = 'Reset'
      ModalResult = 2
      NumGlyphs = 2
      TabOrder = 1
      OnClick = btnResetClick
    end
  end
  object pMain: TPanel
    Left = 0
    Top = 0
    Width = 884
    Height = 303
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    TabOrder = 1
    object Splitter1: TSplitter
      Left = 252
      Top = 0
      Width = 5
      Height = 303
      Beveled = True
      ResizeStyle = rsUpdate
      ExplicitLeft = 209
      ExplicitHeight = 297
    end
    object lstFonts: TListBox
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 246
      Height = 297
      Hint = 'Select the new font to apply'
      Align = alLeft
      ItemHeight = 13
      TabOrder = 0
      OnClick = lstFontsClick
    end
    object pSample: TGroupBox
      AlignWithMargins = True
      Left = 299
      Top = 3
      Width = 582
      Height = 297
      Align = alRight
      Anchors = [akLeft, akTop, akRight, akBottom]
      Caption = 'Sample'
      Color = clWhite
      ParentBackground = False
      ParentColor = False
      TabOrder = 1
      object lblSample1: TLabel
        AlignWithMargins = True
        Left = 9
        Top = 22
        Width = 564
        Height = 59
        Margins.Left = 7
        Margins.Top = 7
        Margins.Right = 7
        Margins.Bottom = 7
        Align = alTop
        AutoSize = False
        Caption = 'The quick red fox jumped over the lazy brown dog'#39's head.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        ExplicitWidth = 519
      end
      object lblSample2: TLabel
        AlignWithMargins = True
        Left = 9
        Top = 95
        Width = 564
        Height = 88
        Margins.Left = 7
        Margins.Top = 7
        Margins.Right = 7
        Margins.Bottom = 7
        Align = alTop
        AutoSize = False
        Caption = 'The quick red fox jumped over the lazy brown dog'#39's head.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        ExplicitTop = 224
        ExplicitWidth = 519
      end
      object lblSample3: TLabel
        AlignWithMargins = True
        Left = 9
        Top = 197
        Width = 564
        Height = 88
        Margins.Left = 7
        Margins.Top = 7
        Margins.Right = 7
        Margins.Bottom = 7
        Align = alTop
        AutoSize = False
        Caption = 'The quick red fox jumped over the lazy brown dog'#39's head.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -21
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        ExplicitLeft = 17
        ExplicitTop = 263
        ExplicitWidth = 519
      end
    end
  end
end
