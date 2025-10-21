unit CFF.HttpClient.RestClient;

interface

uses
  System.SysUtils,
  System.Classes,
  System.NetEncoding,
  System.Net.HttpClient,
  REST.Client,
  REST.Types,
  IPPeerClient,
  CFF.Interfaces;

type
  TRestClientHttpClient = class(TInterfacedObject, IHttpClient)
  private
    FCertProvider: ICertificateProvider;
    function GetRESTMethod(const AMethod: THttpMethod): TRESTRequestMethod;
  public
    procedure SetCertificateProvider(const ACertProvider: ICertificateProvider);
    function Execute(const ARequest: THttpRequest): THttpResponse;
    function GetClientName: string;
  end;

implementation

{ TRestClientHttpClient }

procedure TRestClientHttpClient.SetCertificateProvider(const ACertProvider: ICertificateProvider);
begin
  FCertProvider := ACertProvider;
end;

function TRestClientHttpClient.GetRESTMethod(const AMethod: THttpMethod): TRESTRequestMethod;
begin
  case AMethod of
    hmGet: Result := TRESTRequestMethod.rmGET;
    hmPost: Result := TRESTRequestMethod.rmPOST;
    hmPut: Result := TRESTRequestMethod.rmPUT;
    hmDelete: Result := TRESTRequestMethod.rmDELETE;
    hmPatch: Result := TRESTRequestMethod.rmPATCH;
  else
    Result := TRESTRequestMethod.rmGET;
  end;
end;

function TRestClientHttpClient.Execute(const ARequest: THttpRequest): THttpResponse;
var
  RESTClient: TRESTClient;
  RESTRequest: TRESTRequest;
  RESTResponse: TRESTResponse;
begin
  Result.Success := False;
  Result.StatusCode := 0;
  Result.Content := '';
  Result.ErrorMessage := '';

  RESTClient := TRESTClient.Create(nil);
  RESTRequest := TRESTRequest.Create(nil);
  RESTResponse := TRESTResponse.Create(nil);
  try
    try
      RESTClient.BaseURL := ARequest.URL;
      RESTClient.Accept := ARequest.Accept;
      RESTClient.ContentType := ARequest.ContentType;

      if Assigned(FCertProvider) and FCertProvider.IsValid then
      begin
        RESTClient.SecureProtocols := [THTTPSecureProtocol.TLS12];
     end;

      RESTRequest.Client := RESTClient;
      RESTRequest.Response := RESTResponse;
      RESTRequest.Method := GetRESTMethod(ARequest.Method);

      if (ARequest.Body <> '') and (ARequest.Method in [hmPost, hmPut, hmPatch]) then
      begin
        RESTRequest.Body.Add(ARequest.Body, TRESTContentType.ctAPPLICATION_JSON);
      end;
      RESTRequest.Params.AddHeader('User-Agent', ARequest.UserAgent);

      RESTRequest.Execute;

      Result.Success := (RESTResponse.StatusCode >= 200) and (RESTResponse.StatusCode < 300);
      Result.StatusCode := RESTResponse.StatusCode;
      Result.Content := RESTResponse.Content;
      Result.ContentType := RESTResponse.ContentType;

      if not Result.Success then
        Result.ErrorMessage := RESTResponse.StatusText;

    except
      on E: Exception do
      begin
        Result.Success := False;
        Result.ErrorMessage := E.Message;
      end;
    end;
  finally
    RESTResponse.Free;
    RESTRequest.Free;
    RESTClient.Free;
  end;
end;

function TRestClientHttpClient.GetClientName: string;
begin
  Result := 'RestClient';
end;

end.

