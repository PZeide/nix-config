{ lib, ... }:

{
  imports = [
    ./hyprland/general.nix
    ./hyprland/binds.nix
    ./hyprland/rules.nix
    ./hyprland/plugins.nix
  ];

  options.home.hyprland = with lib; {
    monitors = mkOption {
      type = with types; listOf str;
      default = [ ", preferred, auto, 1" ];
      description = ''
        Monitors configuration of Hyprland.
      '';
    };

    backlightBinds = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable backlight controls binds.
      '';
    };
  };

  config = {
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    # Hint Electron apps to use Wayland
    home.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
