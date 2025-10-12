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

    mkPackageIf = name: pkg:
      lib.mkIf (lib.attrByPath [name] false selfConfig) {
        home.packages = [pkg];
      };

    mkWebAppIf = name: {
      desktopName,
      icon,
      url,
      class,
    }:
      lib.mkIf (lib.attrByPath ["webapps" name] false selfConfig) {
        home.packages = [
          (pkgs.nix-webapps-lib.mkChromiumApp {
            appName = name;
            inherit desktopName icon url class;
          })
        ];
      };
  in
    lib.mkMerge [
      (mkPackageIf "loupe" pkgs.loupe)
      (mkPackageIf "papers" pkgs.papers)
      (mkPackageIf "cider" pkgs.zeide.cider)
      (mkPackageIf "proton-pass" pkgs.proton-pass)
      (mkPackageIf "proton-vpn" pkgs.protonvpn-gui)
      (mkPackageIf "teams" pkgs.teams-for-linux)

      (mkWebAppIf "keychronLauncher" {
        desktopName = "Keychron Launcher";
        icon = asset "icons/keychron.png";
        url = "https://launcher.keychron.com/";
        class = "__nix-webapps-keychron-launcher__-Default";
      })

      (mkWebAppIf "lamzuAurora" {
        desktopName = "LAMZU Aurora";
        icon = asset "icons/lamzu.png";
        url = "https://www.lamzu.net/";
        class = "__nix-webapps-lamzu-aurora__-Default";
      })
    ];
}
