{
  asset,
  host,
  system,
  config,
  inputs,
  ...
}: {
  imports = [inputs.home-manager.nixosModules.home-manager];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "hm-prev";

    extraSpecialArgs = {
      inherit asset host system inputs;
      inherit (config.age) secrets;

      homeMod = module: ./home/${module}.nix;
    };

    users.${config.zeide.user} = {
      imports = [
        ./home
        ../hosts/${host}/home.nix
      ];

      programs.home-manager.enable = true;

      home = {
        stateVersion = config.system.stateVersion;

        username = config.zeide.user;
        homeDirectory = "/home/${config.zeide.user}";
      };
    };
  };
}
