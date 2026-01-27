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
              exec uwsm start -eD Hyprland hyprland.desktop
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
      exposeNvidiaGpu = true;

      gacha = {
        enableElysia = true;
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
        enable = true;
        symlinkAnimes = true;
        anilistUsername = "Zeide";
      };

      ios.enable = true;
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

  powerManagement = {
    powerUpCommands = ''
      ${pkgs.util-linux}/bin/rfkill unblock bluetooth
    '';
  };
}
