{
  lib,
  fetchFromGitHub,
  yaziPlugins,
}:
yaziPlugins.mkYaziPlugin rec {
  pname = "toggle-pane.yazi";
  version = "0-unstable-2025-06-18";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "86d28e4fb4f25f36cc501b8cb0badb37a6b14263";
    hash = "sha256-m/gJTDm0cVkIdcQ1ZJliPqBhNKoCW1FciLkuq7D1mxo=";
  };

  installPhase = ''
    runHook preInstall

    cp -r ${pname} $out
    rm $out/LICENSE
    cp LICENSE $out

    runHook postInstall
  '';

  meta = {
    description = "Toggle the show, hide, and maximize states for different panes: parent, current, and preview";
    homepage = "https://github.com/yazi-rs/plugins/tree/main/toggle-pane.yazi`";
    license = lib.licenses.mit;
  };
}
