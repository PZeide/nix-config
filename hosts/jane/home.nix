{
  homeMod,
  inputs,
  system,
  ...
}: {
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
    (homeMod "apps/zen/default")
    (homeMod "apps/nautilus")
    (homeMod "apps/anyrun")
    (homeMod "apps/mpv")
    (homeMod "apps/obs")

    (homeMod "apps/development/wakatime")
    (homeMod "apps/development/vscodium")
    (homeMod "apps/development/neovim")

    (homeMod "apps/bundle/terminal")
    (homeMod "apps/bundle/daily")
    (homeMod "apps/bundle/development")

    (homeMod "apps/games/osu")
  ];

  config.home.core.wallpaper = ../../assets/wallpapers/jane.jpg;
  config.home.core.polarity = "dark";

  config.home.hyprland.monitors = [
    "eDP-1, 1920x1080@144, 0x0, 1"
  ];

  config.home.hyprland.backlightBinds = true;

  config.wayland.windowManager.hyprland.settings = {
    input = {
      # Required for different device layout
      resolve_binds_by_sym = true;
    };

    device = [
      # Use different layout for my laptop keyboard (fr)
      {
        name = "ite-tech.-inc.-ite-device(8910)-keyboard";
        kb_layout = "fr";
        kb_variant = "";
      }

      # Reduce touchpad sensitivity and use adaptive accel profile
      {
        name = "elan06fa:00-04f3:31dd-touchpad";
        sensitivity = -0.1;
        accel_profile = "adpative";
      }
    ];
  };

  config.home.hypridle.dimBacklight = true;

  config.home.vscodium = {
    colorTheme = "GitHub Dark Dimmed";
    colorThemePackage =
      inputs.nix-vscode-extensions.extensions.${system}.vscode-marketplace.github.github-vscode-theme;
  };

  config.home.gtk.bookmarks = ["file:///mnt/data Data"];
  config.home.gtk.iconAccent = "red";
}
