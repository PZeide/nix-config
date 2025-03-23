{
  wayland.windowManager.hyprland.settings = {
    windowrulev2 = [
      "opacity 1 override 0.9 override, class:^(kitty)$"

      # Make PiP window flaoting and sticky
      "float, title:^(Picture-in-Picture)$"
      "pin, title:^(Picture-in-Picture)$"

      # Disable opacity for these apps:
      "opacity 1 override, class:^(zen)$"
      "opacity 1 override, class:^(org.gnome.Loupe)$"
      "opacity 1 override, class:^(com.obsproject.Studio)$"
    ];

    layerrule = [
      "blur, anyrun"
      "ignorealpha 0.5, anyrun"

      "blur, syshud"
      "ignorealpha, syshud"
    ];
  };
}
