{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:

let
  cfg = config.main.core;
in
{
  options.main.core = with lib; {
    defaultUser = mkOption {
      type = types.str;
      default = "thibaud";
      description = ''
        Name of the default (non-root) user to create.
      '';
    };

    kernel = mkOption {
      type = types.raw;
      default = pkgs.linuxPackages_zen;
      description = ''
        Kernel package.
      '';
    };

    timeZone = mkOption {
      type = types.str;
      default = "Europe/Paris";
      description = ''
        Timezone to configure.
      '';
    };

    defaultLocale = mkOption {
      type = types.str;
      default = "en_US.UTF-8";
      description = ''
        Default locale to configure.
      '';
    };

    consoleKeyMap = mkOption {
      type = types.str;
      default = "us";
      description = ''
        Console (not graphical) keymap to configure.
      '';
    };
  };

  config = {
    system.stateVersion = "24.05";

    hardware.enableRedistributableFirmware = true;
    boot.kernelPackages = cfg.kernel;

    time.timeZone = cfg.timeZone;
    i18n.defaultLocale = cfg.defaultLocale;
    console.keyMap = cfg.consoleKeyMap;

    nixpkgs = {
      config.allowUnfree = true;

      overlays = [ inputs.nur.overlays.default ];
    };

    nix = {
      optimise = {
        automatic = true;
        dates = [ "daily" ];
      };

      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 14d";
      };

      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];

        trusted-users = [ "${cfg.defaultUser}" ];

        substituters = [
          "https://hyprland.cachix.org"
          "https://nix-gaming.cachix.org"
          "https://walker-git.cachix.org"
        ];

        trusted-public-keys = [
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
          "walker-git.cachix.org-1:vmC0ocfPWh0S/vRAQGtChuiZBTAe4wiKDeyyXM0/7pM="
        ];
      };
    };

    users.users."${cfg.defaultUser}" = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };
}
