let
  utgard-host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA+SQ/ClXErepiIhEkIjf2IKJnWM2epWAj9zbBLJqlpG";
  utgard-parrisj = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMYpTe1MlvhI5EOSber15XNXgnR8/aFhOIgp0Vh9jjRz parrisj@utgard";
  utgard = [utgard-host utgard-parrisj];
in {
  "acme.age".publicKeys = utgard;
  "transmission.age".publicKeys = utgard;
}
