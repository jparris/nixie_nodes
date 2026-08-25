{
  lib,
  config,
  pkgs,
  ...
}: {
  age.secrets.acme.file = ../../secrets/porkbun.age;
  security.acme.acceptTerms = true;
  security.acme.certs."int.securityishard.fyi" = {
    group = "acme";
    email = "parrisj@gmail.com";
    dnsProvider = "porkbun";
    credentialsFile = config.age.secrets.acme.path;
    webroot = null;
    extraDomainNames = ["*.int.securityishard.fyi"];
  };
}
