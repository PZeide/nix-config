{
  lib,
  config,
  ...
}: {
  options.zeide.graphical.hyprland = with lib; {
    enable = mkEnableOption "home manager configuration of hyprland";

    monitors = mkOption {
      type = with types; listOf str;
      default = [", preferred, auto, 1"];
      description = ''
        Monitors configuration of Hyprland.
      '';
    };
  };

  imports = [
    ./plugins.nix
    ./rules.nix
    ./binds.nix
  ];

  config = let
    selfConfig = config.zeide.graphical.hyprland;
  in
    lib.mkIf selfConfig.enable {
      stylix.targets.hyprland.enable = true;

      xdg.configFile."uwsm/env-hyprland".text = ''
        export GDK_BACKEND="wayland,x11,*"
        export QT_QPA_PLATFORM="wayland;xcb"
        export QT_AUTO_SCREEN_SCALE_FACTOR="1"
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
        export SDL_VIDEODRIVER="wayland"
        export CLUTTER_BACKEND="wayland"
      '';

      wayland.windowManager.hyprland = {
        enable = true;
        xwayland.enable = true;
        systemd.enable = false;

        settings = {
          misc = {
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
            vrr = 1;
            focus_on_activate = true;
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

      # Hint Electron apps to use Wayland
      home.sessionVariables.NIXOS_OZONE_WL = "1";
    };
}
