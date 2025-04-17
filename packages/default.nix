{pkgs, ...}: {
  nixpkgs.overlays = [
    (final: _: {
      zeide = {
        app2unit = pkgs.callPackage ./app2unit.nix {};
        cider-taproom = pkgs.callPackage ./cider-taproom.nix {};
        waydroid-helper = pkgs.callPackage ./waydroid-helper.nix {};
      };
    })
  ];
}
