{
  config,
  lib,
  inputs,
  ...
}: {
  options.zeide.gaming.gacha = with lib; {
    enableElysia = mkEnableOption "Elysia launcher (universal)";

    enableGI = mkEnableOption "Genshin Impact (through anime-game-launcher)";
    enableHSR = mkEnableOption "Honkai: Star Rail (through honkers-railway-launcher)";
    enableZZZ = mkEnableOption "Zenless Zone Zero (through sleepy-launcher)";
  };

  imports = [inputs.aagl.nixosModules.default];

  config = let
    cfg = config.zeide.gaming.gacha;
  in {
    environment.systemPackages = lib.optional cfg.enableElysia inputs.elysia.packages.x86_64-linux.default;

    programs.anime-game-launcher.enable = cfg.enableGI;
    programs.honkers-railway-launcher.enable = cfg.enableHSR;
    programs.sleepy-launcher.enable = cfg.enableZZZ;
  };
}
