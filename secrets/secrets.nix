let
  utgard-host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA+SQ/ClXErepiIhEkIjf2IKJnWM2epWAj9zbBLJqlpG";
  utgard-parrisj = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMYpTe1MlvhI5EOSber15XNXgnR8/aFhOIgp0Vh9jjRz parrisj@utgard";
  utgard = [utgard-host utgard-parrisj];
  yggdrasil-host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFsvf8t3oldCX2EKopEcwUFSAHIlQqij7vChdwghoYFF root@nixos";
  yggdrasil-parrisj = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJDgYzYsfx4lO0jcfzNvzISbSrct9/qTh3MERAvmO/up parrisj@nixos";
  yggdrasil = [yggdrasil-host yggdrasil-parrisj];
in {
  "acme.age".publicKeys = utgard ++ yggdrasil;
  "cloudflare_ddns.age".publicKeys = yggdrasil;
  "miniflux.age".publicKeys = utgard;
  "nextcloud.age".publicKeys = utgard;
  "transmission.age".publicKeys = utgard;
  "vaultwarden.age".publicKeys = utgard;
}
