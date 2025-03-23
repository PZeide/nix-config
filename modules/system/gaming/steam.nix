{
  config,
  lib,
  ...
}: {
  options.zeide.gaming.steam = with lib; {
    enable = mkEnableOption "steam";
  };

  config = let
    selfConfig = config.zeide.gaming.steam;
  in
    lib.mkIf selfConfig.enable {
      programs.steam = {
        enable = true;

        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;

        gamescopeSession.enable = config.zeide.gaming.gamescope.enable;
      };
    };
}
