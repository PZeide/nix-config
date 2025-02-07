{pkgs, ...}: {
  nixpkgs.overlays = [
    (final: _: {
      cider-taproom = pkgs.callPackage ./cider-taproom {};
      waydroid-helper = pkgs.callPackage ./waydroid-helper {};
    })
  ];
}
