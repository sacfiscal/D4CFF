unit CFF.Factory;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  CFF.Interfaces,
  CFF.HttpClient.Indy,
  CFF.HttpClient.RestClient,
  CFF.HttpClient.NetHttp,
  CFF.HttpClient.Synapse;

type
  THttpClientType = (hctIndy, hctRestClient, hctNetHttpClient, hctSynapse);

  THttpClientFactory = class(TInterfacedObject, IHttpClientFactory)
  private
    class var FInstance: IHttpClientFactory;
    class function GetInstance: IHttpClientFactory; static;
  public
    function CreateClient(const AClientType: string): IHttpClient;
    function GetAvailableClients: TArray<string>;

    class function CreateIndyClient: IHttpClient;
    class function CreateRestClient: IHttpClient;
    class function CreateNetHttpClient: IHttpClient;
    class function CreateSynapseClient: IHttpClient;

    class property Instance: IHttpClientFactory read GetInstance;
    class destructor Destroy;
  end;

implementation

{ THttpClientFactory }

class function THttpClientFactory.GetInstance: IHttpClientFactory;
begin
  if not Assigned(FInstance) then
    FInstance := THttpClientFactory.Create;
  Result := FInstance;
end;

class destructor THttpClientFactory.Destroy;
begin
  FInstance := nil;
end;

function THttpClientFactory.CreateClient(const AClientType: string): IHttpClient;
var
  ClientType: string;
begin
  ClientType := LowerCase(Trim(AClientType));
  
  if (ClientType = 'indy') or (ClientType = 'internet direct') then
    Result := CreateIndyClient
  else if (ClientType = 'restclient') or (ClientType = 'rest') then
    Result := CreateRestClient
  else if (ClientType = 'nethttpclient') or (ClientType = 'nethttp') then
    Result := CreateNetHttpClient
  else if ClientType = 'synapse' then
    Result := CreateSynapseClient
  else
    raise Exception.CreateFmt('Unknown HTTP client type: %s', [AClientType]);
end;

function THttpClientFactory.GetAvailableClients: TArray<string>;
begin
  SetLength(Result, 4);
  Result[0] := 'Indy';
  Result[1] := 'RestClient';
  Result[2] := 'NetHttpClient';
  Result[3] := 'Synapse';
end;

class function THttpClientFactory.CreateIndyClient: IHttpClient;
begin
  Result := TIndyHttpClient.Create;
end;

class function THttpClientFactory.CreateRestClient: IHttpClient;
begin
  Result := TRestClientHttpClient.Create;
end;

class function THttpClientFactory.CreateNetHttpClient: IHttpClient;
begin
  Result := TNetHttpClientAdapter.Create;
end;

class function THttpClientFactory.CreateSynapseClient: IHttpClient;
begin
  Result := TSynapseHttpClient.Create;
end;

end.

