object FormPrincipal: TFormPrincipal
  Left = 0
  Top = 0
  Caption = 'FormPrincipal'
  ClientHeight = 811
  ClientWidth = 1778
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    1778
    811)
  TextHeight = 15
  object lblNovoToken: TLabel
    Left = 8
    Top = 24
    Width = 208
    Height = 15
    Caption = 'Adicionar novo Token para o Aut'#244'mato'
  end
  object lblAnalisar: TLabel
    Left = 299
    Top = 24
    Width = 155
    Height = 15
    Caption = 'Digite o Token a ser analisado'
  end
  object shpVerde: TShape
    Left = 560
    Top = 336
    Width = 17
    Height = 17
    Brush.Color = clGreen
  end
  object lblLegendaValido: TLabel
    Left = 583
    Top = 338
    Width = 84
    Height = 15
    Caption = 'Caminho V'#225'lido'
  end
  object Shape1: TShape
    Left = 673
    Top = 336
    Width = 16
    Height = 17
    Brush.Color = clRed
  end
  object lblLegendaInvalido: TLabel
    Left = 695
    Top = 338
    Width = 94
    Height = 15
    Caption = 'Caminho Inv'#225'lido'
  end
  object lbl_LegendaParaAnalisar: TLabel
    Left = 299
    Top = 80
    Width = 165
    Height = 15
    Caption = 'Pressione ESPA'#199'O para analisar'
  end
  object edtNovoToken: TEdit
    Left = 8
    Top = 45
    Width = 208
    Height = 23
    TabOrder = 0
    OnKeyPress = edtNovoTokenKeyPress
  end
  object btnAdicionarToken: TButton
    Left = 8
    Top = 74
    Width = 104
    Height = 25
    Caption = 'Adicionar Token'
    TabOrder = 1
    OnClick = btnAdicionarTokenClick
  end
  object gbTokensReconhecidos: TGroupBox
    Left = 8
    Top = 128
    Width = 208
    Height = 225
    Caption = 'Tokens Reconhecidos'
    TabOrder = 2
    object lbTokensReconhecidos: TListBox
      Left = 0
      Top = 14
      Width = 208
      Height = 211
      ItemHeight = 15
      TabOrder = 0
    end
  end
  object edtAnalisarToken: TEdit
    Left = 299
    Top = 45
    Width = 185
    Height = 23
    TabOrder = 3
    OnChange = edtAnalisarTokenChange
    OnKeyPress = edtAnalisarTokenKeyPress
  end
  object gbHistorico: TGroupBox
    Left = 299
    Top = 128
    Width = 185
    Height = 225
    Caption = 'Hist'#243'rico de Tokens Analisados'
    TabOrder = 4
    object lbHistorico: TListBox
      Left = 0
      Top = 14
      Width = 185
      Height = 211
      ItemHeight = 15
      TabOrder = 0
    end
  end
  object sgMatrizTransicao: TStringGrid
    Left = 8
    Top = 376
    Width = 1761
    Height = 427
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 5
    OnDrawCell = sgMatrizTransicaoDrawCell
  end
  object pnlLegenda: TPanel
    Left = 560
    Top = 289
    Width = 229
    Height = 41
    Caption = 'Legenda'
    TabOrder = 6
  end
  object btn_Limpar: TButton
    Left = 560
    Top = 240
    Width = 75
    Height = 25
    Caption = 'Limpar'
    TabOrder = 7
    OnClick = btn_LimparClick
  end
end
