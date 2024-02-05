program DnsResolver;

uses
  Forms,
  DnsResolver1 in 'DnsResolver1.pas' {DnsResolverForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDnsResolverForm, DnsResolverForm);
  Application.Run;
end.
