{
  config,
  lib,
  ...
}: {
  options.zeide.gaming.gamemode = with lib; {
    enable = mkEnableOption "gamemode integration";
  };

  config = let
    cfg = config.zeide.gaming.gamemode;
  in
    lib.mkIf cfg.enable {
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

      users.users.${config.zeide.user} = {
        extraGroups = ["gamemode"];
      };
    };
}
