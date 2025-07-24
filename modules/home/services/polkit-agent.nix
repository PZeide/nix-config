{
  config,
  lib,
  pkgs,
  ...
}: {
  options.zeide.services.polkit-agent = with lib; {
    enable = mkEnableOption "polkit-authentication-agent (from Gnome)";
  };

  config = let
    selfConfig = config.zeide.services.polkit-agent;
  in
    lib.mkIf selfConfig.enable {
      systemd.user.services.polkit-authentication-agent = {
        Unit = {
          Description = "polkit-authentication-agent";
          After = ["graphical-session.target"];
          PartOf = ["graphical-session.target"];
          ConditionEnvironment = "WAYLAND_DISPLAY";
        };

        Service = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };

        Install.WantedBy = ["graphical-session.target"];
      };
    };
}
