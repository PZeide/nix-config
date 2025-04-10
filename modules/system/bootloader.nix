{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  options.zeide.bootloader = with lib; {
    enable = mkEnableOption "bootloader config";

    enableSecureBoot = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable secure boot support.
        Should be enabled after setting up Lanzaboote.
        See: https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md
      '';
    };
  };

  imports = [inputs.lanzaboote.nixosModules.lanzaboote];

  config = let
    selfConfig = config.zeide.bootloader;
  in
    lib.mkIf selfConfig.enable {
      environment.systemPackages = lib.optional selfConfig.enableSecureBoot pkgs.sbctl;

      boot = {
        loader = {
          # Auto-boot default entry (menu still available by pressing Space while booting)
          timeout = 0;

          # Disable systemd-boot if using Lanzaboote
          systemd-boot.enable = !selfConfig.enableSecureBoot;

          efi.canTouchEfiVariables = true;
        };

        lanzaboote = lib.mkIf selfConfig.enableSecureBoot {
          enable = true;
          pkiBundle = "/var/lib/sbctl";
        };
      };
    };
}
