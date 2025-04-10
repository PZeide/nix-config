{
  lib,
  config,
  inputs,
  system,
  ...
}: {
  options.zeide.graphical.hyprland.companions.zeide-shell = with lib; {
    enable = mkEnableOption "zeide-shell powered by ags";
  };

  config = let
    selfConfig = config.zeide.graphical.hyprland.companions.zeide-shell;
  in
    lib.mkIf selfConfig.enable {
      home.packages = [inputs.zeide-shell.packages.${system}.default];
    };
}
