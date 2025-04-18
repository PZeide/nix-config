{
  config,
  lib,
  ...
}: {
  options.zeide.time = with lib; {
    enable = mkEnableOption "time config";
    enableAutomaticTimeZone = mkEnableOption "automatic timezone";

    timeZone = mkOption {
      type = with types; nullOr str;
      default = null;
      example = "Europe/Paris";
      description = ''
        Time zone to use throughout the system.
        This cannot be set with automatic timezone.
      '';
    };
  };

  config = let
    selfConfig = config.zeide.time;
  in
    lib.mkIf selfConfig.enable {
      assertions = [
        {
          assertion = !(selfConfig.timeZone != null && selfConfig.enableAutomaticTimezone);
          message = "osConfig.zeide.time.timeZone cannot be set when automatic timezone are enabled.";
        }
        {
          assertion = !selfConfig.enableAutomaticTimeZone || config.zeide.services.location.enable;
          message = "osConfig.zeide.services.location.enable is required to enable automatic timezone.";
        }
      ];

      time.timeZone = selfConfig.timeZone;
      services.automatic-timezoned.enable = selfConfig.enableAutomaticTimeZone;
    };
}
