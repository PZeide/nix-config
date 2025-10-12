{
  config,
  lib,
  ...
}: {
  options.zeide.gaming.xpadneo = with lib; {
    enable = mkEnableOption "xpadneo module";
  };

  config = let
    selfConfig = config.zeide.gaming.xpadneo;
  in
    lib.mkIf selfConfig.enable {
      hardware.xpadneo.enable = true;
    };
}
