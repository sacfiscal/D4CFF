unit CFF.HttpClient.NetHttp;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Net.URLClient,
  System.Net.HttpClient,
  system.NetConsts,
  System.Net.HttpClientComponent,
  CFF.Interfaces;

type
  TNetHttpClientAdapter = class(TInterfacedObject, IHttpClient)
  private
    FCertProvider: ICertificateProvider;
    procedure ConfigureCertificate(const AHttpClient: THTTPClient);
  public
    procedure SetCertificateProvider(const ACertProvider: ICertificateProvider);
    function Execute(const ARequest: THttpRequest): THttpResponse;
    function GetClientName: string;
  end;

implementation

uses
  System.NetEncoding;

{ TNetHttpClientAdapter }

procedure TNetHttpClientAdapter.SetCertificateProvider(const ACertProvider: ICertificateProvider);
begin
  FCertProvider := ACertProvider;
end;

procedure TNetHttpClientAdapter.ConfigureCertificate(const AHttpClient: THTTPClient);
begin
  AHttpClient.SecureProtocols := [THTTPSecureProtocol.TLS12, THTTPSecureProtocol.TLS13];

  if Assigned(FCertProvider) and FCertProvider.IsValid then
  begin
    // AHttpClient.ClientCertificate := LoadCertificateFromPFX(FCertProvider.GetCertificatePath, FCertProvider.GetPassword);
  end;
end;

function TNetHttpClientAdapter.Execute(const ARequest: THttpRequest): THttpResponse;
var
  HttpClient: THTTPClient;
  HttpResponse: IHTTPResponse;
  RequestStream: TStringStream;
begin
  Result.Success := False;
  Result.StatusCode := 0;
  Result.Content := '';
  Result.ErrorMessage := '';

  HttpClient := THTTPClient.Create;
  try
    try

      ConfigureCertificate(HttpClient);

      HttpClient.ContentType := ARequest.ContentType;
      HttpClient.Accept := ARequest.Accept;
      HttpClient.UserAgent := ARequest.UserAgent;

      case ARequest.Method of
        hmGet:
          HttpResponse := HttpClient.Get(ARequest.URL);
        hmPost:
          begin
            RequestStream := TStringStream.Create(ARequest.Body, TEncoding.UTF8);
            try
              HttpResponse := HttpClient.Post(ARequest.URL, RequestStream);
            finally
              RequestStream.Free;
            end;
          end;
        hmPut:
          begin
            RequestStream := TStringStream.Create(ARequest.Body, TEncoding.UTF8);
            try
              HttpResponse := HttpClient.Put(ARequest.URL, RequestStream);
            finally
              RequestStream.Free;
            end;
          end;
        hmDelete:
          HttpResponse := HttpClient.Delete(ARequest.URL);
        hmPatch:
          begin
            RequestStream := TStringStream.Create(ARequest.Body, TEncoding.UTF8);
            try
              HttpResponse := HttpClient.Patch(ARequest.URL, RequestStream);
            finally
              RequestStream.Free;
            end;
          end;
      end;

      Result.StatusCode := HttpResponse.StatusCode;
      Result.Content := HttpResponse.ContentAsString;
      Result.ContentType := HttpResponse.MimeType;
      Result.Success := (HttpResponse.StatusCode >= 200) and (HttpResponse.StatusCode < 300);

      if not Result.Success then
        Result.ErrorMessage := HttpResponse.StatusText;

    except
      on E: Exception do
      begin
        Result.Success := False;
        Result.ErrorMessage := E.Message;
      end;
    end;
  finally
    HttpClient.Free;
  end;
end;

function TNetHttpClientAdapter.GetClientName: string;
begin
  Result := 'NetHttpClient';
end;

end.

