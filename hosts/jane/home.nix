{
  asset,
  lib,
  pkgs,
  ...
}: let
  appLaunchPrefix = "${pkgs.app2unit}/bin/app2unit -s a --";
  wrapAppUnit = app: "${appLaunchPrefix} ${app}";

  bind = key: dispatcher: {
    _args = [
      key
      (lib.generators.mkLuaInline dispatcher)
    ];
  };
in {
  home.sessionVariables = {
    # Temp fix for webkitgtk apps
    WEBKIT_DISABLE_DMABUF_RENDERER = 1;
  };

  zeide = {
    graphical = {
      hyprland = {
        enable = true;

        monitors = [
          {
            output = "eDP-1";
            mode = "1920x1080@144";
            position = "0x0";
            scale = 1;
          }
        ];

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
          (bind "SUPER + Q" ''hl.dsp.exec_cmd("${wrapAppUnit "kitty"}")'')
          (bind "SUPER + E" ''hl.dsp.exec_cmd("${wrapAppUnit "kitty yazi"}")'')
          (bind "SUPER + B" ''hl.dsp.exec_cmd("${wrapAppUnit "zen-beta"}")'')

          (bind "SUPER + X" ''hl.dsp.workspace.toggle_special("cider")'')
        ];

        rules = {
          workspaces = [
            {
              workspace = "special:cider";
              on_created_empty = wrapAppUnit "cider";
            }
          ];
        };

        plugins = {
          hyprsplit.enable = true;
          hypr-dynamic-cursors.enable = false;
        };
      };
    };

    programs = {
      gaming = {
        mangohud.enable = true;
        osu-lazer.enable = true;

        prism-launcher = {
          enable = true;
          enableAllJdks = true;
        };

        wine-utils.enable = true;
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
        };
      };

      cli = {
        essentials.enable = true;
        fastfetch.enable = true;

        development = {
          enable = true;
          enableAzureCli = true;
        };
      };

      graphical = {
        loupe = true;
        papers = true;
        cider = true;
        proton-pass = true;
        proton-vpn = true;
        teams = true;
        bruno = true;
        dbeaver = true;
        onlyoffice = true;

        webapps = {
          keychronLauncher = true;
          lamzuAurora = true;
        };
      };

      helix.enable = true;

      jetbrains = {
        idea.enable = true;
        datagrip.enable = true;
      };

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

        theme = {
          name = "Vitesse Refined Dark";
          extension = "vitesse-theme-refined";
        };

        iconTheme.name = "Flow Deep";
      };

      zen-browser.enable = true;
    };

    services = {
      clipboard.enable = true;
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
      face = asset "theme/denia/face.png";
      wallpaper = asset "theme/denia/wallpaper.jpg";
      scheme = "content";

      gtk.enable = true;
      qt.enable = true;
    };
  };
}
