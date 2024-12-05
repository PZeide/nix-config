{ config, lib, ... }:

let
  cfg = config.home.hyprland;
in
{
  imports = [
    ./hyprland/general.nix
    ./hyprland/binds.nix
    ./hyprland/rules.nix
    ./hyprland/plugins.nix
  ];

  options.home.hyprland = with lib; {
    monitors = mkOption {
      type = types.listOf types.str;
      default = [ ", preferred, auto, 1" ];
      description = ''
        Monitors configuration of Hyprland.
      '';
    };
  };

  config = {
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;

      systemd = {
        enable = true;
        variables = [ "--all" ];

        enableXdgAutostart = true;
      };

      settings = {
        monitor = cfg.monitors ++ [ ", preferred, auto, 1" ];
      };
    };

    # Hint Electron apps to use Wayland
    home.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
