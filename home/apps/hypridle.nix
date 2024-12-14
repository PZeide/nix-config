{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.home.hypridle;

  hyprctl = "${inputs.hyprland.packages.${pkgs.system}.hyprland}/bin/hyprctl";
in
{
  options.home.hypridle = with lib; {
    dimBacklight = mkOption {
      type = types.bool;
      default = false;
      description = ''
        If hypridle should dim the backlight.
      '';
    };
  };

  config = {
    services.hypridle = {
      enable = true;

      settings = {
        general = {
          lock_cmd = "pidof hyprlock || ${lib.getExe pkgs.hyprlock}";
          unlock_cmd = "pkill -USR1 hyprlock";

          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "${hyprctl} dispatch dpms on";
        };

        listener =
          [
            {
              timeout = 300;
              on-timeout = "${hyprctl} dispatch dpms off && loginctl lock-session";
              on-resume = "${hyprctl} dispatch dpms on";
            }
            {
              timeout = 600;
              on-timeout = "systemctl suspend";
            }
          ]
          ++ lib.optionals (cfg.dimBacklight) [
            {
              timeout = 180;
              on-timeout = "${lib.getExe pkgs.brillo} -O && ${lib.getExe pkgs.brillo} -u 10000 -S 20%";
              on-resume = "${lib.getExe pkgs.brillo} -I";
            }
          ];
      };
    };

    systemd.user.services.hypridle.Unit.After = lib.mkForce [ "graphical-session.target" ];
  };
}
