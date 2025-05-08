{
  config,
  lib,
  pkgs,
  ...
}: {
  options.zeide.gaming.gamescope = with lib; {
    enable = mkEnableOption "gamescope session";
    enableMangoHud = mkEnableOption "enable mangohud inside gamescope session";

    useNvidiaPrime = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to use nvidia prime in gamescope session";
    };

    gamescopeWidth = mkOption {
      type = types.int;
      default = 1920;
      description = "Gamescope session width (also applied to game)";
    };

    gamescopeHeight = mkOption {
      type = types.int;
      default = 1080;
      description = "Gamescope session width (also applied to game)";
    };

    gamescopeRefreshRate = mkOption {
      type = types.int;
      default = 60;
      description = "Game refresh rate";
    };
  };

  config = let
    selfConfig = config.zeide.gaming.gamescope;
  in
    lib.mkIf selfConfig.enable {
      environment.systemPackages = with pkgs; [mangohud];

      # FIXME Use ananicy because gamescope can't manage it's own niceness
      services.ananicy = {
        enable = true;
        package = pkgs.ananicy-cpp;
        rulesProvider = pkgs.ananicy-cpp;
        extraRules = [
          {
            "name" = "gamescope";
            "nice" = -20;
          }
        ];
      };

      programs.gamescope = {
        enable = true;
        capSysNice = false;

        env = lib.mkIf selfConfig.useNvidiaPrime {
          __NV_PRIME_RENDER_OFFLOAD = "1";
          __VK_LAYER_NV_optimus = "NVIDIA_only";
          __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        };

        args =
          [
            "-w ${toString selfConfig.gamescopeWidth}"
            "-h ${toString selfConfig.gamescopeHeight}"
            "-W ${toString selfConfig.gamescopeWidth}"
            "-H ${toString selfConfig.gamescopeHeight}"
            "-r ${toString selfConfig.gamescopeRefreshRate}"
            # FIXME Use SDL backend instead of Wayland: https://github.com/ValveSoftware/gamescope/issues/1669
            "--backend sdl"
            "--rt"
            "--fullscreen"
            "--generate-drm-mode fixed"
            "--adaptive-sync"
          ]
          ++ lib.optional selfConfig.enableMangoHud "--mangoapp";
      };
    };
}
