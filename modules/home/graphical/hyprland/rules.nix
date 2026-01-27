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
        Extra anonymous window rules.
      '';
    };

    layers = mkOption {
      type = with types; listOf str;
      default = [];
      description = ''
        Extra anonymous layer rules.
      '';
    };

    workspaces = mkOption {
      type = with types; listOf str;
      default = [];
      description = ''
        Extra anonymous workspace rules.
      '';
    };
  };

  config = let
    cfg = config.zeide.graphical.hyprland.rules;
  in {
    wayland.windowManager.hyprland.settings = {
      windowrule =
        [
          # Terminal opacity
          "match:class ^(kitty)$, opacity 1.0 override 0.8 override"

          # Zed opacity
          "match:class ^(dev.zed.Zed)$, opacity 0.9 override 0.8 override"

          # Make PiP window flaoting and sticky
          "match:title ^(Picture-in-Picture)$, float on, pin on"

          # Make xdg-termfilechooser floating
          "match:class ^(xdg-termfilechooser-yazi)$, float on"

          # Add tag game to games
          "match:class ^(genshinimpact\.exe)$, tag +game"
          "match:class ^(starrail\.exe)$, tag +game"
          "match:class ^(zenlesszonezero\.exe)$, tag +game"
          "match:class ^(.*steam_app.*)$, tag +game"

          # Rules for games
          "match:tag game, render_unfocused on, fullscreen on, immediate on, idle_inhibit always"
        ]
        ++ cfg.windows;

      layerrule = ["match:namespace ^(shiny:.*)$, blur on, ignore_alpha 0.6, no_anim on"] ++ cfg.layers;

      workspace = cfg.workspaces;
    };
  };
}
