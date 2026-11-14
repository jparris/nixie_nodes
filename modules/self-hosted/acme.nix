{
  flake.modules.nixos.acme =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.acme;
    in
    {
      options = {
        acme.domain = lib.mkOption { type = lib.types.str; };

        acme.email = lib.mkOption { type = lib.types.str; };

        acme.api_key = lib.mkOption { type = lib.types.path; };

        acme.secret_key = lib.mkOption { type = lib.types.path; };
      };

      config = {
        age.secrets.porkbun_api.file = cfg.api_key;
        age.secrets.porkbun_secret_api.file = cfg.secret_key;

        security.acme = {
          acceptTerms = true;

          certs."${cfg.domain}" = {
            dnsProvider = "porkbun";
            email = cfg.email;
            credentialFiles = {
              "PORKBUN_API_KEY_FILE" = config.age.secrets.porkbun_api.path;
              "PORKBUN_SECRET_API_KEY_FILE" = config.age.secrets.porkbun_secret_api.path;
            };
            dnsResolver = "1.1.1.1:53";
            extraDomainNames = [ "*.${cfg.domain}" ];
          };
        };
      };
    };
}
