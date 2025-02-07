variant: {
  inputs,
  config,
  system,
  ...
}: {
  imports = [inputs.home-manager.nixosModules.home-manager];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "hm-backup";

    extraSpecialArgs = {
      inherit inputs variant system;
      inherit (config.age) secrets;

      user = config.system.core.defaultUser;
      homeMod = m: ../../home/${m}.nix;
    };

    users.${config.system.core.defaultUser} = {
      imports = [../../hosts/${variant}/home.nix];

      programs.home-manager.enable = true;

      home = {
        stateVersion = config.system.stateVersion;

        username = config.system.core.defaultUser;
        homeDirectory = "/home/${config.system.core.defaultUser}";
      };
    };
  };
}
