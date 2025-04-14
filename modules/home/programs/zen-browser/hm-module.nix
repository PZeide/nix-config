{
  config,
  lib,
  inputs,
  system,
  ...
}: let
  applicationName = "Zen Browser";
  modulePath = [
    "programs"
    "zen-browser"
  ];

  mkFirefoxModule = import "${inputs.home-manager.outPath}/modules/programs/firefox/mkFirefoxModule.nix";
in {
  imports = [
    (mkFirefoxModule {
      inherit modulePath;
      name = applicationName;
      wrappedPackageName = "zen-browser-unwrapped";
      unwrappedPackageName = "zen-browser";
      visible = true;
      platforms = {
        linux = {
          vendorPath = ".zen";
          configPath = ".zen";
        };
        darwin = {
          configPath = "Library/Application Support/Zen";
        };
      };
    })
  ];

  config = lib.mkIf config.programs.zen-browser.enable {
    programs.zen-browser = {
      package = lib.mkDefault inputs.zen-browser.packages.${system}.zen-browser;
    };
  };
}
