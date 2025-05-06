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

    exposeNvidiaGpu = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to expose Nvidia GPU to the game (to enable RayTracing and DLSS)";
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

      programs.gamescope = {
        enable = true;
        capSysNice = true;
        env =
          {
            # FIXME Remove when fixed on stable nvidia
            VKD3D_DISABLE_EXTENSIONS = "VK_KHR_present_wait";
          }
          // lib.mkIf selfConfig.useNvidiaPrime {
            __NV_PRIME_RENDER_OFFLOAD = "1";
            __VK_LAYER_NV_optimus = "NVIDIA_only";
            __GLX_VENDOR_LIBRARY_NAME = "nvidia";
          }
          // lib.mkIf selfConfig.exposeNvidiaGpu {
            PROTON_HIDE_NVIDIA_GPU = 0;
            PROTON_ENABLE_NVAPI = 1;
            PROTON_ENABLE_NGX_UPDATER = 1;
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
          ++ lib.optional selfConfig.enableMangoHud "--mangoapp"
          ++ lib.optional config.zeide.gaming.steam.enable "--steam";
      };
    };
}
