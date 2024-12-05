{
  inputs,
  lib,
  pkgs,
  ...
}:

{
  imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

  boot = {
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };

    # Disable systemd-boot because we will be using lanzaboot
    loader.systemd-boot.enable = lib.mkForce false;
  };

  environment.systemPackages = [ pkgs.sbctl ];
}
