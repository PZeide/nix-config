{
  homeMod,
  inputs,
  system,
  ...
}:

{
  imports = [
    (homeMod "core")

    (homeMod "shell/fish")

    (homeMod "misc/xdg")
    (homeMod "misc/fonts")
    (homeMod "misc/cursor")
    (homeMod "misc/gtk")
    (homeMod "misc/clipboard")
    (homeMod "misc/security")
    (homeMod "misc/udiskie")

    (homeMod "graphical/hyprland")

    (homeMod "apps/hyprpaper")
    (homeMod "apps/hyprlock")
    (homeMod "apps/hypridle")
    (homeMod "apps/syshud")
    (homeMod "apps/kitty")
    (homeMod "apps/nautilus")
    (homeMod "apps/walker")
    (homeMod "apps/cider")
    (homeMod "apps/mpv")

    (homeMod "apps/development/wakatime")
    (homeMod "apps/development/vscodium")
    (homeMod "apps/development/neovim")

    (homeMod "apps/bundle/terminal")
    (homeMod "apps/bundle/daily")
    (homeMod "apps/bundle/development")
  ];

  config.home.core.wallpaper = ../../assets/wallpapers/nilou.jpg;

  config.home.hyprland.monitors = [
    "DP-1, 2560x1440@240, 0x0, 1.25"
    "DP-2, 1920x1080@144, -1920x80, 1"
  ];

  config.home.vscodium = {
    colorTheme = "Noctis Minimus";
    colorThemePackage =
      inputs.nix-vscode-extensions.extensions.${system}.vscode-marketplace.liviuschera.noctis;
  };

  config.home.gtk.bookmarks = [ "file:///mnt/data Data" ];
  config.home.gtk.iconAccent = "sapphire";
}
