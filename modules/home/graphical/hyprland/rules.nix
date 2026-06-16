{
  config,
  lib,
  ...
}: {
  options.zeide.graphical.hyprland.rules = with lib; {
    windows = mkOption {
      type = with types; listOf attrs;
      default = [];
      description = ''
        Extra anonymous window rules.
      '';
    };

    layers = mkOption {
      type = with types; listOf attrs;
      default = [];
      description = ''
        Extra anonymous layer rules.
      '';
    };

    workspaces = mkOption {
      type = with types; listOf attrs;
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
      window_rule =
        [
          # Terminal opacity
          {
            match.class = "^(kitty)$";
            opacity = "1.0 override 0.8 override";
          }

          # Zed opacity
          {
            match.class = "^(dev.zed.Zed)$";
            opacity = "0.8 override 0.7 override";
          }

          # Jetbrains IDEs opacity
          {
            match.class = "^(jetbrains-.*)$";
            opacity = "0.85 override 0.75 override";
          }

          # Make PiP window flaoting and sticky
          {
            match.title = "^(Picture-in-Picture)$";
            float = true;
            pin = true;
          }

          # Make xdg-termfilechooser floating
          {
            match.class = "^(xdg-termfilechooser-yazi)$";
            float = true;
          }

          # Add tag game to games
          {
            match.class = "^(genshinimpact\\.exe)$";
            tag = "+game";
          }
          {
            match.class = "^(starrail\\.exe)$";
            tag = "+game";
          }
          {
            match.class = "^(zenlesszonezero\\.exe)$";
            tag = "+game";
          }
          {
            match.class = "^(.*steam_app.*)$";
            tag = "+game";
          }

          # Rules for games
          {
            match.tag = "game";
            render_unfocused = true;
            fullscreen = true;
            immediate = true;
            idle_inhibit = "always";
          }
        ]
        ++ cfg.windows;

      layer_rule =
        [
          # Configuration for shiny-shell layers
          {
            match.namespace = "^(shiny:.*)$";
            no_anim = true;
          }
        ]
        ++ cfg.layers;

      workspace_rule = cfg.workspaces;
    };
  };
}
