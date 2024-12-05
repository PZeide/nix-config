{ inputs, ... }:

{
  imports = [ inputs.nix-gaming.nixosModules.pipewireLowLatency ];

  services.pipewire.lowLatency = {
    enable = true;
    quantum = 64;
    rate = 48000;
  };
}
