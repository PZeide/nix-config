{
  config,
  lib,
  pkgs,
  ...
}: {
  options.zeide.gaming.steam = with lib; {
    enable = mkEnableOption "steam";
  };

  config = let
    cfg = config.zeide.gaming.steam;
  in
    lib.mkIf cfg.enable {
      programs.steam = {
        enable = true;

        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;

        extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];
      };
    };
}
