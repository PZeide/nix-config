{
  lib,
  config,
  osConfig,
  inputs,
  system,
  ...
}: {
  options.zeide.graphical.hyprland.companions.hypridle = with lib; {
    enable = mkEnableOption "hypridle idle daemon";

    dimBacklight = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether hypridle should dim the backlight (requires laptop system module).
      '';
    };
  };

  config = let
    selfConfig = config.zeide.graphical.hyprland.companions.hypridle;
  in
    lib.mkIf selfConfig.enable {
      assertions = [
        {
          assertion = !selfConfig.dimBacklight || osConfig.zeide.laptop.enable;
          message = "osConfig.zeide.laptop.enable is required to dim backlight.";
        }
      ];

      services.hypridle = {
        enable = true;
        package = inputs.hypridle.packages.${system}.default;

        settings = {
          general = {
            lock_cmd = "${lib.getExe inputs.shiny-shell.packages.${system}.default} ipc call lockscreen lock";
            before_sleep_cmd = "loginctl lock-session";
            after_sleep_cmd = "hyprctl dispatch dpms on";
          };

          listener =
            [
              {
                timeout = 600;
                on-timeout = "hyprctl dispatch dpms off && loginctl lock-session";
                on-resume =
                  if selfConfig.dimBacklight
                  then "hyprctl dispatch dpms on && brillo -I"
                  else "hyprctl dispatch dpms on";
              }
              {
                timeout = 900;
                on-timeout = "systemctl suspend";
              }
            ]
            ++ lib.optional selfConfig.dimBacklight {
              timeout = 300;
              on-timeout = "brillo -O && brillo -u 500000 -S 20%";
              on-resume = "brillo -I";
            };
        };
      };
    };
}
