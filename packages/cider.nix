{
  lib,
  stdenv,
  fetchzip,
  zstd,
  makeWrapper,
  autoPatchelfHook,
  libGL,
  glib,
  nss,
  nspr,
  dbus,
  at-spi2-atk,
  cups,
  gtk3,
  pango,
  cairo,
  xorg,
  mesa,
  expat,
  libxkbcommon,
  alsa-lib,
}:
stdenv.mkDerivation rec {
  pname = "cider";
  version = "3.0.0";

  src = fetchzip {
    nativeBuildInputs = [zstd];
    stripRoot = false;
    url = "https://repo.cider.sh/arch/cider-v${version}-linux-x64.pkg.tar.zst";
    hash = "sha256-6ax9Zl2/jc431erP9q0D7A+BDH5Qs05dPCsb+KM0YCE=";
  };

  nativeBuildInputs = [
    makeWrapper
    autoPatchelfHook
  ];

  buildInputs = [
    glib # libgobject-2.0.so.0, libglib-2.0.so.0, libgio-2.0.so.0,
    nss # libnss3.so, libnssutil3.so, libsmime3.so
    nspr # libnspr4.so
    dbus.lib # libdbus-1.so.3
    at-spi2-atk # libatk-1.0.so.0, libatk-bridge-2.0.so.0, libatspi.so.0
    cups.lib # libcups.so.2
    gtk3 # libgtk-3.so.0
    pango # libpango-1.0.so.0
    cairo # libcairo.so.2
    xorg.libX11 # libX11.so.6, libX11-xcb.so.1
    xorg.libXcomposite # libXcomposite.so.1
    xorg.libXdamage # libXdamage.so.1
    xorg.libXext # libXext.so.6
    xorg.libXfixes # libXfixes.so.3
    xorg.libXrandr # libXrandr.so.2
    mesa # libgbm.so.1
    expat # libexpat.so.1
    xorg.libxcb # libxcb.so.1
    libxkbcommon # libxkbcommon.so.0
    alsa-lib # libasound.so.2
  ];

  runtimeDependencies = [
    libGL
  ];

  appendRunpaths = [
    "${libGL}/lib"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{lib,share}

    cp -r $src/usr/lib/cider $out/lib
    chmod a+w $out/lib/cider

    cp -r $src/usr/share/pixmaps $out/share

    mkdir -p $out/share/applications
    install -m644 $src/usr/share/applications/cider.desktop $out/share/applications/cider.desktop

    runHook postInstall
  '';

  postInstall = ''
    wrapProgram $out/lib/cider/Cider \
       --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \

    mkdir $out/bin
    ln -sf $out/lib/cider/Cider $out/bin/${pname}
  '';

  meta = {
    description = "Powerful music player that allows you listen to your favorite tracks with style";
    homepage = "https://cider.sh";
    mainProgram = "cider";
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
  };
}
