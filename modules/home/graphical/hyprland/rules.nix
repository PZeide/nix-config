{
  config,
  lib,
  ...
}: {
  options.zeide.graphical.hyprland.rules = with lib; {
    windows = mkOption {
      type = with types; listOf str;
      default = [];
      description = ''
        Extra window rules.
      '';
    };

    workspaces = mkOption {
      type = with types; listOf str;
      default = [];
      description = ''
        Extra workspace rules.
      '';
    };
  };

  config = let
    selfConfig = config.zeide.graphical.hyprland.rules;
  in {
    wayland.windowManager.hyprland.settings = {
      windowrule =
        [
          # Use kitty native opacity instead
          "opacity 1 override 0.8 override, class:^(kitty)$"

          # Make PiP window flaoting and sticky
          "float, title:^(Picture-in-Picture)$"
          "pin, title:^(Picture-in-Picture)$"

          # Disable opacity for these apps
          "opacity 0.999 override, class:^(zen-beta)$"
          "opacity 1 override, class:^(mpv)$"
          "opacity 1 override, class:^(org.gnome.Loupe)$"
          "opacity 1 override, class:^(org.gnome.Papers)$"
          "opacity 1 override, class:^(com.obsproject.Studio)$"
          "opacity 1 override, class:^(Waydroid)$"
          "opacity 1 override, class:^(waydroid.*)$"

          # Games
          "tag +game, title:^(Wuthering Waves  )$" # Window name has two spaces at the end ?????
          "tag +game, class:^(genshinimpact.exe)$"
          "tag +game, class:^(starrail.exe)$"
          "tag +game, class:^(zenlesszonezero.exe)$"

          "opacity 1 override, tag:game"
          "renderunfocused, tag:game"
          "fullscreen, tag:game"
        ]
        ++ selfConfig.windows;

      layerrule = [
        "blur, gtk4-layer-shell"
        "ignorezero, gtk4-layer-shell"
      ];

      workspace = selfConfig.workspaces;
    };
  };
}
