{pkgs, ...}: {
  zeide = {
    user = "thibaud";

    audio = {
      enable = true;
      enableLowLatency = true;
    };

    bluetooth.enable = true;

    bootloader = {
      enable = true;
      enableSecureBoot = true;
    };

    greeter = {
      enable = true;
      initialSessionCommand = let
        script = pkgs.writeScript "greeter-hyprland-login" ''
          if uwsm check may-start -i -v; then
              exec uwsm start hyprland-uwsm.desktop
          fi
        '';
      in "${script}";
    };

    laptop = {
      enable = true;
      enableTlp = true;
    };

    locale.enable = true;

    network = {
      enable = true;
      enableQuad9Dns = true;
      enableFirewall = true;
    };

    security = {
      enable = true;
      wheelNeedsPassword = false;
    };

    shell.fishIntegration = true;

    swap = {
      # File swap is required for HybridSleep to work
      enableFile = true;
      enableZram = true;
    };

    time = {
      enable = true;
      enableAutomaticTimeZone = true;
    };

    development = {
      podman = {
        enable = true;
        enableAutoPrune = true;
      };
    };

    gaming = {
      exposeNvidiaGpu = true;

      aagl = {
        enableGI = true;
        enableHSR = true;
        enableZZZ = true;
      };

      gamemode.enable = true;

      optimizations.enable = true;
      steam.enable = true;
    };

    graphical = {
      fonts.enable = true;
      hyprland.enable = true;
    };

    nix = {
      enableCudaSupport = true;
      autoOptimiseStore = true;

      nh = {
        enable = true;
        enableClean = true;
      };
    };

    services = {
      ios.enable = true;

      keyring = {
        enable = true;
        unlockServices = ["hyprlock"];
      };

      location.enable = true;
      openssh.enable = true;

      transmission = {
        enable = true;
        symlinkDownloads = true;
      };

      udisks2.enable = true;
    };
  };
}
