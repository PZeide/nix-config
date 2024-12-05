{
  boot.loader = {
    # Auto-boot default entry (still available by pressing Space while booting)
    timeout = 0;

    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
}
