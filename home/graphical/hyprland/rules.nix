{
  wayland.windowManager.hyprland.settings = {
    windowrulev2 = [
      "opacity 1 override 0.9 override, class:^(kitty)$"

      # Disable opacity for these apps:
      "opacity 1 override, class:^(zen)$"
      "opacity 1 override, class:^(org.gnome.Loupe)$"
      "opacity 1 override, class:^(com.obsproject.Studio)$"
    ];

    layerrule = [
      "blur, walker"
      "ignorealpha, walker"

      "blur, syshud"
      "ignorealpha, syshud"
    ];
  };
}
