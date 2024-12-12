{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  hyprctl = "${inputs.hyprland.packages.${pkgs.system}.hyprland}/bin/hyprctl";

  generateConfig' = image: {
    general = {
      grace = 0;
      disable_loading_bar = true;
      ignore_empty_input = true;
      hide_cursor = true;
    };

    background = {
      monitor = "";
      path = "${image}";

      blur_passes = 3;
      blur_size = 6;
    };

    input-field = {
      monitor = "";

      size = "300, 30";
      outline_thickness = 0;
      dots_size = 0.25; # Scale of input-field height, 0.2 - 0.8
      dots_spacing = 0.55; # Scale of dots' absolute size, 0.0 - 1.0
      dots_center = true;
      dots_rounding = -1;
      outer_color = "rgba(242, 243, 244, 0)";
      inner_color = "rgba(242, 243, 244, 0)";
      font_color = "rgba(242, 243, 244, 0.75)";
      fade_on_empty = false;
      placeholder_text = ""; # Text rendered in the input box when it's empty.
      hide_input = false;
      check_color = "rgba(204, 136, 34, 0)";
      fail_color = "rgba(204, 34, 34, 0)"; # if authentication failed, changes outer_color and fail message color
      fail_text = "$FAIL <b>($ATTEMPTS)</b>"; # can be set to empty
      fail_transition = 300; # transition time in ms between normal outer_color and fail_color
      capslock_color = -1;
      numlock_color = -1;
      bothlock_color = -1; # when both locks are active. -1 means don't change outer color (same for above)
      invert_numlock = false; # change color if numlock is off
      swap_font_color = false; # see below
      position = "0, -468";
      halign = "center";
      valign = "center";
    };

    label = [
      {
        monitor = "";
        text = ''cmd[update:1000] echo "$(date +"%A, %B %d")"'';
        color = "rgba(242, 243, 244, 0.75)";
        font_size = 20;
        font_family = "SF Pro Display Bold";
        position = "0, 405";
        halign = "center";
        valign = "center";
      }
      {
        monitor = "";
        text = ''cmd[update:1000] echo "$(date +"%k:%M")"'';
        color = "rgba(242, 243, 244, 0.75)";
        font_size = 93;
        font_family = "SF Pro Display Bold";
        position = "0, 310";
        halign = "center";
        valign = "center";
      }
      {
        monitor = "";
        text = "Thibaud";
        color = "rgba(242, 243, 244, 0.75)";
        font_size = 12;
        font_family = "SF Pro Display Bold";
        position = "0, -407";
        halign = "center";
        valign = "center";
      }
      {
        monitor = "";
        text = "Touch ID or Enter Password";
        color = "rgba(242, 243, 244, 0.75)";
        font_size = 10;
        font_family = "SF Pro Display";
        position = "0, -438";
        halign = "center";
        valign = "center";
      }
    ];

    /*
      label = [
        {
          # Day-Month-Date
          monitor = "";
          text = ''cmd[update:1000] echo -e "$(date +"%A, %B %d")"'';
          color = base07;
          font_size = 28;
          font_family = fonts.sansSerif.name + " Bold";
          position = "0, 490";
          halign = "center";
          valign = "center";
        }
        # Time
        {
          monitor = "";
          text = ''cmd[update:1000] echo "<span>$(date +"%I:%M")</span>"'';
          color = base07;
          font_size = 160;
          font_family = "steelfish outline regular";
          position = "0, 370";
          halign = "center";
          valign = "center";
        }
        # USER
        {
          monitor = "";
          text = "    $USER";
          color = base07;
          outline_thickness = 2;
          dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
          dots_spacing = 0.2; # Scale of dots' absolute size, 0.0 - 1.0
          dots_center = true;
          font_size = 18;
          font_family = fonts.sansSerif.name + " Bold";
          position = "0, -180";
          halign = "center";
          valign = "center";
        }
      ];
    */
  };
in
{
  programs.hyprlock = {
    enable = true;
    settings = generateConfig' "screenshot";
  };

  xdg.configFile."hypr/hyprlock-wallpaper.conf".text = lib.hm.generators.toHyprconf {
    attrs = generateConfig' config.stylix.image;
  };

  systemd.user.services.hyprlock = {
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };

    Unit = {
      ConditionEnvironment = "WAYLAND_DISPLAY";
      Description = "hyprlock";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${lib.getExe pkgs.hyprlock} -c ${
        config.xdg.configFile."hypr/hyprlock-wallpaper.conf".source
      }";

      # Exit Hyprland if hyprlock failed
      ExecStopPost = "/bin/sh -c 'if [ \"$$EXIT_STATUS\" = 1 ]; then ${hyprctl} dispatch exit; fi'";
      Restart = "no";
    };
  };
}
