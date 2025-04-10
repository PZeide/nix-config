{
  lib,
  config,
  pkgs,
  inputs,
  system,
  ...
}: {
  options.zeide.graphical.hyprland.companions.hyprlock = with lib; {
    enable = mkEnableOption "hyprlock lock screen";

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
    selfConfig = config.zeide.graphical.hyprland.companions.hyprlock;

    hyprlockConfig' = image: {
      general = {
        hide_cursor = true;
        ignore_empty_input = true;
      };

      background = {
        monitor = "";
        path = "${image}";

        blur_passes = 3;
        blur_size = 6;
      };

      input-field = {
        monitor = "";

        size = "400, 40";
        outline_thickness = 0;
        dots_size = 0.25;
        dots_spacing = 0.55;
        dots_center = true;
        dots_rounding = -1;
        outer_color = "rgba(242, 243, 244, 0)";
        inner_color = "rgba(242, 243, 244, 0)";
        font_color = "rgba(242, 243, 244, 0.75)";
        fade_on_empty = false;
        placeholder_text = "";
        hide_input = false;
        check_color = "rgba(204, 136, 34, 0)";
        fail_color = "rgba(204, 34, 34, 0)";
        fail_text = "$FAIL <b>($ATTEMPTS)</b>";
        invert_numlock = false;
        swap_font_color = false;
        position = "0, -468";
        halign = "center";
        valign = "center";
      };

      label = [
        {
          monitor = "";
          text = ''cmd[update:1000] echo "$(date +"%A %d %B")"'';
          color = "rgba(242, 243, 244, 0.75)";
          font_size = 20;
          font_family = "SF Pro Display Bold";
          position = "0, 405";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = ''cmd[update:1000] echo "$(date +"%I:%M")"'';
          color = "rgba(242, 243, 244, 0.75)";
          font_size = 93;
          font_family = "SF Pro Display Bold";
          position = "0, 310";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "$DESC";
          color = "rgba(242, 243, 244, 0.75)";
          font_size = 12;
          font_family = "SF Pro Display Bold";
          position = "0, -407";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "Enter Password";
          color = "rgba(242, 243, 244, 0.75)";
          font_size = 10;
          font_family = "SF Pro Display";
          position = "0, -438";
          halign = "center";
          valign = "center";
        }
      ];
    };

    autostartConfig = lib.hm.generators.toHyprconf {
      attrs = hyprlockConfig' config.stylix.image;
    };
  in
    lib.mkIf selfConfig.enable {
      programs.hyprlock = {
        enable = true;
        package = inputs.hyprlock.packages.${system}.default;
        settings = hyprlockConfig' "screenshot";
      };

      services.hypridle.settings.general = lib.mkIf config.zeide.graphical.hyprland.companions.hypridle.enable {
        lock_cmd = "pidof hyprlock || hyprlock";
        unlock_cmd = "pkill -USR1 hyprlock";
        inhibit_sleep = 3;
      };

      systemd.user.services.hyprlock-autostart = lib.mkIf selfConfig.autostartOnGraphical {
        Unit = {
          Description = "hyprlock-autostart";
          After = ["graphical-session.target"];
          PartOf = ["graphical-session.target"];
          ConditionEnvironment = "WAYLAND_DISPLAY";
        };

        Service = {
          Type = "simple";
          ExecStart = "${lib.getExe pkgs.hyprlock} --immediate-render -c ${
            pkgs.writeText "hyprlock-autostart.conf" "${autostartConfig}"
          }";
          # Immediately exit hyprland if hyprlock-autostart fail
          ExecStopPost = "/bin/sh -c 'if [ \"$$EXIT_STATUS\" != 0 ]; then hyprctl dispatch exit; fi'";
          Restart = "no";
        };

        Install.WantedBy = ["graphical-session.target"];
      };
    };
}
