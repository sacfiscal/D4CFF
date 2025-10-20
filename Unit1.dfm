object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'SACFiscal - Exemplo de consumo API Conformidade F'#225'cil'
  ClientHeight = 768
  ClientWidth = 959
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  DesignSize = (
    959
    768)
  TextHeight = 15
  object Label1: TLabel
    Left = 376
    Top = 8
    Width = 143
    Height = 15
    Caption = 'WWW.SACFISCAL.COM.BR'
  end
  object Label2: TLabel
    Left = 16
    Top = 61
    Width = 117
    Height = 15
    Caption = 'Path do certificado A1'
  end
  object Label3: TLabel
    Left = 16
    Top = 114
    Width = 125
    Height = 15
    Caption = 'Senha do certificado A1'
  end
  object Edit1: TEdit
    Left = 16
    Top = 29
    Width = 681
    Height = 23
    TabOrder = 0
    Text = 'https://cff.svrs.rs.gov.br/api/v1/consultas/classTrib'
  end
  object Button1: TButton
    Left = 728
    Top = 134
    Width = 75
    Height = 25
    Caption = 'Consultar'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 16
    Top = 192
    Width = 929
    Height = 561
    Anchors = [akLeft, akTop, akRight, akBottom]
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object Button2: TButton
    Left = 840
    Top = 134
    Width = 75
    Height = 25
    Caption = 'Limpar'
    TabOrder = 3
  end
  object edtPath: TEdit
    Left = 16
    Top = 82
    Width = 681
    Height = 23
    TabOrder = 4
  end
  object edtSenha: TEdit
    Left = 16
    Top = 135
    Width = 681
    Height = 23
    TabOrder = 5
  end
end
