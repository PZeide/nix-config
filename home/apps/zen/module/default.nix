let
  mkFirefoxModule = import ./mkFirefoxModule.nix;
in
{
  imports = [
    (mkFirefoxModule {
      modulePath = [
        "programs"
        "zen-browser"
      ];

      name = "Zen Browser";
      wrappedPackageName = "zen-browser";
      unwrappedPackageName = "zen-browser-unwrapped";
      visible = true;

      platforms.linux = rec {
        vendorPath = ".zen";
        configPath = "${vendorPath}";
      };
    })
  ];
}
