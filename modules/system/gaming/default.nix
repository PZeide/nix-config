{
  config,
  lib,
  pkgs,
  ...
}: {
  options.zeide.gaming = with lib; {
    useCachyKernel = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to use the CachyOS optimized kernel";
    };

    exposeNvidiaGpu = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to expose Nvidia GPU to the game (to enable RayTracing and DLSS)";
    };
  };

  imports = [
    ./gacha.nix
    ./gamemode.nix
    ./optimizations.nix
    ./steam.nix
  ];

  config = let
    cfg = config.zeide.gaming;
  in {
    boot.kernelPackages = lib.mkIf cfg.useCachyKernel (lib.mkForce pkgs.cachyosKernels.linuxPackages-cachyos-latest);

    environment.variables = lib.mkIf cfg.exposeNvidiaGpu {
      WINE_HIDE_NVIDIA_GPU = 0;
      PROTON_HIDE_NVIDIA_GPU = 0;
    };
  };
}
