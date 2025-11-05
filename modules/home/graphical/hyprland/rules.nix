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
          # Terminal inactive opacity
          "opacity 1 override 0.8 override, class:^(kitty)$"

          # Make PiP window flaoting and sticky
          "float, title:^(Picture-in-Picture)$"
          "pin, title:^(Picture-in-Picture)$"

          # Make xdg-termfilechooser floating
          "float, class:^(xdg-termfilechooser-yazi)$"

          # Games
          "tag +game, title:^(Wuthering Waves  )$" # Window name has two spaces at the end ?????
          "tag +game, class:^(genshinimpact.exe)$"
          "tag +game, class:^(starrail.exe)$"
          "tag +game, class:^(zenlesszonezero.exe)$"
          "tag +game, class:^(.*steam_app.*)$"

          "renderunfocused, tag:game"
          "fullscreen, tag:game"
          "immediate, tag:game"
        ]
        ++ selfConfig.windows;

      layerrule = [
        "blur, shiny:.*"
        "ignorezero, shiny:.*"
        "noanim, shiny:.*"
      ];

      workspace = selfConfig.workspaces;
    };
  };
}
