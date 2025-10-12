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
      # File swap is required for HybridSleep to work
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
      xpadneo.enable = true;
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

  systemd.services = {
    # ideapad_laptop module automatically softblock bluetooth on boot
    unblock-bluetooth-on-boot = {
      description = "Unblock Bluetooth on boot";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.util-linux}/bin/rfkill unblock bluetooth";
      };
    };

    # mt7921e is slow to resume after suspend so we unload it before suspending
    unload-mt7921e-before-suspend = {
      description = "Unload MT7921E driver before hibernate";
      before = [
        "suspend.target"
        "hibernate.target"
        "hybrid-sleep.target"
        "suspend-then-hibernate.target"
      ];
      wantedBy = [
        "suspend.target"
        "hibernate.target"
        "hybrid-sleep.target"
        "suspend-then-hibernate.target"
      ];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.kmod}/bin/modprobe -r mt7921e";
      };
    };

    # load mt7921e back after resuming
    load-mt7921e-after-resume = {
      description = "Load mediatek driver after resuming";
      after = [
        "suspend.target"
        "hibernate.target"
        "hybrid-sleep.target"
        "suspend-then-hibernate.target"
      ];
      wantedBy = [
        "suspend.target"
        "hibernate.target"
        "hybrid-sleep.target"
        "suspend-then-hibernate.target"
      ];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.kmod}/bin/modprobe mt7921e";
      };
    };
  };
}
