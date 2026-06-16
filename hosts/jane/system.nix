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
      user = "thibaud";
      session = "hyprland-uwsm";
    };

    laptop = {
      enable = true;
      enableTlp = true;
    };

    locale.enable = true;

    network = {
      enable = true;
      enableWireless = true;
      enableCloudflareDns = true;
      enableFirewall = true;
    };

    security = {
      enable = true;
      wheelNeedsPassword = false;
    };

    shell.fishIntegration = true;

    swap = {
      enableFile = true;
      enableZram = true;
    };

    time = {
      enable = true;
      enableAutomaticTimeZone = true;
    };

    udev = {
      keychron = true;
      lamzu = true;
      heightbitdo = true;
    };

    development = {
      podman = {
        enable = true;
        enableAutoPrune = true;
      };
    };

    gaming = {
      useCachyKernel = true;
      exposeNvidiaGpu = true;

      gacha = {
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
      enableRocmSupport = true;
      autoOptimiseStore = true;

      nh = {
        enable = true;
        enableClean = true;
      };
    };

    services = {
      anime = {
        enable = false; # FIXME NEED FIX ASAP DB ERROR
        symlinkAnimes = true;
        anilistUsername = "Zeide";
      };

      ios.enable = true;
      gsr.enable = true;
      keyring.enable = true;
      location.enable = true;
      openssh.enable = true;

      transmission = {
        enable = true;
        symlinkDownloads = true;
      };

      udisks2.enable = true;
    };
  };

  systemd.services.rfkill-unblock-bluetooth = {
    description = "Unblock Bluetooth on boot and resume";
    after = ["multi-user.target"];
    wantedBy = ["multi-user.target"];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.util-linux}/bin/rfkill unblock bluetooth";
      Restart = "no";
    };
  };
}
