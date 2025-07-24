{pkgs, ...}: {
  nixpkgs.overlays = [
    (final: _: {
      zeide = with pkgs; {
        yazi-plugins = {
          bunny = callPackage ./yazi-plugins/bunny.nix {};
          chmod = callPackage ./yazi-plugins/chmod.nix {};
          copy-file-contents = callPackage ./yazi-plugins/copy-file-contents.nix {};
          full-border = callPackage ./yazi-plugins/full-border.nix {};
          lazygit = callPackage ./yazi-plugins/lazygit.nix {};
          mediainfo = callPackage ./yazi-plugins/mediainfo.nix {};
          ouch = callPackage ./yazi-plugins/ouch.nix {};
          piper = callPackage ./yazi-plugins/piper.nix {};
          restore = callPackage ./yazi-plugins/restore.nix {};
          starship = callPackage ./yazi-plugins/starship.nix {};
          toggle-pane = callPackage ./yazi-plugins/toggle-pane.nix {};
        };

        app2unit = callPackage ./app2unit.nix {};
        cider = callPackage ./cider.nix {};
        librepods = callPackage ./librepods.nix {};
      };
    })
  ];
}
