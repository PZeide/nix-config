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
    cfg = config.zeide.laptop;
  in
    lib.mkIf cfg.enable {
      services = {
        # On laptop, short press on power key should suspend instead of shutdown
        logind.settings.Login.HandlePowerKey = "suspend";

        upower = {
          enable = true;
          criticalPowerAction = "HybridSleep";
        };

        tlp = lib.mkIf cfg.enableTlp {
          enable = true;
          settings = {
            RESTORE_DEVICE_STATE_ON_STARTUP = 1;
          };
        };
      };

      # Enable userspace backlight control
      hardware.brillo.enable = true;
      users.users.${config.zeide.user} = {
        extraGroups = ["video"];
      };
    };
}
