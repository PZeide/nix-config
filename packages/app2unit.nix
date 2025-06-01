{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "app2unit";
  version = "0-unstable-44b5da8";

  src = fetchFromGitHub {
    owner = "Vladimir-csp";
    repo = "app2unit";
    rev = "7b9672a2dc16bdfbe7b7b7c27043529ca3bcb6ae";
    hash = "sha256-8/H0M9bFppZE6JHm6seZq9X/u6HyPncvd2CUcnbptg0=";
  };

  installPhase = ''
    install -Dt $out/bin app2unit
    ln -s $out/bin/app2unit $out/bin/app2unit-open
  '';

  meta = {
    description = "Launches Desktop Entries as Systemd user units";
    homepage = "https://github.com/Vladimir-csp/app2unit";
    mainProgram = "app2unit";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
}
