# Original file: https://github.com/0x006E/dotfiles
#                https://github.com/Gurjaka/zen-browser-nix

{
  lib,
  libGL,
  libGLU,
  libevent,
  libffi,
  libjpeg,
  libpng,
  libstartup_notification,
  libvpx,
  libwebp,
  fetchzip,
  stdenv,
  fontconfig,
  libxkbcommon,
  zlib,
  freetype,
  gtk3,
  libxml2,
  dbus,
  xcb-util-cursor,
  alsa-lib,
  libpulseaudio,
  pango,
  atk,
  cairo,
  gdk-pixbuf,
  glib,
  udev,
  libva,
  mesa,
  libnotify,
  cups,
  pciutils,
  ffmpeg,
  libglvnd,
  pipewire,
  speechd,
  libxcb,
  libX11,
  libXcursor,
  libXrandr,
  libXi,
  libXext,
  libXcomposite,
  libXdamage,
  libXfixes,
  libXScrnSaver,
  makeWrapper,
  copyDesktopItems,
  wrapGAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "zen-browser-unwrapped";
  version = "1.6b";

  src =
    let
      repo = "https://github.com/zen-browser/desktop";
      archive = {
        name = "zen";
        extension = "tar.bz2";
        fullname = "${archive.name}.linux-x86_64.${archive.extension}";
      };

      url = lib.strings.concatStringsSep "/" [
        repo
        "releases/download"
        version
        archive.fullname
      ];
    in
    fetchzip {
      inherit url;
      inherit (archive) extension;
      hash = "sha256-7Z7PZMTmPhB4Sx9+YXpWTkhcBsblzkgWyIJvNTSTNSU=";
    };

  runtimeLibs = [
    libGL
    libGLU
    libevent
    libffi
    libjpeg
    libpng
    libstartup_notification
    libvpx
    libwebp
    stdenv.cc.cc
    fontconfig
    libxkbcommon
    zlib
    freetype
    gtk3
    libxml2
    dbus
    xcb-util-cursor
    alsa-lib
    libpulseaudio
    pango
    atk
    cairo
    gdk-pixbuf
    glib
    udev
    libva
    mesa
    libnotify
    cups
    pciutils
    ffmpeg
    libglvnd
    pipewire
    speechd
    libxcb
    libX11
    libXcursor
    libXrandr
    libXi
    libXext
    libXcomposite
    libXdamage
    libXfixes
    libXScrnSaver
  ];

  desktopSrc = ./.;

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
    wrapGAppsHook
  ];

  installPhase = ''
    mkdir -p $out/{bin,opt/zen} && cp -r $src/* $out/opt/zen
    ln -s $out/opt/zen/zen $out/bin/zen

    install -D $desktopSrc/zen.desktop $out/share/applications/zen.desktop

    for i in 16 32 48 64 128; do
        install -Dm 644 $src/browser/chrome/icons/default/default$i.png \
          $out/share/icons/hicolor/$ix$i/apps/zen.png
    done
  '';

  fixupPhase =
    let
      ld-lib-path = lib.makeLibraryPath runtimeLibs;
    in
    ''
      chmod 755 $out/bin/zen $out/opt/zen/*
      interpreter=$(cat $NIX_CC/nix-support/dynamic-linker)

      for bin in zen zen-bin; do
         patchelf --set-interpreter "$interpreter" $out/opt/zen/$bin
         wrapProgram $out/opt/zen/$bin \
             --set LD_LIBRARY_PATH "${ld-lib-path}" \
             --set MOZ_LEGACY_PROFILES 1 \
             --set MOZ_ALLOW_DOWNGRADE 1 \
             --set MOZ_APP_LAUNCHER zen \
             --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
      done;

      for bin in glxtest updater vaapitest; do
          patchelf --set-interpreter "$interpreter" $out/opt/zen/$bin
          wrapProgram $out/opt/zen/$bin \
              --set LD_LIBRARY_PATH "${ld-lib-path}"
      done;
    '';

  meta = {
    mainProgram = "zen";
    description = "Experience tranquillity while browsing the web without people tracking you!";
    homepage = "https://zen-browser.app";
    downloadPage = "https://zen-browser.app/download/";
    changelog = "https://github.com/zen-browser/desktop/releases";
    platforms = lib.platforms.linux;
  };

  passthru = {
    binaryName = meta.mainProgram;
    execdir = "/bin";
    libName = "${pname}";
    ffmpegSupport = true;
    gssSupport = true;
    gtk3 = gtk3;
  };
}
