{
  asset,
  pkgs,
  ...
}: let
  appLaunchPrefix = "${pkgs.app2unit}/bin/app2unit -s a --";
  wrapAppUnit = app: "${appLaunchPrefix} ${app}";
in {
  home.sessionVariables = {
    # Temp fix for webkitgtk apps
    WEBKIT_DISABLE_DMABUF_RENDERER = 1;
  };

  zeide = {
    graphical = {
      hyprland = {
        enable = true;
        monitors = ["eDP-1, 1920x1080@144, 0x0, 1"];
        keyboardLayout = "us";
        keyboardVariant = "intl";

        perDeviceConfigurations = [
          {
            name = "ite-tech.-inc.-ite-device(8910)-keyboard";
            kb_layout = "fr";
            kb_variant = "";
          }
          {
            name = "elan06fa:00-04f3:31dd-mouse";
            accel_profile = "adpative";
          }
        ];

        binds.extra = [
          "$mainMod, Q, exec, ${wrapAppUnit "kitty"}"
          "$mainMod, E, exec, ${wrapAppUnit "kitty yazi"}"
          "$mainMod, B, exec, ${wrapAppUnit "zen-beta"}"

          "$mainMod, X, togglespecialworkspace, cider"
        ];

        rules = {
          windows = ["match:class ^(Cider)$,"];
          workspaces = ["special:cider, on-created-empty:${wrapAppUnit "cider"}"];
        };

        plugins.hyprsplit.enable = true;
      };
    };

    programs = {
      gaming = {
        bottles.enable = true;
        lunar-client.enable = true;
        mangohud.enable = true;
        osu-lazer.enable = true;

        prism-launcher = {
          enable = true;
          enableAllJdks = true;
        };
      };

      starship.enable = true;

      tui = {
        bluetui.enable = true;
        btop.enable = true;
        lazygit.enable = true;
        nyaa.enable = true;
        rustmission.enable = true;
        wifitui.enable = true;

        yazi = {
          enable = true;
          enableFileChooser = true;

          extraHops = [
            {
              key = "D";
              path = "/mnt/data";
              desc = "Data drive";
            }
          ];
        };
      };

      cli = {
        essentials.enable = true;
        fastfetch.enable = true;
        development.enable = true;
      };

      graphical = {
        loupe = true;
        papers = true;
        cider = true;
        proton-pass = true;
        proton-vpn = true;
        teams = true;
        affinity = true;
        hoppscotch = true;
        beekeeper-studio = true;
        librepods = true;

        webapps = {
          keychronLauncher = true;
          lamzuAurora = true;
        };
      };

      helix.enable = true;
      kitty.enable = true;

      mpv = {
        enable = true;
        useOpenGL = true;
      };

      nix-index.enable = true;
      obs-studio.enable = true;
      vesktop.enable = true;

      zed = {
        enable = true;
        iconTheme.name = "Flow Dark";
      };

      zen-browser.enable = true;
    };

    services = {
      clipboard.enable = true;

      easyeffects = {
        enable = true;
        enableDefaultPreset = true;
      };

      keyring.enable = true;
      polkit-agent.enable = true;
      udiskie.enable = true;
      wakatime.enable = true;

      xdg = {
        enableUserDirs = true;
        execTerminal = "kitty.desktop";
        defaultApps = {
          browser = ["zen.desktop"];
          text = ["Helix.desktop"];
          image = ["org.gnome.Loupe.desktop"];
          audio = ["mpv.desktop"];
          video = ["mpv.desktop"];
          directory = ["yazi-kitty.desktop"];
          office = [];
          pdf = ["org.gnome.Papers.desktop"];
          terminal = ["kitty.desktop"];
          archive = ["yazi-kitty.desktop"];
          discord = ["vesktop.desktop"];
        };
      };
    };

    shell.fish.enable = true;

    theme = {
      wallpaper = asset "wallpapers/vaxry.png";

      gtk.enable = true;
      qt.enable = true;
    };
  };
}
