{
  config,
  lib,
  ...
}: {
  options.zeide.programs.gaming.mangohud = with lib; {
    enable = mkEnableOption "mangohud";
  };

  config = let
    selfConfig = config.zeide.programs.gaming.mangohud;
  in
    lib.mkIf selfConfig.enable {
      programs.mangohud = {
        enable = true;

        settings = {
          no_display = true;
          preset = 3;
        };
      };
    };
}
