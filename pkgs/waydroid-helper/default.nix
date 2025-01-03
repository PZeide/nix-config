{
  pkgs,
  lib,
  ...
}:

pkgs.appimageTools.wrapType2 rec {
  pname = "waydroid-helper";
  version = "0.1.2";

  src = pkgs.fetchurl {
    url = "https://github.com/ayasa520/waydroid-helper/releases/download/v${version}/waydroid-helper-${version}-x86_64.AppImage";
    hash = "sha256-VMgwsy4STIWNAkit2N1uK443WiV5f2HzBTxaGtJCh64=";
  };

  nativeBuildInputs = [ pkgs.makeWrapper ];

  extraInstallCommands =
    let
      fullName = "com.jaoushingan.WaydroidHelper";

      contents = pkgs.appimageTools.extract {
        inherit version src pname;
      };
    in
    ''
      wrapProgram $out/bin/${pname}

      install -m 444 -D ${contents}/${fullName}.desktop $out/share/applications/${pname}.desktop
      cp -r ${contents}/usr/share/icons $out/share
    '';

  extraPkgs =
    pkgs: with pkgs; [
      gtk4
      libadwaita
    ];

  meta = {
    description = "Waydroid Helper is a graphical user interface application written in Python using PyGObject.";
    license = lib.licenses.gpl3Only;
    mainProgram = "waydroid-helper";
    platforms = [ "x86_64-linux" ];
  };
}
