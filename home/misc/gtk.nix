{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.home.gtk;

  gtkCss = config.lib.stylix.colors {
    template = ./gtk.mustache;
    extension = "css";
  };
in
{
  options.home.gtk = with lib; {
    iconAccent = mkOption {
      type = types.enum [
        "rosewater"
        "maroon"
        "pink"
        "teal"
        "peach"
        "sapphire"
        "red"
        "flamingo"
        "green"
        "mauve"
        "sky"
        "yellow"
        "blue"
        "lavender"
      ];
      default = "blue";
      description = ''
        Accent color of icon theme (applied to folders).
      '';
    };

    bookmarks = mkOption {
      type = with types; listOf str;
      default = [ ];
      description = ''
        List of bookmarks in the file browser.
      '';
    };
  };

  config = {
    gtk = {
      enable = true;
      iconTheme = {
        package = pkgs.catppuccin-papirus-folders.override {
          flavor = "mocha";
          accent = cfg.iconAccent;
        };

        name = "Papirus-Dark";
      };

      gtk3.bookmarks = cfg.bookmarks;
    };

    dconf = {
      settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };
      };
    };

    xdg.configFile = {
      "gtk-3.0/gtk.css".source = lib.mkForce gtkCss;
      "gtk-4.0/gtk.css".source = lib.mkForce gtkCss;
    };

    stylix.targets.gtk.enable = true;
  };
}
