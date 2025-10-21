object UIPrincipal: TUIPrincipal
  Left = 0
  Top = 0
  Margins.Left = 4
  Margins.Top = 4
  Margins.Right = 4
  Margins.Bottom = 4
  Caption = 'SACFiscal - Exemplo de consumo API Conformidade F'#225'cil'
  ClientHeight = 960
  ClientWidth = 1199
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 120
  DesignSize = (
    1199
    960)
  TextHeight = 20
  object lblTitulo: TLabel
    Left = 470
    Top = 10
    Width = 174
    Height = 20
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'WWW.SACFISCAL.COM.BR'
  end
  object lblPath: TLabel
    Left = 20
    Top = 46
    Width = 147
    Height = 20
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Path do certificado A1'
  end
  object lblSenha: TLabel
    Left = 20
    Top = 113
    Width = 159
    Height = 20
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Senha do certificado A1'
  end
  object lblTipoHttp: TLabel
    Left = 20
    Top = 180
    Width = 140
    Height = 20
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Tipo de Cliente HTTP'
  end
  object bConsultar: TButton
    Left = 910
    Top = 207
    Width = 135
    Height = 31
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Consultar API'
    TabOrder = 0
    OnClick = bConsultarClick
  end
  object mResponse: TMemo
    Left = 20
    Top = 250
    Width = 1161
    Height = 691
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Consolas'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object edtPath: TEdit
    Left = 20
    Top = 73
    Width = 851
    Height = 28
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    TabOrder = 2
  end
  object edtSenha: TEdit
    Left = 20
    Top = 140
    Width = 851
    Height = 28
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    PasswordChar = '*'
    TabOrder = 3
  end
  object cmbClientType: TComboBox
    Left = 20
    Top = 207
    Width = 851
    Height = 28
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Style = csDropDownList
    TabOrder = 4
  end
end
