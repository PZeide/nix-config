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
    ./gacha.nix
    ./gamemode.nix
    ./optimizations.nix
    ./steam.nix
  ];

  config = let
    cfg = config.zeide.gaming;
  in {
    environment.variables = lib.mkIf cfg.exposeNvidiaGpu {
      WINE_HIDE_NVIDIA_GPU = 0;
      PROTON_HIDE_NVIDIA_GPU = 0;
    };
  };
}
