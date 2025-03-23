{
  config,
  lib,
  inputs,
  ...
}: {
  options.zeide.audio = with lib; {
    enable = mkEnableOption "audio support";
    enableLowLatency = mkEnableOption "audio low latency mode";
  };

  imports = [inputs.nix-gaming.nixosModules.pipewireLowLatency];

  config = let
    selfConfig = config.zeide.audio;
  in
    lib.mkIf selfConfig.enable {
      services.pipewire = {
        enable = true;

        pulse.enable = true;
        jack.enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };

        wireplumber.enable = true;

        lowLatency = lib.mkIf selfConfig.enableLowLatency {
          enable = true;
          quantum = 64;
          rate = 48000;
        };
      };

      services.pulseaudio.enable = lib.mkForce false;
    };
}
