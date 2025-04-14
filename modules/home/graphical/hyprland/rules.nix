{
  wayland.windowManager.hyprland.settings = {
    windowrulev2 = [
      # Use kitty native opacity instead
      "opacity 1 override 0.9 override, class:^(kitty)$"

      # Make PiP window flaoting and sticky
      "float, title:^(Picture-in-Picture)$"
      "pin, title:^(Picture-in-Picture)$"

      # Disable opacity for these apps
      "opacity 1 override, class:^(zen-beta)$"
      "opacity 1 override, class:^(mpv)$"
      "opacity 1 override, class:^(org.gnome.Loupe)$"
      "opacity 1 override, class:^(org.gnome.Papers)$"
      "opacity 1 override, class:^(com.obsproject.Studio)$"
    ];
  };
}
