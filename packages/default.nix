{pkgs, ...}: {
  nixpkgs.overlays = [
    (final: _: {
      zeide = with pkgs; {
        cider = callPackage ./cider.nix {};
      };
    })
  ];
}
