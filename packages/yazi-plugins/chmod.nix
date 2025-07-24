{
  lib,
  fetchFromGitHub,
  yaziPlugins,
}:
yaziPlugins.mkYaziPlugin rec {
  pname = "chmod.yazi";
  version = "0-unstable-2025-06-27";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "7c174cc0ae1e07876218868e5e0917308201c081";
    hash = "sha256-RE93ZNlG6CRGZz7YByXtO0mifduh6MMGls6J9IYwaFA=";
  };

  installPhase = ''
    runHook preInstall

    cp -r ${pname} $out
    rm $out/LICENSE
    cp LICENSE $out

    runHook postInstall
  '';

  meta = {
    description = "Execute chmod on the selected files to change their mode";
    homepage = "https://github.com/yazi-rs/plugins/tree/main/chmod.yazi";
    license = lib.licenses.mit;
  };
}
