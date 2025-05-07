{
  config,
  lib,
  ...
}: {
  options.zeide.gaming.gamemode = with lib; {
    enable = mkEnableOption "gamemode integration";
  };

  config = let
    selfConfig = config.zeide.gaming.gamemode;
  in
    lib.mkIf selfConfig.enable {
      programs.gamemode = {
        enable = true;
        enableRenice = true;

        settings = {
          general = {
            renice = 20;
            inhibit_screensaver = 1;
          };
        };
      };
    };
}
