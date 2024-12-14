{
  mod,
  home,
  system,
  ...
}:

{
  nixpkgs.hostPlatform = system;
  networking.hostName = "nilou";

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
    (mod "misc/nautilus-helpers")
    (mod "misc/podman")
    (mod "misc/ios")
    (mod "misc/openssh")

    (home "nilou")
  ];
}
