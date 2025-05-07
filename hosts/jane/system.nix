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
    swap.enable = true;

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
      gamemode.enable = true;

      gamescope = {
        enable = true;
        enableMangoHud = true;
        useNvidiaPrime = true;
        exposeNvidiaGpu = true;

        gamescopeWidth = 1920;
        gamescopeHeight = 1080;
        gamescopeRefreshRate = 144;
      };

      optimizations.enable = true;
      steam.enable = true;
      waydroid.enable = true;
    };

    graphical = {
      fonts.enable = true;
      hyprland.enable = true;
    };

    nix = {
      useLix = true;
      enableCudaSupport = true;
      autoOptimiseStore = true;

      nh = {
        enable = true;
        enableClean = true;
      };
    };

    services = {
      gnome = {
        enableGvfs = true;
        enablePolkit = true;
        enableKeyring = true;
        unlockKeyringServices = ["hyprlock"];
        fixNautilusExtensions = true;
      };

      ios.enable = true;
      location.enable = true;
      openssh.enable = true;
      udisks2.enable = true;
    };
  };
}
