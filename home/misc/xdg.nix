{pkgs, ...}: {
  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
    };

    mime.enable = true;

    configFile."xdg-terminals.list".text = ''
      kitty.desktop
    '';
  };

  home.packages = [pkgs.xdg-terminal-exec];
}
