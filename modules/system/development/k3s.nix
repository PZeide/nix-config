{
  config,
  lib,
  pkgs,
  ...
}: {
  options.zeide.development.k3s = with lib; {
    enable = mkEnableOption "k3s (k8s compatible) support";
  };

  config = let
    selfConfig = config.zeide.development.k3s;
  in
    lib.mkIf selfConfig.enable {
      services.k3s = {
        enable = true;
      };
    };
}
