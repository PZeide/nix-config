{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
}:
stdenv.mkDerivation rec {
  pname = "librepods";
  version = "0.1.0-96ee241";

  src = fetchFromGitHub {
    owner = "kavishdevar";
    repo = "librepods";
    rev = "96ee2410e83cb2895da5dff05d019380ee1c0dae";
    hash = "sha256-DQjlv4QmIDRTItIJAKxe9fTz7Aenqn1dl8owuU9FRSI=";
  };

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtconnectivity
    qt6.qtmultimedia
  ];

  configurePhase = ''
    cmake ./linux
  '';

  buildPhase = ''
    make
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv applinux $out/bin/${pname}
  '';

  meta = {
    description = "AirPods libreated from Apple's ecosystem.";
    homepage = "https://github.com/kavishdevar/librepods";
    mainProgram = "librepods";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux;
  };
}
