{
  pkgs,
  lib,
  ...
}:

let
  cider = pkgs.appimageTools.wrapType2 rec {
    pname = "cider";
    version = "2.5.0";

    src = pkgs.requireFile {
      name = "Cider-Linux.AppImage";
      url = "https://taproom.cider.sh";
      sha256 = "ad34856992b98a7718c6a50796475232608ae242b737bdaa459512a432b7aea8";
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

        install -m 444 -D ${contents}/cider.desktop $out/share/applications/${pname}.desktop
        substituteInPlace $out/share/applications/${pname}.desktop \
          --replace-warn 'Exec=AppRun --no-sandbox' 'Exec=${pname}'
        cp -r ${contents}/usr/share/icons $out/share
      '';

    meta = {
      description = "Powerful music player that allows you listen to your favorite tracks with style";
      homepage = "https://cider.sh";
      license = lib.licenses.unfree;
      mainProgram = "cider";
      platforms = [ "x86_64-linux" ];
    };
  };
in
{
  home.packages = [
    cider
  ];
}
