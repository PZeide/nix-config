{
  config,
  lib,
  ...
}: {
  options.zeide.bluetooth = with lib; {
    enable = mkEnableOption "bluetooth support";
  };

  config = let
    cfg = config.zeide.bluetooth;
  in
    lib.mkIf cfg.enable {
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;

        settings = {
          General = {
            Experimental = true;
          };
        };
      };
    };
}
