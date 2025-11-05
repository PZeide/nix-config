{
  asset,
  pkgs,
  ...
}: let
  appLaunchPrefix = "${pkgs.app2unit}/bin/app2unit -s a --";
  wrapAppUnit = app: "${appLaunchPrefix} ${app}";
in {
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
          "$mainMod, HOME, exec, ${wrapAppUnit "screenshot region"}"
          "$mainMod SHIFT, HOME, exec, ${wrapAppUnit "screenshot window"}"

          "$mainMod, TAB, global, shiny-shell:overview-toggle"
          "$mainMod, SPACE, global, shiny-shell:launcher-toggle"
          "$mainMod, Q, exec, ${wrapAppUnit "kitty"}"
          "$mainMod, E, exec, ${wrapAppUnit "kitty yazi"}"
          "$mainMod, B, exec, ${wrapAppUnit "zen-beta"}"

          "$mainMod, X, togglespecialworkspace, cider"
        ];

        rules = {
          windows = ["workspace special:cider, class:^(Cider)$"];
          workspaces = ["special:cider, on-created-empty:${wrapAppUnit "cider"}"];
        };

        plugins.hyprsplit.enable = true;

        companions = {
          hyprpicker.enable = true;
          screenshot.enable = true;
          shiny-shell.enable = true;
        };
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
        impala.enable = true;
        lazygit.enable = true;
        nyaa.enable = true;
        rustmission.enable = true;

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

      vscodium = {
        enable = true;

        colorTheme = {
          name = "Bearded Theme Black & Ruby";
          extension = "BeardedBear.beardedtheme";
        };
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

      /*
        librepods = {
        enable = true;
        phoneMacAddress = "28:2D:7F:DF:BC:76";
      };
      */

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
          directory = ["yazi.desktop"];
          office = [];
          pdf = ["org.gnome.Papers.desktop"];
          terminal = ["kitty.desktop"];
          archive = ["yazi.desktop"];
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
