{pkgs, ...}: {
  nixpkgs.overlays = [
    (final: _: {
      zeide = with pkgs; {
        app2unit = callPackage ./app2unit.nix {};
        cider-taproom = callPackage ./cider-taproom.nix {};
      };
    })
  ];
}
