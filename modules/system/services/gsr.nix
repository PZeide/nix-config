{
  config,
  lib,
  ...
}: {
  options.zeide.services.gsr = with lib; {
    enable = mkEnableOption "gpu screen recorder (+ security wrappers)";
  };

  config = let
    cfg = config.zeide.services.gsr;
  in
    lib.mkIf cfg.enable {
      programs.gpu-screen-recorder.enable = true;
    };
}
