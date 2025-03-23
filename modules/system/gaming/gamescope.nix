{
  config,
  lib,
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
      programs.gamescope = {
        enable = true;
        capSysNice = true;
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
            "--expose-wayland"
            "--rt"
            "--hdr-enabled"
            "--fullscreen"
            "--generate-drm-mode fixed"
            "--adaptive-sync"
          ]
          ++ lib.optional selfConfig.enableMangoHud "--mangoapp"
          ++ lib.optional config.zeide.gaming.steam.enable "--steam";
      };
    };
}
