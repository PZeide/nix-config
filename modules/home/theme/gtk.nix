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

    iconFlavor = mkOption {
      type = types.enum [
        "latte"
        "frappe"
        "macchiato"
        "mocha"
      ];
      default = "mocha";
      description = ''
        Flavor of icon theme (applied to folders).
      '';
    };

    iconAccent = mkOption {
      type = types.enum [
        "blue"
        "flamingo"
        "green"
        "lavender"
        "maroon"
        "mauve"
        "peach"
        "pink"
        "red"
        "rosewater"
        "sapphire"
        "sky"
        "teal"
        "yellow"
      ];
      default = "blue";
      description = ''
        Accent color of icon theme (applied to folders).
      '';
    };
  };

  config = let
    selfConfig = config.zeide.theme.gtk;

    gtkCss = config.lib.stylix.colors {
      template = asset "gtk/gtk.mustache";
      extension = "css";
    };
  in
    lib.mkIf selfConfig.enable {
      gtk = {
        enable = true;
        iconTheme = {
          package = pkgs.catppuccin-papirus-folders.override {
            flavor = selfConfig.iconFlavor;
            accent = selfConfig.iconAccent;
          };

          name = "Papirus-Dark";
        };

        # TODO MOVE IN NAUTILUS DIRECTLY
        #gtk3.bookmarks = cfg.bookmarks;
      };

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
