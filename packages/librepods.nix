{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
}:
stdenv.mkDerivation rec {
  pname = "librepods";
  version = "0.1.0-unstable-75fa80c";

  src = fetchFromGitHub {
    owner = "kavishdevar";
    repo = "librepods";
    rev = "28ffd217d643f525f940528addcff78846434635";
    hash = "sha256-+mdTMA14TqbZgPmgGeFUqnp4DudIKMk5vIYQfqqBglE=";
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
    mv librepods $out/bin/${pname}
  '';

  meta = {
    description = "AirPods libreated from Apple's ecosystem.";
    homepage = "https://github.com/kavishdevar/librepods";
    mainProgram = "librepods";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux;
  };
}
