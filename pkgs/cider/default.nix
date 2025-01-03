{
  pkgs,
  lib,
  ...
}:

pkgs.appimageTools.wrapType2 rec {
  pname = "cider";
  version = "2.0.1";

  src = pkgs.requireFile {
    name = "Cider-${version}-x64.AppImage";
    url = "https://taproom.cider.sh";
    hash = "sha256-XdyW2O5LC+/dGosSYVz5IkAxi2taVBrXXHTbWZCNnn8=";
  };

  nativeBuildInputs = [ pkgs.makeWrapper ];

  extraInstallCommands =
    let
      contents = pkgs.appimageTools.extract {
        inherit version src pname;
      };
    in
    ''
      wrapProgram $out/bin/${pname} \
         --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \

      install -m 444 -D ${contents}/Cider.desktop $out/share/applications/${pname}.desktop
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace-warn 'Exec=Cider %U' 'Exec=${pname} %U'
      cp -r ${contents}/usr/share/icons $out/share
    '';

  meta = {
    description = "Powerful music player that allows you listen to your favorite tracks with style";
    homepage = "https://cider.sh";
    license = lib.licenses.unfree;
    mainProgram = "cider";
    platforms = [ "x86_64-linux" ];
  };
}
