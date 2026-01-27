{
  config,
  lib,
  ...
}: {
  options.zeide.programs.gaming.mangohud = with lib; {
    enable = mkEnableOption "mangohud";
  };

  config = let
    cfg = config.zeide.programs.gaming.mangohud;
  in
    lib.mkIf cfg.enable {
      programs.mangohud = {
        enable = true;

        settings = {
          no_display = true;
          preset = 3;
        };
      };
    };
}
