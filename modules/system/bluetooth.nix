{
  config,
  lib,
  ...
}: {
  options.zeide.bluetooth = with lib; {
    enable = mkEnableOption "bluetooth support";
  };

  config = let
    selfConfig = config.zeide.bluetooth;
  in
    lib.mkIf selfConfig.enable {
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
