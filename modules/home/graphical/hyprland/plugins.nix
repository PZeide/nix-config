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
      extraLuaFiles = {
        "hyprsplit/init" = lib.mkIf cfg.hyprsplit.enable {
          autoLoad = false;
          content = builtins.readFile "${inputs.hyprsplit}/init.lua";
        };

        "hyprsplit/load" = lib.mkIf cfg.hyprsplit.enable {
          autoLoad = true;
          content = ''
            hs = require("hyprsplit")

            hs.config({
              num_workspaces = 10,
              persistent_workspaces = true,
            })
          '';
        };
      };

      plugins =
        lib.optional cfg.hypr-dynamic-cursors.enable inputs.hypr-dynamic-cursors.packages.${system}.hypr-dynamic-cursors;

      settings.config.plugin = {
        dynamic-cursors = lib.mkIf cfg.hypr-dynamic-cursors.enable {
          enable = true;
          mode = "tilt";

          hyprcursor.enabled = true;
          shake.enabled = false;
        };
      };
    };
  };
}
