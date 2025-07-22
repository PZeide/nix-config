{
  config,
  lib,
  ...
}: {
  options.zeide.gaming = with lib; {
    exposeNvidiaGpu = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to expose Nvidia GPU to the game (to enable RayTracing and DLSS)";
    };
  };

  imports = [
    ./aagl.nix
    ./gamemode.nix
    ./optimizations.nix
    ./steam.nix
    ./waydroid.nix
  ];

  config = let
    selfConfig = config.zeide.gaming;
  in {
    environment.variables = lib.mkIf selfConfig.exposeNvidiaGpu {
      VKD3D_CONFIG = "dxr11,dxr";
      PROTON_ENABLE_NVAPI = 1;
      PROTON_ENABLE_NGX_UPDATER = 1;
      PROTON_HIDE_NVIDIA_GPU = 0;
    };
  };
}
