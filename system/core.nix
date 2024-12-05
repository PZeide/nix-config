{
  config,
  lib,
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

    nixpkgs.config.allowUnfree = true;
    hardware.enableRedistributableFirmware = true;
    boot.kernelPackages = cfg.kernel;

    time.timeZone = cfg.timeZone;
    i18n.defaultLocale = cfg.defaultLocale;
    console.keyMap = cfg.consoleKeyMap;

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
      };
    };

    users.users."${cfg.defaultUser}" = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };
}
