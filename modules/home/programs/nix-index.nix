{
  config,
  lib,
  inputs,
  ...
}: {
  options.zeide.programs.nix-index = with lib; {
    enable = mkEnableOption "nix-index database and comma";
  };

  imports = [inputs.nix-index-database.homeModules.nix-index];

  config = let
    selfConfig = config.zeide.programs.nix-index;
  in
    lib.mkIf selfConfig.enable {
      programs = {
        nix-index.enable = true;
        nix-index-database.comma.enable = true;
      };
    };
}
