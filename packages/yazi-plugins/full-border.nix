{
  lib,
  fetchFromGitHub,
  yaziPlugins,
}:
yaziPlugins.mkYaziPlugin rec {
  pname = "full-border.yazi";
  version = "0-unstable-2025-05-28";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "f9b3f8876eaa74d8b76e5b8356aca7e6a81c0fb7";
    hash = "sha256-EoIrbyC7WgRzrEtvso2Sr6HnNW91c5E+RZGqnjEi6Zo=";
  };

  installPhase = ''
    runHook preInstall

    cp -r ${pname} $out
    rm $out/LICENSE
    cp LICENSE $out

    runHook postInstall
  '';

  meta = {
    description = "Add a full border to Yazi to make it look fancier";
    homepage = "https://github.com/yazi-rs/plugins/tree/main/full-border.yazi";
    license = lib.licenses.mit;
  };
}
