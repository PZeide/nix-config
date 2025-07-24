{
  lib,
  fetchFromGitHub,
  yaziPlugins,
}:
yaziPlugins.mkYaziPlugin rec {
  pname = "copy-file-contents.yazi";
  version = "0-unstable-2025-02-10";

  src = fetchFromGitHub {
    owner = "AnirudhG07";
    repo = "plugins-yazi";
    rev = "524c52c7e433834e36a502abd1e31a6a65c8caf0";
    hash = "sha256-GrPqcHYG+qHNi80U+EJJd1JjdAOexiE6sQxsqdeCSMg=";
  };

  installPhase = ''
    runHook preInstall

    cp -r ${pname} $out

    runHook postInstall
  '';

  meta = {
    description = "A simple plugin to copy file contents just from Yazi without going into editor";
    homepage = "https://github.com/AnirudhG07/plugins-yazi/tree/main/copy-file-contents.yazi";
    license = lib.licenses.mit;
  };
}
