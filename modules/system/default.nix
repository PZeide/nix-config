{
  host,
  config,
  lib,
  pkgs,
  ...
}: {
  options.zeide = with lib; {
    user = mkOption {
      type = types.str;
      default = "thibaud";
      description = ''
        Name of the (non-root) user to create.
      '';
    };

    description = mkOption {
      type = types.str;
      default = "Thibaud";
      description = ''
        Description of the (non-root) user to create.
        Typically the user full name.
      '';
    };
  };

  imports = [
    ./development
    ./gaming
    ./graphical
    ./nix
    ./services
    ./audio.nix
    ./bluetooth.nix
    ./bootloader.nix
    ./greeter.nix
    ./laptop.nix
    ./locale.nix
    ./network.nix
    ./security.nix
    ./shell.nix
    ./swap.nix
    ./time.nix
    ./udev.nix
  ];

  config = let
    selfConfig = config.zeide;
  in {
    system.stateVersion = "24.05";

    networking.hostName = host;
    hardware.enableRedistributableFirmware = true;
    boot.kernelPackages = pkgs.linuxPackages_latest;

    users.users.${selfConfig.user} = {
      isNormalUser = true;
      description = selfConfig.description;
      extraGroups = ["wheel"];
    };

    # git is required for flakes to work so here it is
    programs.git.enable = true;
  };
}
