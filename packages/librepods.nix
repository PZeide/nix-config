{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
}:
stdenv.mkDerivation rec {
  pname = "librepods";
  version = "0.1.0-72a7637";

  src = fetchFromGitHub {
    owner = "kavishdevar";
    repo = "librepods";
    rev = "72a7637863488a27d2c42e3ac2bc81e4e4bc7aab";
    hash = "sha256-/I+PFIFpGqPfQQ7NSBta+yBbIxYjjYK5D7T8oBc6CAE=";
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
