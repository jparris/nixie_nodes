{
  config,
  pkgs,
  age,
  ...
}: {
  age.secrets.qui.file = ../../../secrets/qui.age;

  services = {
    qbittorrent = {
      enable = true;
      openFirewall = true;
      serverConfig = {
        LegalNotice.Accepted = true;
        Preferences = {
          HardDisk = {
            Savefilestolocation = "/appdata/qbittorrent";
          };
          WebUI = {
            Username = "parrisj";
            Password_PBKDF2 = "@ByteArray(ElbZXK37HEnyoo3PI/HVcg==:2pNFaNy4L0h7Jde3NSM4KODYuw8ANdCqhjvakguu6dPXQvOg6CSKaQ8BdudTtpXIwjpDliXNXlAr4QhvmXmqdw==)";
          };
          General.Locale = "en";
        };
      };
    };
    qui = {
      enable = true;
      openFirewall = true;
      secretFile = config.age.secrets.qui.path;
      settings = {
        host = "0.0.0.0";
      };
    };
  };
}
