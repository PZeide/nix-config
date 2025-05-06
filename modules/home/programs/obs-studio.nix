{
  config,
  lib,
  pkgs,
  ...
}: {
  options.zeide.programs.obs-studio = with lib; {
    enable = mkEnableOption "obs-studio";
    enableAlsaSupport = mkEnableOption "alsa in/out support";
    enablePulseaudioSupport = mkEnableOption "pulseaudio in/out support";
  };

  config = let
    selfConfig = config.zeide.programs.obs-studio;
  in
    lib.mkIf selfConfig.enable {
      programs.obs-studio = {
        enable = true;

        package = pkgs.obs-studio.override {
          # cuda support is managed by config.cudaSupport (system wide)
          alsaSupport = selfConfig.enableAlsaSupport;
          pulseaudioSupport = selfConfig.enablePulseaudioSupport;
        };

        plugins = with pkgs.obs-studio-plugins; [
          obs-vkcapture
          obs-pipewire-audio-capture
          obs-vaapi
        ];
      };
    };
}
