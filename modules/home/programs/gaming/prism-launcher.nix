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
    selfConfig = config.zeide.programs.gaming.prism-launcher;
  in
    lib.mkIf selfConfig.enable {
      home.packages = with pkgs; [
        (prismlauncher.override {
          gamemodeSupport = true;
          glfw3-minecraft = pkgs.glfw-wayland-minecraft;

          jdks = lib.optionals selfConfig.enableAllJdks [
            zulu8
            zulu17
            zulu
          ];
        })
      ];
    };
}
