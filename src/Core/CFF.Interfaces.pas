unit CFF.Interfaces;

interface

uses
  System.SysUtils,
  System.Classes;

type
  THttpMethod = (hmGet, hmPost, hmPut, hmDelete, hmPatch);

  THttpRequest = record
    URL: string;
    Method: THttpMethod;
    Body: string;
    ContentType: string;
    Accept: string;
    UserAgent: string;
    procedure Initialize;
  end;

  THttpResponse = record
    StatusCode: Integer;
    Content: string;
    ContentType: string;
    ErrorMessage: string;
    Success: Boolean;
  end;

  ICertificateProvider = interface
    ['{A1B2C3D4-E5F6-4A5B-8C9D-0E1F2A3B4C5D}']
    function GetCertificatePath: string;
    function GetPassword: string;
    function IsValid: Boolean;
  end;

  IHttpClient = interface
    ['{B2C3D4E5-F6A7-4B5C-9D0E-1F2A3B4C5D6E}']
    procedure SetCertificateProvider(const ACertProvider: ICertificateProvider);
    function Execute(const ARequest: THttpRequest): THttpResponse;
    function GetClientName: string;
  end;

  IHttpClientFactory = interface
    ['{C3D4E5F6-A7B8-4C5D-0E1F-2A3B4C5D6E7F}']
    function CreateClient(const AClientType: string): IHttpClient;
    function GetAvailableClients: TArray<string>;
  end;

implementation

{ THttpRequest }

procedure THttpRequest.Initialize;
begin
  URL := '';
  Method := hmGet;
  Body := '';
  ContentType := 'application/json';
  Accept := 'application/json';
  UserAgent := 'CFF-API-Client/1.0';
end;

end.

