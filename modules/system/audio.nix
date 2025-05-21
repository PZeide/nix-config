{
  config,
  lib,
  inputs,
  pkgs,
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
      environment.systemPackages = [pkgs.playerctl];

      services.pipewire = {
        enable = true;

        pulse.enable = true;
        jack.enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };

        wireplumber.enable = true;
        lowLatency.enable = selfConfig.enableLowLatency;
      };

      services.pulseaudio.enable = lib.mkForce false;
    };
}
