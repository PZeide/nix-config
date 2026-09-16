{
  config,
  lib,
  ...
}: {
  options.zeide.swap = with lib; {
    enableFile = mkEnableOption "file swap";
    enableZram = mkEnableOption "zram swap";
  };

  config = let
    cfg = config.zeide.swap;
  in {
    swapDevices = lib.mkIf cfg.enableFile [
      {
        device = "/var/lib/swapfile";
        size = 4 * 1024;
        priority = 10;
      }
    ];

    zramSwap = lib.mkIf cfg.enableZram {
      enable = true;
      algorithm = "lz4";
      memoryPercent = 50;
      priority = 20;
    };

    # Recommended settings from https://wiki.archlinux.org/title/Zram
    boot.kernel.sysctl = lib.mkIf cfg.enableZram {
      "vm.swappiness" = 180;
      "vm.watermark_boost_factor" = 0;
      "vm.watermark_scale_factor" = 125;
      "vm.page-cluster" = 0;
    };
  };
}
