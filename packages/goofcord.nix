{
  lib,
  appimageTools,
  fetchurl,
  makeWrapper,
  libappindicator,
  gnome2,
  libindicator,
  libnotify,
  libXScrnSaver,
  xorg,
}:
appimageTools.wrapType2 rec {
  pname = "goofcord";
  version = "1.10.1";

  src = fetchurl {
    url = "https://github.com/Milkshiift/GoofCord/releases/download/v${version}/GoofCord-${version}-linux-x86_64.AppImage";
    hash = "sha256-dsYwa/cCO6LjY7CYeCpNHY+MOvYM7tzJZnoBWjyD++Y=";
  };

  nativeBuildInputs = [makeWrapper];

  buildInputs = [
    libappindicator
    gnome2.GConf
    libindicator
    libnotify
    libXScrnSaver
    xorg.libXtst
  ];

  extraInstallCommands = let
    contents = appimageTools.extract {
      inherit version src pname;
    };
  in ''
    wrapProgram $out/bin/${pname} \
       --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=UseOzonePlatform,WaylandWindowDecorations,WebRTCPipeWireCapturer --enable-wayland-ime=true}}" \
      --set-default ELECTRON_IS_DEV 0

    install -m 444 -D ${contents}/goofcord.desktop $out/share/applications/${pname}.desktop
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-warn 'Exec=AppRun --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform-hint=auto %U' 'Exec=${pname} %U'
    cp -r ${contents}/usr/share/icons $out/share
  '';

  meta = {
    description = "Highly configurable and privacy-focused Discord client";
    homepage = "https://github.com/Milkshiift/GoofCord";
    mainProgram = "goofcord";
    license = lib.licenses.osl3;
    platforms = lib.platforms.linux;
  };
}
