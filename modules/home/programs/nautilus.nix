{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}: {
  options.zeide.programs.nautilus = with lib; {
    enable = mkEnableOption "nautilus file explorer";

    openTerminalAction = mkOption {
      type = with types; nullOr str;
      default = null;
      description = ''
        Terminal to open with 'Open in terminal' action.
      '';
    };
  };

  config = let
    selfConfig = config.zeide.programs.nautilus;

    nautilusEnv = pkgs.buildEnv {
      name = "nautilus-env";

      paths = with pkgs; [
        nautilus
        nautilus-python
        nautilus-open-any-terminal
      ];
    };
  in
    lib.mkIf selfConfig.enable {
      assertions = [
        {
          assertion = osConfig.zeide.services.gnome.fixNautilusExtensions;
          message = "osConfig.zeide.services.gnome.fixNautilusExtensions is required to enable nautilus.";
        }
      ];

      home = {
        packages = [nautilusEnv];

        sessionVariables = {
          NAUTILUS_4_EXTENSION_DIR = "${nautilusEnv}/lib/nautilus/extensions-4";
        };
      };

      dconf.settings = lib.mkIf (selfConfig.openTerminalAction != null) {
        "com/github/stunkymonkey/nautilus-open-any-terminal" = {
          "terminal" = selfConfig.openTerminalAction;
        };
      };
    };
}
