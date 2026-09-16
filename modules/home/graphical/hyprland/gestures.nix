{
  config,
  lib,
  ...
}: {
  options.zeide.graphical.hyprland.gestures = with lib; {
    extra = mkOption {
      type = with types; listOf attrs;
      default = [];
      description = ''
        Extra gestures.
      '';
    };
  };

  config = let
    cfg = config.zeide.graphical.hyprland.gestures;
  in {
    wayland.windowManager.hyprland.settings = {
      gesture =
        [
          {
            fingers = 3;
            direction = "horizontal";
            action = "workspace";
          }
        ]
        ++ cfg.extra;
    };
  };
}
