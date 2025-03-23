{
  config,
  lib,
  ...
}: {
  options.zeide.services.udisks2 = with lib; {
    enable = mkEnableOption "udisks2 (required for drive automounting)";
  };

  config = let
    selfConfig = config.zeide.services.udisks2;
  in
    lib.mkIf selfConfig.enable {
      services.udisks2.enable = true;
    };
}
