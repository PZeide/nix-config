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
    cfg = config.zeide.time;
  in
    lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = !(cfg.timeZone != null && cfg.enableAutomaticTimezone);
          message = "osConfig.zeide.time.timeZone cannot be set when automatic timezone are enabled.";
        }
        {
          assertion = !cfg.enableAutomaticTimeZone || config.zeide.services.location.enable;
          message = "osConfig.zeide.services.location.enable is required to enable automatic timezone.";
        }
      ];

      time.timeZone = cfg.timeZone;
      services.automatic-timezoned.enable = cfg.enableAutomaticTimeZone;
    };
}
