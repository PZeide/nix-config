{
  config,
  lib,
  ...
}: {
  options.zeide.swap = with lib; {
    enable = mkEnableOption "swap (zram-swap) config";
  };

  config = let
    selfConfig = config.zeide.swap;
  in
    lib.mkIf selfConfig.enable {
      zramSwap = {
        enable = true;
        algorithm = "lz4";
        memoryPercent = 50;
      };

      # Recommended settings from https://wiki.archlinux.org/title/Zram
      boot.kernel.sysctl = {
        "vm.swappiness" = 180;
        "vm.watermark_boost_factor" = 0;
        "vm.watermark_scale_factor" = 125;
        "vm.page-cluster" = 0;
      };
    };
}
