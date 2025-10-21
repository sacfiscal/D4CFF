unit CFF.ApiService;

interface

uses
  System.SysUtils,
  System.Classes,
  System.JSON,
  CFF.Interfaces;

type
  TApiConfig = class
  private
    FBaseURL: string;
    FTimeout: Integer;
  public
    constructor Create(const ABaseURL: string = 'https://cff.svrs.rs.gov.br/api/v1');
    property BaseURL: string read FBaseURL write FBaseURL;
    property Timeout: Integer read FTimeout write FTimeout;
  end;

  TCFFApiService = class
  private
    FHttpClient: IHttpClient;
    FConfig: TApiConfig;
    function BuildURL(const AEndpoint: string): string;
    function CreateRequest(const AEndpoint: string; AMethod: THttpMethod = hmGet; const ABody: string = ''): THttpRequest;
  public
    constructor Create(const AHttpClient: IHttpClient; const AConfig: TApiConfig);
    destructor Destroy; override;

    function ConsultarClassificacaoTributaria: THttpResponse;
    function ExecuteCustomRequest(const AEndpoint: string; AMethod: THttpMethod = hmGet; const ABody: string = ''): THttpResponse;

    property HttpClient: IHttpClient read FHttpClient;
    property Config: TApiConfig read FConfig;
  end;

implementation

{ TApiConfig }

constructor TApiConfig.Create(const ABaseURL: string);
begin
  inherited Create;
  FBaseURL := ABaseURL;
  FTimeout := 30000;
end;

{ TCFFApiService }

constructor TCFFApiService.Create(const AHttpClient: IHttpClient; const AConfig: TApiConfig);
begin
  inherited Create;
  FHttpClient := AHttpClient;
  FConfig := AConfig;
end;

destructor TCFFApiService.Destroy;
begin
  FConfig.Free;
  inherited;
end;

function TCFFApiService.BuildURL(const AEndpoint: string): string;
begin
  Result := FConfig.BaseURL;
  if not Result.EndsWith('/') and not AEndpoint.StartsWith('/') then
    Result := Result + '/';
  Result := Result + AEndpoint;
end;

function TCFFApiService.CreateRequest(const AEndpoint: string; AMethod: THttpMethod; const ABody: string): THttpRequest;
begin
  Result.Initialize;
  Result.URL := BuildURL(AEndpoint);
  Result.Method := AMethod;
  Result.Body := ABody;
  Result.ContentType := 'application/json';
  Result.Accept := 'application/json';
  Result.UserAgent := 'CFF-API-Client/1.0';
end;

function TCFFApiService.ConsultarClassificacaoTributaria: THttpResponse;
var
  Request: THttpRequest;
begin
  Request := CreateRequest('consultas/classTrib', hmGet);
  Result := FHttpClient.Execute(Request);
end;

function TCFFApiService.ExecuteCustomRequest(const AEndpoint: string; AMethod: THttpMethod; const ABody: string): THttpResponse;
var
  Request: THttpRequest;
begin
  Request := CreateRequest(AEndpoint, AMethod, ABody);
  Result := FHttpClient.Execute(Request);
end;

end.

