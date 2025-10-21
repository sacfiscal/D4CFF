unit UI.Principal;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  CFF.Interfaces,
  CFF.Certificate,
  CFF.Factory,
  CFF.ApiService;

type
  TUIPrincipal = class(TForm)
    mResponse: TMemo;
    bConsultar: TButton;
    lblTitulo: TLabel;
    edtPath: TEdit;
    edtSenha: TEdit;
    lblPath: TLabel;
    lblSenha: TLabel;
    cmbClientType: TComboBox;
    lblTipoHttp: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure bConsultarClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FApiService: TCFFApiService;
    procedure LoadAvailableClients;
    procedure ConfigureApiService(const AClientType: string);
    procedure DisplayResponse(const AResponse: THttpResponse);
    function ValidateInputs: Boolean;
  public
    { Public declarations }
  end;

var
  UIPrincipal: TUIPrincipal;

implementation

{$R *.dfm}

{ TForm1 }

procedure TUIPrincipal.FormCreate(Sender: TObject);
begin
  FApiService := nil;
  LoadAvailableClients;
  
  if cmbClientType.Items.Count > 0 then
    cmbClientType.ItemIndex := 0;
end;

procedure TUIPrincipal.FormDestroy(Sender: TObject);
begin
  if Assigned(FApiService) then
    FApiService.Free;
end;

procedure TUIPrincipal.LoadAvailableClients;
var
  Factory: IHttpClientFactory;
  Clients: TArray<string>;
  ClientName: string;
begin
  Factory := THttpClientFactory.Instance;
  Clients := Factory.GetAvailableClients;
  
  cmbClientType.Items.Clear;
  for ClientName in Clients do
    cmbClientType.Items.Add(ClientName);
end;

procedure TUIPrincipal.ConfigureApiService(const AClientType: string);
var
  Factory: IHttpClientFactory;
  HttpClient: IHttpClient;
  CertConfig: TCertificateConfig;
  CertProvider: ICertificateProvider;
  ApiConfig: TApiConfig;
begin
  if Assigned(FApiService) then
    FreeAndNil(FApiService);

  Factory := THttpClientFactory.Instance;
  HttpClient := Factory.CreateClient(AClientType);

  CertConfig := TCertificateConfig.Create(edtPath.Text, edtSenha.Text);
  CertProvider := TCertificateProvider.Create(CertConfig);
  HttpClient.SetCertificateProvider(CertProvider);

  ApiConfig := TApiConfig.Create('https://cff.svrs.rs.gov.br/api/v1');

  FApiService := TCFFApiService.Create(HttpClient, ApiConfig);
end;

function TUIPrincipal.ValidateInputs: Boolean;
begin
  Result := False;

  if Trim(edtPath.Text) = '' then
  begin
    ShowMessage('Por favor, informe o caminho do certificado.');
    edtPath.SetFocus;
    Exit;
  end;

  if not FileExists(edtPath.Text) then
  begin
    ShowMessage('Arquivo de certificado n?o encontrado.');
    edtPath.SetFocus;
    Exit;
  end;

  if Trim(edtSenha.Text) = '' then
  begin
    ShowMessage('Por favor, informe a senha do certificado.');
    edtSenha.SetFocus;
    Exit;
  end;

  if cmbClientType.ItemIndex < 0 then
  begin
    ShowMessage('Por favor, selecione o tipo de cliente HTTP.');
    cmbClientType.SetFocus;
    Exit;
  end;

  Result := True;
end;

procedure TUIPrincipal.bConsultarClick(Sender: TObject);
var
  Response: THttpResponse;
  ClientType: string;
begin
  if not ValidateInputs then
    Exit;

  mResponse.Lines.Clear;
  mResponse.Lines.Add('Iniciando consulta...');
  Application.ProcessMessages;

  try
    ClientType := cmbClientType.Text;

    ConfigureApiService(ClientType);

    mResponse.Lines.Add('Cliente HTTP: ' + ClientType);
    mResponse.Lines.Add('Executando requisi??o...');
    Application.ProcessMessages;

    Response := FApiService.ConsultarClassificacaoTributaria;


    DisplayResponse(Response);

  except
    on E: Exception do
    begin
      mResponse.Lines.Clear;
      mResponse.Lines.Add('=== ERRO ===');
      mResponse.Lines.Add('Erro ao processar requisi??o:');
      mResponse.Lines.Add(E.Message);
    end;
  end;
end;

procedure TUIPrincipal.DisplayResponse(const AResponse: THttpResponse);
begin
  mResponse.Lines.Clear;
  
  if AResponse.Success then
  begin
    mResponse.Lines.Add('=== SUCESSO ===');
    mResponse.Lines.Add('Status Code: ' + IntToStr(AResponse.StatusCode));
    mResponse.Lines.Add('Content-Type: ' + AResponse.ContentType);
    mResponse.Lines.Add('');
    mResponse.Lines.Add('=== RESPOSTA JSON ===');
    mResponse.Lines.Add(AResponse.Content);
  end
  else
  begin
    mResponse.Lines.Add('=== FALHA ===');
    mResponse.Lines.Add('Status Code: ' + IntToStr(AResponse.StatusCode));
    mResponse.Lines.Add('Erro: ' + AResponse.ErrorMessage);
    if AResponse.Content <> '' then
    begin
      mResponse.Lines.Add('');
      mResponse.Lines.Add('=== DETALHES ===');
      mResponse.Lines.Add(AResponse.Content);
    end;
  end;
end;

end.

