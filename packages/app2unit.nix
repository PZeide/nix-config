{
  lib,
  pkgs,
}:
pkgs.stdenvNoCC.mkDerivation {
  pname = "app2unit";
  version = "0-unstable-44b5da8";
  src = pkgs.fetchFromGitHub {
    owner = "Vladimir-csp";
    repo = "app2unit";
    rev = "44b5da8a6f1e5449d3c2a8b63dc54875bb7e10af";
    hash = "sha256-SJVGMES0tmdAhh2u8IpGAITtSnDrgSfOQbDX9RhOc/M=";
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
