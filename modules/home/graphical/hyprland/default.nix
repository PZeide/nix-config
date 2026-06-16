{
  lib,
  config,
  osConfig,
  inputs,
  system,
  ...
}: {
  options.zeide.graphical.hyprland = with lib; {
    enable = mkEnableOption "home manager configuration of hyprland";

    monitors = mkOption {
      type = with types; listOf attrs;
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
    ./binds.nix
    ./gestures.nix
    ./plugins.nix
    ./rules.nix
    ./shell.nix
  ];

  config = let
    cfg = config.zeide.graphical.hyprland;

    mkBezierCurve = name: first: second: {
      _args = [
        name
        {
          type = "bezier";
          points = [
            first
            second
          ];
        }
      ];
    };

    mkAnimation = leaf: speed: bezier: style:
      {
        inherit leaf speed bezier;
        enabled = true;
      }
      // lib.optionalAttrs (style != null) {inherit style;};
  in
    lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = osConfig.zeide.graphical.hyprland.enable;
          message = "osConfig.zeide.graphical.hyprland.enable is required to enable hyprland in home.";
        }
      ];

      stylix.targets.hyprland.enable = true;

      xdg = {
        configFile."uwsm/env-hyprland".text = ''
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

        portal = {
          extraPortals = [inputs.shiny-portal.packages.${system}.default];
          config.hyprland = {
            "org.freedesktop.impl.portal.Secret" = "gnome-keyring";
            "org.freedesktop.impl.portal.GlobalShortcuts" = "hyprland";
            "org.freedesktop.impl.portal.ScreenCast" = "hyprland";
            #"org.freedesktop.impl.portal.ScreenCast" = ["shiny"];
          };
        };
      };

      wayland.windowManager.hyprland = {
        enable = true;
        xwayland.enable = true;
        systemd.enable = false;

        # Use system-wide packages
        package = osConfig.programs.hyprland.package;
        portalPackage = osConfig.programs.hyprland.portalPackage;

        configType = "lua";

        settings = {
          monitor =
            cfg.monitors
            ++ [
              {
                output = "";
                mode = "preferred";
                position = "auto";
                scale = 1;
              }
            ];

          curve = [
            (mkBezierCurve "expressiveFastSpatial" [0.42 1.67] [0.21 0.90])
            (mkBezierCurve "expressiveSlowSpatial" [0.39 1.29] [0.35 0.98])
            (mkBezierCurve "expressiveDefaultSpatial" [0.38 1.21] [0.22 1.00])
            (mkBezierCurve "emphasizedDecel" [0.05 0.7] [0.1 1])
            (mkBezierCurve "emphasizedAccel" [0.3 0] [0.8 0.15])
            (mkBezierCurve "standardDecel" [0 0] [0 1])
            (mkBezierCurve "menuDecel" [0.1 1] [0 1])
            (mkBezierCurve "menuAccel" [0.52 0.03] [0.72 0.08])
            (mkBezierCurve "stall" [1 (-0.1)] [0.7 0.85])
          ];

          animation = [
            # Windows
            (mkAnimation "windowsIn" 3 "emphasizedDecel" "popin 80%")
            (mkAnimation "fadeIn" 3 "emphasizedDecel" null)
            (mkAnimation "windowsOut" 2 "emphasizedDecel" "popin 90%")
            (mkAnimation "fadeOut" 2 "emphasizedDecel" null)
            (mkAnimation "windowsMove" 3 "emphasizedDecel" "slide")
            (mkAnimation "border" 10 "emphasizedDecel" null)

            # Layers
            (mkAnimation "layersIn" 2.7 "emphasizedDecel" "popin 93%")
            (mkAnimation "layersOut" 2.4 "menuAccel" "popin 94%")

            # Fade
            (mkAnimation "fadeLayersIn" 0.5 "menuDecel" null)
            (mkAnimation "fadeLayersOut" 2.7 "stall" null)
            (mkAnimation "fadePopupsIn" 0.5 "menuDecel" null)
            (mkAnimation "fadePopupsOut" 2.7 "stall" null)

            # Workspaces
            (mkAnimation "workspaces" 7 "menuDecel" "slide")

            # Special workspaces
            (mkAnimation "specialWorkspaceIn" 2.8 "emphasizedDecel" "slidevert")
            (mkAnimation "specialWorkspaceOut" 1.2 "emphasizedAccel" "slidevert")
          ];

          device = cfg.perDeviceConfigurations;

          config = {
            general = {
              border_size = 2;
              gaps_in = 6;
              gaps_out = 12;
              resize_on_border = true;
              hover_icon_on_border = false;
              allow_tearing = true;
            };

            decoration = {
              rounding = 8;
              rounding_power = 3.5;

              blur = {
                enabled = true;
                size = 3;
                passes = 2;
              };

              shadow = {
                enabled = true;
                range = 20;
                render_power = 2;
              };
            };

            animations.enabled = true;

            input = {
              kb_layout = cfg.keyboardLayout;
              kb_variant = cfg.keyboardVariant;
              numlock_by_default = true;
              accel_profile = "flat";
              follow_mouse = 1;

              touchpad = {
                natural_scroll = true;
                scroll_factor = 0.5;
                clickfinger_behavior = true;
              };
            };

            gestures = {
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
              session_lock_xray = true;
            };

            xwayland = {
              force_zero_scaling = true;
            };

            render = {
              direct_scanout = 1;
            };

            cursor = {
              no_hardware_cursors = 1;
            };

            ecosystem = {
              no_update_news = true;
              no_donation_nag = true;
            };
          };
        };
      };
    };
}
