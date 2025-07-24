{
  config,
  lib,
  ...
}: {
  options.zeide.programs.tui.btop = with lib; {
    enable = mkEnableOption "btop (resources monitor)";
  };

  config = let
    selfConfig = config.zeide.programs.tui.lazygit;
  in
    lib.mkIf selfConfig.enable {
      programs.btop = {
        enable = true;
      };

      stylix.targets.btop.enable = true;
    };
}
