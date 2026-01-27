{
  config,
  lib,
  ...
}: {
  options.zeide.programs.tui.btop = with lib; {
    enable = mkEnableOption "btop (resources monitor)";
  };

  config = let
    cfg = config.zeide.programs.tui.lazygit;
  in
    lib.mkIf cfg.enable {
      programs.btop = {
        enable = true;
      };

      stylix.targets.btop.enable = true;
    };
}
