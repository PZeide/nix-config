{
  config,
  lib,
  pkgs,
  ...
}: {
  options.zeide.programs.jetbrains = with lib; {
    idea.enable = mkEnableOption "intellij idea";
    datagrip.enable = mkEnableOption "datagrip";
  };

  config = let
    cfg = config.zeide.programs.jetbrains;
  in {
    home.packages = lib.optional cfg.idea.enable pkgs.jetbrains.idea
      ++ lib.optional cfg.datagrip.enable pkgs.jetbrains.datagrip;
  };
}
