unit CFF.Certificate;

interface

uses
  System.SysUtils,
  System.IOUtils,
  CFF.Interfaces;

type
  TCertificateConfig = class
  private
    FCertificatePath: string;
    FPassword: string;
  public
    constructor Create(const ACertPath, APassword: string);
    property CertificatePath: string read FCertificatePath write FCertificatePath;
    property Password: string read FPassword write FPassword;
  end;

  TCertificateProvider = class(TInterfacedObject, ICertificateProvider)
  private
    FConfig: TCertificateConfig;
  public
    constructor Create(const AConfig: TCertificateConfig);
    destructor Destroy; override;

    function GetCertificatePath: string;
    function GetPassword: string;
    function IsValid: Boolean;
  end;

implementation

{ TCertificateConfig }

constructor TCertificateConfig.Create(const ACertPath, APassword: string);
begin
  inherited Create;
  FCertificatePath := ACertPath;
  FPassword := APassword;
end;

{ TCertificateProvider }

constructor TCertificateProvider.Create(const AConfig: TCertificateConfig);
begin
  inherited Create;
  FConfig := AConfig;
end;

destructor TCertificateProvider.Destroy;
begin
  FConfig.Free;
  inherited;
end;

function TCertificateProvider.GetCertificatePath: string;
begin
  Result := FConfig.CertificatePath;
end;

function TCertificateProvider.GetPassword: string;
begin
  Result := FConfig.Password;
end;

function TCertificateProvider.IsValid: Boolean;
begin
  Result := (FConfig.CertificatePath <> '') and
            TFile.Exists(FConfig.CertificatePath) and
            (FConfig.Password <> '');
end;

end.

