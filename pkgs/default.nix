{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (final: _: {
      cider = pkgs.callPackage ./cider { };
      zen-browser-unwrapped = pkgs.callPackage ./zen-browser-unwrapped { };
      zen-browser = pkgs.wrapFirefox final.zen-browser-unwrapped { };
    })
  ];
}
