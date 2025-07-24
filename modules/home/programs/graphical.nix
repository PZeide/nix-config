{
  config,
  lib,
  pkgs,
  ...
}: {
  options.zeide.programs.graphical = with lib; {
    loupe.enable = mkEnableOption "loupe (image viewer)";
    papers.enable = mkEnableOption "papers (pdf viewer)";
    cider.enable = mkEnableOption "cider (apple music player)";
    equibop.enable = mkEnableOption "equibop (discord client)";
    proton-pass.enable = mkEnableOption "proton-pass (password manager)";
    proton-vpn.enable = mkEnableOption "proton-vpn (VPN)";
  };

  config = let
    selfConfig = config.zeide.programs.graphical;
  in
    lib.mkMerge [
      (lib.mkIf selfConfig.loupe.enable {
        home.packages = [pkgs.loupe];
      })
      (lib.mkIf selfConfig.papers.enable {
        home.packages = [pkgs.papers];
      })
      (lib.mkIf selfConfig.cider.enable {
        home.packages = [pkgs.zeide.cider];
      })
      (lib.mkIf selfConfig.equibop.enable {
        home.packages = [pkgs.equibop];
      })
      (lib.mkIf selfConfig.proton-pass.enable {
        home.packages = [pkgs.proton-pass];
      })
      (lib.mkIf selfConfig.proton-vpn.enable {
        home.packages = [pkgs.protonvpn-gui];
      })
    ];
}
