{
  config,
  lib,
  ...
}: {
  options.zeide.graphical.hyprland.gestures = with lib; {
    extra = mkOption {
      type = with types; listOf str;
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
          "3, horizontal, workspace"
        ]
        ++ cfg.extra;
    };
  };
}
