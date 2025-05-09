{
  config,
  lib,
  ...
}: {
  options.zeide.laptop = with lib; {
    enable = mkEnableOption "laptop config";
    enableTlp = mkEnableOption "tlp power management daemon (recommended for laptop)";
  };

  config = let
    selfConfig = config.zeide.laptop;
  in
    lib.mkIf selfConfig.enable {
      services = {
        # On laptop, short press on power key should suspend instead of shutdown
        logind.powerKey = "suspend";

        upower = {
          enable = true;
          criticalPowerAction = "HybridSleep";
        };

        tlp.enable = selfConfig.enableTlp;
      };

      # Enable userspace backlight control
      hardware.brillo.enable = true;
      users.users.${config.zeide.user} = {
        extraGroups = ["video"];
      };
    };
}
