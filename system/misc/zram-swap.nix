{
  zramSwap = {
    enable = true;
    algorithm = "lz4";
    memoryPercent = 150;
  };

  # Recommended settings from https://wiki.archlinux.org/title/Zram
  boot.kernel.sysctl = {
    "vm.swappiness" = 180;
    "vm.watermark_boost_factor" = 0;
    "vm.watermark_scale_factor" = 125;
    "vm.page-cluster" = 0;
  };
}
