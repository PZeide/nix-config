{
  config,
  lib,
  ...
}: {
  options.zeide.theme.qt = with lib; {
    enable = mkEnableOption "qt theming support";
  };

  config = let
    cfg = config.zeide.theme.qt;
  in
    lib.mkIf cfg.enable {
      stylix.targets.qt.enable = true;
    };
}
