variant:
{
  inputs,
  config,
  system,
  ...
}:

{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "hm-backup";

    extraSpecialArgs = {
      inherit inputs variant system;
      user = "${config.main.core.defaultUser}";
      homeMod = m: ../../home/${m}.nix;
    };

    users."${config.main.core.defaultUser}" = {
      imports = [ ../../hosts/${variant}/home.nix ];

      programs.home-manager.enable = true;

      home = {
        stateVersion = config.system.stateVersion;

        username = "${config.main.core.defaultUser}";
        homeDirectory = "/home/${config.main.core.defaultUser}";
      };
    };
  };
}
