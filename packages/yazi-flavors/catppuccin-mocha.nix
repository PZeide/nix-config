{
  stdenv,
  fetchFromGitHub,
  lib,
}:
stdenv.mkDerivation rec {
  pname = "catppuccin-mocha.yazi";
  version = "0-unstable-2025-05-30";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "flavors";
    rev = "d04a298a8d4ada755816cb1a8cfb74dd46ef7124";
    hash = "sha256-m3yk6OcJ9vbCwtxkMRVUDhMMTOwaBFlqWDxGqX2Kyvc=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp $src/${pname}/* $out/

    runHook postInstall
  '';

  meta = {
    description = "Catppuccin Mocha Flavor for Yazi";
    homepage = "https://github.com/yazi-rs/flavors/tree/main/catppuccin-mocha.yazi";
    license = lib.licenses.mit;
  };
}
