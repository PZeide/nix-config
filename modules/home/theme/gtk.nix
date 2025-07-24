{
  asset,
  config,
  lib,
  pkgs,
  ...
}: {
  options.zeide.theme.gtk = with lib; {
    enable = mkEnableOption "gtk theming support";

    overrideCss = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to override gtk3 and gtk4 css with theme colors.
      '';
    };
  };

  config = let
    selfConfig = config.zeide.theme.gtk;

    gtkCss = config.lib.stylix.colors {
      template = asset "gtk/theme.css.mustache";
      extension = "css";
    };
  in
    lib.mkIf selfConfig.enable {
      gtk.enable = true;

      dconf.settings."org/gnome/desktop/interface" = {
        color-scheme =
          if config.stylix.polarity == "dark"
          then "prefer-dark"
          else "default";
      };

      xdg.configFile = {
        "gtk-3.0/gtk.css" = {
          enable = selfConfig.overrideCss;
          source = lib.mkIf selfConfig.overrideCss (lib.mkForce gtkCss);
        };

        "gtk-4.0/gtk.css" = {
          enable = selfConfig.overrideCss;
          source = lib.mkIf selfConfig.overrideCss (lib.mkForce gtkCss);
        };
      };

      stylix.targets.gtk.enable = true;
    };
}
