{
  config,
  pkgs,
  ...
}: {
  age.secrets.acme.file = ../../secrets/acme.age;
  security.acme.acceptTerms = true;
  security.acme.certs."int.securityishard.club" = {
    group = "acme";
    email = "parrisj@gmail.com";
    dnsProvider = "cloudflare";
    credentialsFile = config.age.secrets.acme.path;
    extraDomainNames = ["*.int.securityishard.club"];
  };
}
