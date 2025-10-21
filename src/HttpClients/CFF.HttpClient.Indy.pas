unit CFF.HttpClient.Indy;

interface

uses
  System.SysUtils,
  System.Classes,
  IdHTTP,
  IdSSLOpenSSL,
  CFF.Interfaces;

type
  TIndyHttpClient = class(TInterfacedObject, IHttpClient)
  private
    FCertProvider: ICertificateProvider;
    FLastPassword: string;
    procedure ConfigureSSL(const ASSL: TIdSSLIOHandlerSocketOpenSSL);
    procedure OnGetPassword(var APassword: string);
  public
    procedure SetCertificateProvider(const ACertProvider: ICertificateProvider);
    function Execute(const ARequest: THttpRequest): THttpResponse;
    function GetClientName: string;
  end;

implementation

{ TIndyHttpClient }

procedure TIndyHttpClient.SetCertificateProvider(const ACertProvider: ICertificateProvider);
begin
  FCertProvider := ACertProvider;
  if Assigned(FCertProvider) then
    FLastPassword := FCertProvider.GetPassword;
end;

procedure TIndyHttpClient.ConfigureSSL(const ASSL: TIdSSLIOHandlerSocketOpenSSL);
begin
  ASSL.SSLOptions.Method := sslvTLSv1_2;
  ASSL.SSLOptions.Mode := sslmClient;
  ASSL.SSLOptions.VerifyMode := [];
  ASSL.SSLOptions.VerifyDepth := 0;

  if Assigned(FCertProvider) and FCertProvider.IsValid then
  begin
    ASSL.SSLOptions.CertFile := FCertProvider.GetCertificatePath;
    ASSL.SSLOptions.KeyFile := FCertProvider.GetCertificatePath;
    ASSL.SSLOptions.RootCertFile := '';
    ASSL.OnGetPassword := OnGetPassword;
  end;
end;

procedure TIndyHttpClient.OnGetPassword(var APassword: string);
begin
  APassword := FLastPassword;
end;

function TIndyHttpClient.Execute(const ARequest: THttpRequest): THttpResponse;
var
  HTTP: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  ResponseStream: TStringStream;
begin
  Result.Success := False;
  Result.StatusCode := 0;
  Result.Content := '';
  Result.ErrorMessage := '';

  HTTP := TIdHTTP.Create(nil);
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  ResponseStream := TStringStream.Create('', TEncoding.UTF8);
  try
    try
      ConfigureSSL(SSL);

      HTTP.IOHandler := SSL;
      HTTP.Request.ContentType := ARequest.ContentType;
      HTTP.Request.Accept := ARequest.Accept;
      HTTP.Request.UserAgent := ARequest.UserAgent;

      case ARequest.Method of
        hmGet:
          HTTP.Get(ARequest.URL, ResponseStream);
        hmPost:
          HTTP.Post(ARequest.URL, TStringStream.Create(ARequest.Body, TEncoding.UTF8), ResponseStream);
        hmPut:
          HTTP.Put(ARequest.URL, TStringStream.Create(ARequest.Body, TEncoding.UTF8), ResponseStream);
        hmDelete:
          HTTP.Delete(ARequest.URL);
        hmPatch:
          HTTP.Patch(ARequest.URL, TStringStream.Create(ARequest.Body, TEncoding.UTF8), ResponseStream);
      end;

      Result.Success := True;
      Result.StatusCode := HTTP.ResponseCode;
      Result.Content := ResponseStream.DataString;
      Result.ContentType := HTTP.Response.ContentType;
    except
      on E: Exception do
      begin
        Result.Success := False;
        Result.ErrorMessage := E.Message;
        if HTTP.ResponseCode > 0 then
          Result.StatusCode := HTTP.ResponseCode
        else
          Result.StatusCode := 0;
      end;
    end;
  finally
    ResponseStream.Free;
    SSL.Free;
    HTTP.Free;
  end;
end;

function TIndyHttpClient.GetClientName: string;
begin
  Result := 'Indy';
end;

end.

