{
  wayland.windowManager.hyprland.settings = {
    windowrulev2 = [
      "opacity 1 override 0.9 override, class:^(kitty)$"
      "opacity 1 override, class:^(zen-alpha)$"
    ];

    layerrule = [
      "blur, walker"
      "ignorealpha, walker"
    ];
  };
}
