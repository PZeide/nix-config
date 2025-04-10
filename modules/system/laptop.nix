{
  config,
  lib,
  ...
}: {
  options.zeide.laptop = with lib; {
    enable = mkEnableOption "laptop config";
    enableTlp = mkEnableOption "tlp power management daemon (recommended for laptop)";
    forceS2idle = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to force the use of s2idle sleep mode.
        In some weird cases, the default is s3 (deep) sleep mode.
      '';
    };
  };

  config = let
    selfConfig = config.zeide.laptop;
  in
    lib.mkIf selfConfig.enable {
      services = {
        # On laptop, short press on power key should suspend instead of shutdown
        logind.powerKey = "suspend";

        upower.enable = true;
        tlp.enable = selfConfig.enableTlp;
      };

      # Enable userspace backlight control
      hardware.brillo.enable = true;
      users.users.${config.zeide.user} = {
        extraGroups = ["video"];
      };

      systemd.sleep.extraConfig = lib.mkIf selfConfig.forceS2idle ''
        MemorySleepMode=s2idle
      '';
    };
}
