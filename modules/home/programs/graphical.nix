{
  asset,
  config,
  lib,
  pkgs,
  ...
}: {
  options.zeide.programs.graphical = with lib; {
    loupe = mkEnableOption "loupe (image viewer)";
    papers = mkEnableOption "papers (pdf viewer)";
    cider = mkEnableOption "cider (apple music player)";
    equibop = mkEnableOption "equibop (discord client)";
    proton-pass = mkEnableOption "proton-pass (password manager)";
    proton-vpn = mkEnableOption "proton-vpn (VPN)";
    teams = mkEnableOption "teams-for-linux";

    webapps = {
      keychronLauncher = mkEnableOption "keychron launcher";
      lamzuAurora = mkEnableOption "lamzu aurora";
    };
  };

  config = let
    selfConfig = config.zeide.programs.graphical;
  in
    lib.mkMerge [
      (lib.mkIf selfConfig.loupe {
        home.packages = [pkgs.loupe];
      })
      (lib.mkIf selfConfig.papers {
        home.packages = [pkgs.papers];
      })
      (lib.mkIf selfConfig.cider {
        home.packages = [pkgs.zeide.cider];
      })
      (lib.mkIf selfConfig.equibop {
        home.packages = [pkgs.equibop];
      })
      (lib.mkIf selfConfig.proton-pass {
        home.packages = [pkgs.proton-pass];
      })
      (lib.mkIf selfConfig.proton-vpn {
        home.packages = [pkgs.protonvpn-gui];
      })
      (lib.mkIf selfConfig.teams {
        home.packages = [pkgs.teams-for-linux];
      })
      (lib.mkIf selfConfig.webapps.keychronLauncher {
        home.packages = [
          (pkgs.nix-webapps-lib.mkChromiumApp {
            appName = "keychron-launcher";
            desktopName = "Keychron Launcher";
            icon = asset "icons/keychron.png";
            url = "https://launcher.keychron.com/";
            class = "__nix-webapps-keychron-launcher__-Default";
          })
        ];
      })
      (lib.mkIf selfConfig.webapps.keychronLauncher {
        home.packages = [
          (pkgs.nix-webapps-lib.mkChromiumApp {
            appName = "lamzu-aurora";
            desktopName = "LAMZU Aurora";
            icon = asset "icons/lamzu.png";
            url = "https://www.lamzu.net/";
            class = "__nix-webapps-lamzu-aurora__-Default";
          })
        ];
      })
    ];
}
