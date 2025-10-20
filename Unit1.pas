unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IdHTTP, IdSSLOpenSSL;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    Memo1: TMemo;
    Button2: TButton;
    Label1: TLabel;
    edtPath: TEdit;
    edtSenha: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    FCertPassword: string;
    procedure __GetPassword(var APassword: string);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  HTTP: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  Resp: TStringStream;
  CertFile, CertKey: string;

begin
  // Caminhos e senha do certificado A1

  HTTP := TIdHTTP.Create(nil);
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  Resp := TStringStream.Create;


  try
    // Configura o SSL
    SSL.SSLOptions.Method := sslvTLSv1_2;
    SSL.SSLOptions.Mode := sslmClient; //sslmUnassigned;
    SSL.SSLOptions.VerifyMode := [];
    SSL.SSLOptions.VerifyDepth := 0;

    // Para PFX, use a função de importação via store:
    SSL.SSLOptions.CertFile := edtPath.Text;
    SSL.SSLOptions.KeyFile := edtPath.Text;
    SSL.SSLOptions.RootCertFile := '';
    SSL.OnGetPassword := __GetPassword;
    //SSL.LoadCertFromPFX(CertFile, CertPassword);

    // Liga o SSL ao HTTP
    HTTP.IOHandler := SSL;
    HTTP.Request.ContentType := 'application/json';
    HTTP.Request.Accept := 'application/json';
    HTTP.Request.UserAgent := 'Delphi-Indy Client';

    // Faz a requisição GET (ou POST, conforme necessário)
    HTTP.Get('https://cff.svrs.rs.gov.br/api/v1/consultas/classTrib', Resp);

    // Exibe a resposta JSON
    Memo1.Lines.Clear;
    Memo1.Lines.Add('Consulta realizada com sucesso!');
    Memo1.Lines.Add('');
    Memo1.Lines.Add('--- Retorno JSON ---');
    Memo1.Lines.Add(StringOf(TEncoding.Convert(TEncoding.UTF8, TEncoding.Ansi, Resp.Bytes)));

  except
    on E: Exception do
    begin
      Memo1.Lines.Add('Erro ao consultar o endpoint:');
      Memo1.Lines.Add(E.Message);
    end;
  end;

  Resp.Free;
  SSL.Free;
  HTTP.Free;



end;

procedure TForm1.__GetPassword(var APassword: string);
begin
  APassword := edtSenha.Text;
end;

end.
