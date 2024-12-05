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
    bookmarks = mkOption {
      type = with types; listOf str;
      description = ''
        List of bookmarks in the file browser.
      '';
      default = [ ];
    };
  };

  config = {
    gtk = {
      enable = true;
      iconTheme = {
        package = pkgs.papirus-icon-theme;
        name = "Papirus";
      };

      gtk3.bookmarks = cfg.bookmarks;
    };

    xdg.configFile = {
      "gtk-3.0/gtk.css".source = lib.mkForce gtkCss;
      "gtk-4.0/gtk.css".source = lib.mkForce gtkCss;
    };

    stylix.targets.gtk.enable = true;
  };
}
