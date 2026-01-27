{
  config,
  osConfig,
  lib,
  ...
}: {
  options.zeide.services.udiskie = with lib; {
    enable = mkEnableOption "udiskie auto-mounting (requires udisks2)";
  };

  config = let
    cfg = config.zeide.services.udiskie;
  in
    lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = osConfig.zeide.services.udisks2.enable;
          message = "osConfig.zeide.services.udisks2.enable is required to enable udiskie.";
        }
      ];

      services.udiskie = {
        enable = true;
        automount = true;
      };
    };
}
