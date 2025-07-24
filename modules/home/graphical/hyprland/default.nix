{
  lib,
  config,
  osConfig,
  ...
}: {
  options.zeide.graphical.hyprland = with lib; {
    enable = mkEnableOption "home manager configuration of hyprland";

    monitors = mkOption {
      type = with types; listOf str;
      default = [];
      description = ''
        Monitors configuration of Hyprland.
      '';
    };

    keyboardLayout = mkOption {
      type = types.str;
      default = "us";
      description = ''
        Default keyboard layout for input methods.
        Should be an existing XKB layout.
      '';
    };

    keyboardVariant = mkOption {
      type = with types; nullOr str;
      default = null;
      description = ''
        Default keyboard variant for input methods.
        Should be an existing XKB variant.
      '';
    };

    perDeviceConfigurations = mkOption {
      type = with types; listOf attrs;
      default = [];
      description = ''
        Per input device configurations.
        See: https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs
      '';
    };
  };

  imports = [
    ./companions
    ./binds.nix
    ./plugins.nix
    ./rules.nix
  ];

  config = let
    selfConfig = config.zeide.graphical.hyprland;
  in
    lib.mkIf selfConfig.enable {
      assertions = [
        {
          assertion = osConfig.zeide.graphical.hyprland.enable;
          message = "osConfig.zeide.graphical.hyprland.enable is required to enable hyprland in home.";
        }
      ];

      stylix.targets.hyprland.enable = true;

      xdg.configFile."uwsm/env-hyprland".text = ''
        export GDK_BACKEND="wayland,x11,*"
        export QT_QPA_PLATFORM="wayland;xcb"
        export QT_AUTO_SCREEN_SCALE_FACTOR="1"
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
        export SDL_VIDEODRIVER="wayland"
        export CLUTTER_BACKEND="wayland"
        export NIXOS_OZONE_WL="1"

        export APP2UNIT_SLICES="a=app-graphical.slice b=background-graphical.slice s=session-graphical.slice"
        export APP2UNIT_TYPE="scope"
      '';

      wayland.windowManager.hyprland = {
        enable = true;
        xwayland.enable = true;
        systemd.enable = false;

        # Use system-wide packages
        package = osConfig.programs.hyprland.package;
        portalPackage = osConfig.programs.hyprland.portalPackage;

        settings = {
          monitor = selfConfig.monitors ++ [", highres, auto, 1"];

          general = {
            border_size = 2;
            gaps_in = 6;
            gaps_out = 12;
            resize_on_border = true;
            hover_icon_on_border = false;
            allow_tearing = true;
          };

          decoration = {
            rounding = 12;
            rounding_power = 3.5;
            active_opacity = 0.9;
            inactive_opacity = 0.8;
            fullscreen_opacity = 1;

            blur = {
              enabled = true;
              size = 3;
              passes = 2;
              popups = true;
              input_methods = true;
            };

            shadow = {
              enabled = true;
              range = 20;
              render_power = 2;
              ignore_window = true;
            };
          };

          animations = {
            enabled = true;
            first_launch_animation = false;

            bezier = [
              "easeInOutQuart, 0.76, 0, 0.24, 1"
              "fluentDecel, 0, 0.2, 0.4, 1"
              "easeOutCirc, 0, 0.55, 0.45, 1"
              "easeOutCubic, 0.33, 1, 0.68, 1"
              "easeOutQuint, 0.23, 1, 0.32, 1"
            ];

            animation = [
              "windowsIn, 1, 3, easeOutCubic, popin 30%"
              "windowsOut, 1, 3, fluentDecel, popin 70%"
              "windowsMove, 1, 4, easeOutQuint"
              "fadeIn, 1, 3, easeOutCubic"
              "fadeOut, 1, 1.7, easeOutCubic"
              "fadeSwitch, 1, 1, easeOutCirc"
              "fadeDim, 1, 4, fluentDecel"
              "workspaces, 1, 3, easeOutCubic, slide"
              "specialWorkspace, 1, 3, easeOutCubic, slidevert"
              "layers, 1, 4, easeOutQuint"
            ];
          };

          input = {
            kb_layout = selfConfig.keyboardLayout;
            kb_variant = selfConfig.keyboardVariant;
            numlock_by_default = true;
            accel_profile = "flat";
            follow_mouse = 1;

            touchpad = {
              natural_scroll = true;
              scroll_factor = 0.5;
              clickfinger_behavior = true;
            };
          };

          device = selfConfig.perDeviceConfigurations;

          gestures = {
            workspace_swipe = true;
            workspace_swipe_distance = 400;
            workspace_swipe_cancel_ratio = 0.2;
            workspace_swipe_min_speed_to_force = 5;
          };

          group.auto_group = false;

          misc = {
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
            vrr = 1;
            disable_autoreload = true;
            focus_on_activate = false;
            new_window_takes_over_fullscreen = 1;
          };

          xwayland = {
            force_zero_scaling = true;
          };

          render = {
            direct_scanout = 1;
          };

          ecosystem = {
            no_update_news = true;
            no_donation_nag = true;
          };

          experimental = {
            xx_color_management_v4 = true;
          };
        };
      };
    };
}
