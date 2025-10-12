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
    selfConfig = config.zeide.graphical.hyprland.plugins;
  in {
    wayland.windowManager.hyprland = {
      plugins =
        lib.optional selfConfig.hyprsplit.enable inputs.hyprsplit.packages.${system}.hyprsplit;

      settings.plugin = {
        hyprsplit = lib.mkIf selfConfig.hyprsplit.enable {
          num_workspaces = 9;
          persistent_workspaces = true;
        };
      };
    };
  };
}
