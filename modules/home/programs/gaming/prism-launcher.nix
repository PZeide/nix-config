{
  config,
  lib,
  pkgs,
  ...
}: {
  options.zeide.programs.gaming.prism-launcher = with lib; {
    enable = mkEnableOption "prism-launcher minecraft client";
    enableAllJdks = mkEnableOption "all jdks required to run all minecraft versions";
  };

  config = let
    cfg = config.zeide.programs.gaming.prism-launcher;
  in
    lib.mkIf cfg.enable {
      home.packages = with pkgs; [
        (prismlauncher.override {
          gamemodeSupport = true;

          jdks = lib.optionals cfg.enableAllJdks [
            zulu8
            zulu17
            zulu
          ];
        })
      ];
    };
}
