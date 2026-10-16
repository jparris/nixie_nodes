{
  flake.modules.nixos.kanidm = {pkgs, ...}: {
    networking.firewall.allowedTCPPorts = [636];

    services = {
      kanidm = {
        client = {
          enable = true;
          settings = {
            uri = "https://kanidm.int.securityishard.fyi";
          };
        };

        package = pkgs.kanidm_1_11;
        server = {
          enable = true;
          settings = {
            version = "2";
            # 11114 k = 11, a = 1, n = 14
            bindaddress = "0.0.0.0:11114";
            ldapbindaddress = "0.0.0.0:636";
            domain = "kanidm.int.securityishard.fyi";
            origin = "https://kanidm.int.securityishard.fyi";
            http_client_address_info.x-forward-for = [
              "127.0.0.1"
              "127.0.0.0/8"
            ];
            tls_chain = "/var/lib/kanidm/cert.pem";
            tls_key = "/var/lib/kanidm/key.pem";
          };
        };

        # Declarative persons/groups/oauth2 clients, applied by kanidm-provision
        # in the service's post-start hook. instanceUrl defaults to
        # https://localhost:11114 (from bindaddress) and, being localhost,
        # accepts the wildcard cert that only matches the public hostname.
        #
        # No idmAdminPasswordFile is set, so idm_admin gets a fresh random
        # password on every restart -- provisioning only needs it internally.
        # To log in as idm_admin, either run
        #   kanidmd recover-account idm_admin
        # or add an agenix secret and point
        # `provision.idmAdminPasswordFile` at it (that also requires
        # `package = pkgs.kanidmWithSecretProvisioning_1_11`).
        provision = {
          enable = true;

          persons.parrisj = {
            displayName = "Jon Parris";
            legalName = "Jon Parris";
            mailAddresses = ["parrisj@gmail.com"];
            # Any group listed here must also be declared in provision.groups,
            # including kanidm's built-in ones.
            groups = [];
          };
        };
      };
    };
  };
}
