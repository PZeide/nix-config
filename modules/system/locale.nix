{
  config,
  lib,
  ...
}: {
  options.zeide.locale = with lib; {
    enable = mkEnableOption "locale config";

    defaultLocale = mkOption {
      type = types.str;
      default = "en_US.UTF-8";
      description = ''
        Default locale to use throughout the system.
      '';
    };

    supportedLocales = mkOption {
      type = with types; listOf str;
      default = [
        "en_US.UTF-8/UTF-8"
        "fr_FR.UTF-8/UTF-8"
        "ja_JP.UTF-8/UTF-8"
      ];
      description = ''
        List of locales supported by the system.
      '';
    };

    consoleKeyMap = mkOption {
      type = types.str;
      default = "us-acentos";
      description = ''
        TTY keymap to use. Graphical environments are unaffected by this option.
      '';
    };
  };

  config = let
    selfConfig = config.zeide.locale;
  in
    lib.mkIf selfConfig.enable {
      console.keyMap = selfConfig.consoleKeyMap;
      i18n = {
        defaultLocale = selfConfig.defaultLocale;
        supportedLocales = selfConfig.supportedLocales;
      };
    };
}
