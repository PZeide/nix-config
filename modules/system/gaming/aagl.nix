{
  config,
  lib,
  inputs,
  ...
}: {
  options.zeide.gaming.aagl = with lib; {
    enableGI = mkEnableOption "gi (through anime-game-launcher)";
    enableHSR = mkEnableOption "HSR (through honkers-railway-launcher)";
    enableZZZ = mkEnableOption "zzz (through sleepy-launcher)";
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
