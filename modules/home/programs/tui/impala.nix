{
  config,
  lib,
  pkgs,
  ...
}: {
  options.zeide.programs.tui.impala = with lib; {
    enable = mkEnableOption "impala (wifi manager)";
  };

  config = let
    selfConfig = config.zeide.programs.tui.impala;
  in
    lib.mkIf selfConfig.enable {
      home.packages = [pkgs.impala];
    };
}
