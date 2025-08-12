{
  lib,
  config,
  inputs,
  system,
  ...
}: {
  options.zeide.graphical.hyprland.companions.shiny-shell = with lib; {
    enable = mkEnableOption "shiny-shell own shell :)";

    autostartOnGraphical = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to autostart hyprlock on graphical target.
        This DOES NOT act as a login manager, however, hyprland will exit if hyprlock fail.
      '';
    };
  };

  config = let
    selfConfig = config.zeide.graphical.hyprland.companions.shiny-shell;
  in
    lib.mkIf selfConfig.enable {
      systemd.user.services.shiny-shell = {
        Unit = {
          Description = "shiny-shell";
          After = ["graphical-session.target"];
          PartOf = ["graphical-session.target"];
          ConditionEnvironment = "WAYLAND_DISPLAY";
        };

        Service = {
          Type = "simple";
          ExecStart = "${lib.getExe inputs.shiny-shell.packages.${system}.default}";
          Restart = lib.mkIf selfConfig.autostartOnGraphical "no";
        };

        Install.WantedBy = ["graphical-session.target"];
      };
    };
}
