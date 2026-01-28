{
  lib,
  config,
  system,
  inputs,
  ...
}: {
  options.zeide.graphical.hyprland.plugins = with lib; {
    hyprsplit.enable = mkEnableOption "hyprsplit plugin (recommended)";
    hypr-dynamic-cursors.enable = mkEnableOption "hyprdynamiccursor plugin";
  };

  config = let
    cfg = config.zeide.graphical.hyprland.plugins;
  in {
    wayland.windowManager.hyprland = {
      plugins =
        lib.optional cfg.hyprsplit.enable inputs.hyprsplit.packages.${system}.hyprsplit
        ++ lib.optional cfg.hypr-dynamic-cursors.enable inputs.hypr-dynamic-cursors.packages.${system}.hypr-dynamic-cursors;

      settings.plugin = {
        hyprsplit = lib.mkIf cfg.hyprsplit.enable {
          num_workspaces = 10;
          persistent_workspaces = true;
        };

        dynamic-cursors = lib.mkIf cfg.hypr-dynamic-cursors.enable {
          enable = true;
          mode = "tilt";
          hyprcursor.enabled = true;
        };
      };
    };
  };
}
