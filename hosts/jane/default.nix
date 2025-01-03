{
  mod,
  home,
  system,
  ...
}:

{
  nixpkgs.hostPlatform = system;
  networking.hostName = "jane";

  imports = [
    ./hardware.nix
    (mod "core")

    (mod "boot/default")
    (mod "boot/secure-boot")

    (mod "network/default")
    (mod "network/cloudflare-dns")
    (mod "network/firewall")

    (mod "bluetooth/default")

    (mod "audio/default")
    (mod "audio/low-latency")

    (mod "greet/default")
    (mod "greet/hyprland")

    (mod "graphical/hyprland")

    (mod "gaming/optimizations")
    (mod "gaming/apps")

    (mod "shell/fish")

    (mod "misc/zram-swap")
    (mod "misc/secrets")
    (mod "misc/security")
    (mod "misc/backlight")
    (mod "misc/nautilus-helpers")
    (mod "misc/podman")
    (mod "misc/waydroid")
    (mod "misc/ios")
    (mod "misc/openssh")
    (mod "misc/udisks2")

    (mod "laptop/tlp")

    (home "jane")
  ];
}
