{pkgs, ...}: {
  nixpkgs.overlays = [
    (final: _: {
      zeide = with pkgs; {
        app2unit = callPackage ./app2unit.nix {};
        cider = callPackage ./cider.nix {};
        goofcord = callPackage ./goofcord.nix {};
        librepods = callPackage ./librepods.nix {};
      };
    })
  ];
}
