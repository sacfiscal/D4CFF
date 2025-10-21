program CFF_Api;

uses
  Vcl.Forms,
  UI.Principal in 'src\UI\UI.Principal.pas' {UIPrincipal},
  CFF.Interfaces in 'src\Core\CFF.Interfaces.pas',
  CFF.Certificate in 'src\Core\CFF.Certificate.pas',
  CFF.HttpClient.Indy in 'src\HttpClients\CFF.HttpClient.Indy.pas',
  CFF.HttpClient.RestClient in 'src\HttpClients\CFF.HttpClient.RestClient.pas',
  CFF.HttpClient.NetHttp in 'src\HttpClients\CFF.HttpClient.NetHttp.pas',
  CFF.HttpClient.Synapse in 'src\HttpClients\CFF.HttpClient.Synapse.pas',
  CFF.Factory in 'src\Core\CFF.Factory.pas',
  CFF.ApiService in 'src\Core\CFF.ApiService.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TUIPrincipal, UIPrincipal);
  Application.Run;
end.
