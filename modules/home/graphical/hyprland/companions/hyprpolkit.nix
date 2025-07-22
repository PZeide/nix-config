{
  lib,
  config,
  inputs,
  system,
  ...
}: {
  options.zeide.graphical.hyprland.companions.hyprpolkit = with lib; {
    enable = mkEnableOption "hyprpolkit polkit agent";
  };

  config = let
    selfConfig = config.zeide.graphical.hyprland.companions.hyprpolkit;
  in
    lib.mkIf selfConfig.enable {
      systemd.user.services.hyprpolkit = lib.mkIf selfConfig.enable {
        Unit = {
          Description = "hyprpolkit";
          After = ["graphical-session.target"];
          PartOf = ["graphical-session.target"];
          ConditionEnvironment = "WAYLAND_DISPLAY";
        };

        Service = {
          ExecStart = "${inputs.hyprpolkitagent.packages.${system}.default}/libexec/hyprpolkitagent";
          TimeoutStopSec = "5sec";
          Restart = "on-failure";
        };

        Install.WantedBy = ["graphical-session.target"];
      };
    };
}
