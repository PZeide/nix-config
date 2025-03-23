{
  lib,
  config,
  system,
  inputs,
  ...
}: {
  options.zeide.graphical.hyprland.plugins = with lib; {
    hyprsplit.enable = mkEnableOption "hyprsplit plugin (recommended)";

    hyprexpo = {
      enable = mkEnableOption "hyprexpo plugin";
      backgroundColor = mkOption {
        type = types.str;
        default = config.lib.stylix.colors.base01;
        description = ''
          Background color shown between windows.
        '';
      };
    };
  };

  config = let
    selfConfig = config.zeide.graphical.hyprland.plugins;
  in {
    wayland.windowManager.hyprland = {
      plugins =
        lib.optional selfConfig.hyprsplit.enable inputs.hyprsplit.packages.${system}.hyprsplit
        ++ lib.optional selfConfig.hyprexpo.enable inputs.hyprland-plugins.packages.${system}.hyprexpo;

      settings.plugin = {
        hyprsplit = lib.mkIf selfConfig.hyprsplit.enable {
          num_workspaces = 9;
          persistent_workspaces = true;
        };

        hyprexpo = lib.mkIf selfConfig.hyprexpo.enable {
          columns = 3;
          gap_size = 4;
          bg_col = "rgb(${selfConfig.hyprexpo.backgroundColor})";

          enable_gesture = true;
          gesture_distance = 300;
          gesture_positive = false;
        };
      };
    };
  };
}
