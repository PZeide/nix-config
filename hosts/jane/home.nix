{
  asset,
  lib,
  pkgs,
  inputs,
  system,
  ...
}: {
  zeide = {
    theme = {
      wallpaper = asset "wallpapers/jane-2.jpg";
      polarity = "dark";

      gtk = {
        enable = true;
        iconFlavor = "mocha";
        iconAccent = "red";
      };
    };

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

        binds.extra = let
          wrapAppUnit = app: "${lib.getExe pkgs.app2unit} -s a -- ${app}";
        in [
          "$mainMod, Q, exec, ${wrapAppUnit "kitty"}"
          "$mainMod, E, exec, ${wrapAppUnit "nautilus"}"
          "$mainMod, B, exec, ${wrapAppUnit "zen-beta"}"
        ];

        plugins = {
          hyprsplit.enable = true;
          hyprexpo.enable = true;
        };

        companions = {
          hyprpaper.enable = true;
          hypridle.enable = true;
          hyprlock = {
            enable = true;
            autostartOnGraphical = true;
          };
          hyprpicker.enable = true;
          zeide-shell.enable = true;
        };
      };
    };

    shell.fish.enable = true;

    programs = {
      cli = {
        essentials.enable = true;
        fastfetch.enable = true;
        development.enable = true;
      };

      helix = {
        enable = true;
        theme = builtins.fromTOML (builtins.readFile (asset "helix/themes/kaolin-dark-transparent.toml"));
      };

      kitty.enable = true;

      nautilus = {
        enable = true;
        openTerminalAction = "kitty";
        bookmarks = ["file:///mnt/data"];
      };

      vscodium = {
        enable = true;

        colorTheme = {
          name = "Bearded Theme Black & Ruby";
          package = inputs.nix-vscode-extensions.extensions.${system}.vscode-marketplace.beardedbear.beardedtheme;
        };

        iconTheme = {
          name = "bearded-icons";
          package = inputs.nix-vscode-extensions.extensions.${system}.vscode-marketplace.beardedbear.beardedicons;
        };
      };

      zen-browser.enable = true;
    };

    services = {
      clipboard.enable = true;
      keyring.enable = true;
      udiskie.enable = true;
      wakatime.enable = true;
    };
  };
}
