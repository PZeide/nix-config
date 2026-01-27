{
  config,
  lib,
  ...
}: {
  options.zeide.nix.nh = with lib; {
    enable = mkEnableOption "nh utility";
    enableClean = mkEnableOption "nh automatic cleaning tool (running daily)";
  };

  config = let
    cfg = config.zeide.nix.nh;
  in
    lib.mkIf cfg.enable {
      programs.nh = {
        enable = true;
        clean = lib.mkIf cfg.enableClean {
          enable = true;
          dates = "daily";
          extraArgs = "--keep-since 30d";
        };
      };
    };
}
