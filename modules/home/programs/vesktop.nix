{
  config,
  lib,
  inputs,
  ...
}: {
  options.zeide.programs.vesktop = with lib; {
    enable = mkEnableOption "vesktop";
  };

  imports = [
    inputs.nixcord.homeModules.nixcord
  ];

  config = let
    selfConfig = config.zeide.programs.vesktop;
  in
    lib.mkIf selfConfig.enable {
      programs.nixcord = {
        enable = true;
        discord.enable = false;
        vesktop.enable = true;
      };

      stylix.targets.nixcord.enable = true;
    };
}
