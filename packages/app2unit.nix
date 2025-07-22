{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  scdoc,
}:
stdenvNoCC.mkDerivation {
  pname = "app2unit";
  version = "0-unstable-6a2fe29";

  src = fetchFromGitHub {
    owner = "Vladimir-csp";
    repo = "app2unit";
    rev = "6a2fe29210fd939571fdfcd78581965ef479c749";
    hash = "sha256-TjePNU9Wu9kaXSczMAZcMV0HSC9zqzLcgKXdbkyLSAU=";
  };

  nativeBuildInputs = [
    scdoc
  ];

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
