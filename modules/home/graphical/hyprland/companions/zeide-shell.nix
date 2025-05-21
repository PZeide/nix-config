{
  lib,
  config,
  inputs,
  system,
  ...
}: {
  options.zeide.graphical.hyprland.companions.zeide-shell = with lib; {
    enable = mkEnableOption "zeide-shell powered by ags";
  };

  config = let
    selfConfig = config.zeide.graphical.hyprland.companions.zeide-shell;
  in
    lib.mkIf selfConfig.enable {
      systemd.user.services.zeide-shell = {
        Unit = {
          Description = "zeide-shell";
          After = ["graphical-session.target"];
          PartOf = ["graphical-session.target"];
          ConditionEnvironment = "WAYLAND_DISPLAY";
        };

        Service = {
          Type = "simple";
          ExecStart = "${lib.getExe inputs.zeide-shell.packages.${system}.default}";
          Restart = "always";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };

        Install.WantedBy = ["graphical-session.target"];
      };
    };
}
