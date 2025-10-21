unit CFF.HttpClient.Synapse;

interface

uses
  System.SysUtils,
  System.Classes,
  CFF.Interfaces;

{$IFDEF SYNAPSE_AVAILABLE}
uses
  httpsend,
  ssl_openssl,
  synautil;
{$ENDIF}

type
  TSynapseHttpClient = class(TInterfacedObject, IHttpClient)
  private
    FCertProvider: ICertificateProvider;
    {$IFDEF SYNAPSE_AVAILABLE}
    procedure ConfigureSSL(const AHttp: THTTPSend);
    {$ENDIF}
  public
    procedure SetCertificateProvider(const ACertProvider: ICertificateProvider);
    function Execute(const ARequest: THttpRequest): THttpResponse;
    function GetClientName: string;
  end;

implementation

{ TSynapseHttpClient }

procedure TSynapseHttpClient.SetCertificateProvider(const ACertProvider: ICertificateProvider);
begin
  FCertProvider := ACertProvider;
end;

{$IFDEF SYNAPSE_AVAILABLE}
procedure TSynapseHttpClient.ConfigureSSL(const AHttp: THTTPSend);
begin
  if Assigned(FCertProvider) and FCertProvider.IsValid then
  begin
    AHttp.Sock.SSL.CertificateFile := FCertProvider.GetCertificatePath;
    AHttp.Sock.SSL.PrivateKeyFile := FCertProvider.GetCertificatePath;
    AHttp.Sock.SSL.KeyPassword := FCertProvider.GetPassword;
    AHttp.Sock.SSL.SSLType := LT_TLSv1_2;
  end;
end;
{$ENDIF}

function TSynapseHttpClient.Execute(const ARequest: THttpRequest): THttpResponse;
{$IFDEF SYNAPSE_AVAILABLE}
var
  Http: THTTPSend;
  ResponseStream: TStringStream;
  MethodStr: string;
{$ENDIF}
begin
  Result.Success := False;
  Result.StatusCode := 0;
  Result.Content := '';
  Result.ErrorMessage := '';

  {$IFDEF SYNAPSE_AVAILABLE}
  Http := THTTPSend.Create;
  ResponseStream := TStringStream.Create('', TEncoding.UTF8);
  try
    try
      ConfigureSSL(Http);

      Http.Headers.Add('Content-Type: ' + ARequest.ContentType);
      Http.Headers.Add('Accept: ' + ARequest.Accept);
      Http.Headers.Add('User-Agent: ' + ARequest.UserAgent);

      case ARequest.Method of
        hmGet: MethodStr := 'GET';
        hmPost: MethodStr := 'POST';
        hmPut: MethodStr := 'PUT';
        hmDelete: MethodStr := 'DELETE';
        hmPatch: MethodStr := 'PATCH';
      else
        MethodStr := 'GET';
      end;

      if (ARequest.Body <> '') and (ARequest.Method in [hmPost, hmPut, hmPatch]) then
      begin
        WriteStrToStream(Http.Document, ARequest.Body);
      end;

      if Http.HTTPMethod(MethodStr, ARequest.URL) then
      begin
        Result.StatusCode := Http.ResultCode;
        Result.Success := (Http.ResultCode >= 200) and (Http.ResultCode < 300);

        ResponseStream.CopyFrom(Http.Document, 0);
        Result.Content := ResponseStream.DataString;

        Result.ContentType := Http.Headers.Values['Content-Type'];
        
        if not Result.Success then
          Result.ErrorMessage := Http.ResultString;
      end
      else
      begin
        Result.Success := False;
        Result.ErrorMessage := 'HTTP request failed';
      end;

    except
      on E: Exception do
      begin
        Result.Success := False;
        Result.ErrorMessage := E.Message;
      end;
    end;
  finally
    ResponseStream.Free;
    Http.Free;
  end;
  {$ELSE}
  Result.ErrorMessage := 'Synapse library not available. Please install Synapse components.';
  {$ENDIF}
end;

function TSynapseHttpClient.GetClientName: string;
begin
  Result := 'Synapse';
end;

end.

