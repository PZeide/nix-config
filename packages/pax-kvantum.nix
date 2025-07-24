{
  stdenvNoCC,
  fetchFromGitHub,
  lib,
}:
stdenvNoCC.mkDerivation {
  pname = "pax-kvantum";
  version = "0-unstable-2025-07-22";

  src = fetchFromGitHub {
    owner = "L4ki";
    repo = "Pax-Plasma-Themes";
    rev = "09d4bae9a1033b1d5ba9d91ffb76c6d94da5b63a";
    sha256 = "sha256-i4Zuk+ScnMxRx7RW7QyQcb84fOBZVGAqGsXkkwW+tlg=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/Kvantum/Pax-Kvantum
    cp $src/Pax-Kvantum/* $out/share/Kvantum/Pax-Kvantum

    runHook postInstall
  '';

  meta = {
    description = "Dark KVANTUM Theme, Blur and Transparent";
    homepage = "https://github.com/L4ki/Pax-Plasma-Themes";
    license = lib.licenses.gpl3Only;
  };
}
