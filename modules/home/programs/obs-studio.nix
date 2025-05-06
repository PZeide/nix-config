{
  config,
  lib,
  pkgs,
  ...
}: {
  options.zeide.programs.obs-studio = with lib; {
    enable = mkEnableOption "obs-studio";
  };

  config = let
    selfConfig = config.zeide.programs.obs-studio;
  in
    lib.mkIf selfConfig.enable {
      programs.obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [
          obs-vkcapture
          obs-pipewire-audio-capture
          obs-vaapi
        ];
      };
    };
}
