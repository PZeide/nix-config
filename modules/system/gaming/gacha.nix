{
  config,
  lib,
  inputs,
  ...
}: {
  options.zeide.gaming.gacha = with lib; {
    enableGI = mkEnableOption "Genshin Impact (through anime-game-launcher)";
    enableHSR = mkEnableOption "Honkai: Star Rail (through honkers-railway-launcher)";
    enableZZZ = mkEnableOption "Zenless Zone Zero (through sleepy-launcher)";
  };

  imports = [inputs.aagl.nixosModules.default];

  config = let
    cfg = config.zeide.gaming.gacha;
  in {
    programs.anime-game-launcher.enable = cfg.enableGI;
    programs.honkers-railway-launcher.enable = cfg.enableHSR;
    programs.sleepy-launcher.enable = cfg.enableZZZ;
  };
}
