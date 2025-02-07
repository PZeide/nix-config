{pkgs, ...}: let
  nautilusEnv = pkgs.buildEnv {
    name = "nautilus-env";

    paths = with pkgs; [
      nautilus
      nautilus-python
      nautilus-open-any-terminal
    ];
  };
in {
  home.packages = with pkgs; [
    nautilusEnv
    adwaita-icon-theme
  ];

  xdg.mimeApps.defaultApplications = {
    "inode/directory" = ["nautilus.desktop;org.gnome.Nautilus.desktop"];
  };

  dconf.settings = {
    "com/github/stunkymonkey/nautilus-open-any-terminal" = {
      "terminal" = "kitty";
    };
  };

  home.sessionVariables = {
    NAUTILUS_4_EXTENSION_DIR = "${nautilusEnv}/lib/nautilus/extensions-4";
  };
}
