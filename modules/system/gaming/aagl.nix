{
  config,
  lib,
  inputs,
  ...
}: {
  options.zeide.gaming.aagl = with lib; {
    enableGI = mkEnableOption "Genshin Impact (through anime-game-launcher)";
    enableHSR = mkEnableOption "Honkai: Star Rail (through honkers-railway-launcher)";
    enableZZZ = mkEnableOption "Zenless Zone Zero (through sleepy-launcher)";
  };

  imports = [inputs.aagl.nixosModules.default];

  config = let
    selfConfig = config.zeide.gaming.aagl;
  in {
    programs.anime-game-launcher.enable = selfConfig.enableGI;
    programs.sleepy-launcher.enable = selfConfig.enableHSR;
    programs.honkers-railway-launcher.enable = selfConfig.enableZZZ;
  };
}
