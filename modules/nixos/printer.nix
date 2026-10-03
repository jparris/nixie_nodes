{
  inputs,
  ...
}:
{
  flake.modules.nixos.printing = { hardware, ... }: {
    hardware.printers = {
      ensureDefaultPrinter = "Brother_HL-L2305";
      ensurePrinters = [
        {
          deviceUri = "ipp://192.168.1.227/ipp";
          location = "home";
          name = "Brother_HL-L2305";
          model = "everywhere";
        }
      ];
    };
    services.printing.enable = true;
  };
}
