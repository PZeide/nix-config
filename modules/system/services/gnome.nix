{
  config,
  lib,
  pkgs,
  ...
}: {
  options.zeide.services.gnome = with lib; {
    enableGvfs = mkEnableOption "gvfs support (recommended for nautilus)";
    enablePolkit = mkEnableOption "gnome polkit (available in graphical environment only)";
    enableKeyring = mkEnableOption "gnome keyring";
    unlockKeyringServices = mkOption {
      type = with types; listOf str;
      default = [];
      description = ''
        List of PAM services that will automatically unlock gnome keyring.
      '';
    };
  };

  config = let
    selfConfig = config.zeide.services.gnome;
  in {
    services.gvfs.enable = selfConfig.enableGvfs;

    security.polkit.enable = lib.mkDefault selfConfig.enablePolkit;
    systemd.user.services.polkit-gnome-authentication-agent-1 = lib.mkIf selfConfig.enablePolkit {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

    services.gnome.gnome-keyring.enable = selfConfig.enableKeyring;
    security.pam.services = config.security.pam.services // lib.genAttrs selfConfig.unlockKeyringServices (name: true);
  };
}
