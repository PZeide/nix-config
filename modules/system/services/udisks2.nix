{
  config,
  lib,
  ...
}: {
  options.zeide.services.udisks2 = with lib; {
    enable = mkEnableOption "udisks2 (required for drive automounting)";
  };

  config = let
    cfg = config.zeide.services.udisks2;
  in
    lib.mkIf cfg.enable {
      services.udisks2.enable = true;
    };
}
