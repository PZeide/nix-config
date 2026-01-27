{
  lib,
  config,
  system,
  inputs,
  ...
}: {
  options.zeide.graphical.hyprland.plugins = with lib; {
    hyprsplit.enable = mkEnableOption "hyprsplit plugin (recommended)";
  };

  config = let
    cfg = config.zeide.graphical.hyprland.plugins;
  in {
    wayland.windowManager.hyprland = {
      plugins = lib.optional cfg.hyprsplit.enable inputs.hyprsplit.packages.${system}.hyprsplit;

      settings.plugin = {
        hyprsplit = lib.mkIf cfg.hyprsplit.enable {
          num_workspaces = 10;
          persistent_workspaces = true;
        };
      };
    };
  };
}
