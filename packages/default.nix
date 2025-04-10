{pkgs, ...}: {
  nixpkgs.overlays = [
    (final: _: {
      cider-taproom = pkgs.callPackage ./cider-taproom.nix {};
      waydroid-helper = pkgs.callPackage ./waydroid-helper.nix {};
      app2unit = pkgs.callPackage ./app2unit.nix {};
    })
  ];
}
