{
  lib,
  fetchFromGitHub,
  yaziPlugins,
}:
yaziPlugins.mkYaziPlugin {
  pname = "restore.yazi";
  version = "0-unstable-2025-08-26";

  src = fetchFromGitHub {
    owner = "boydaihungst";
    repo = "restore.yazi";
    rev = "122c527143beffc8bea933404625e0e429aef5c2";
    hash = "sha256-pEQZ/2Z4XVYlfzqtCz51bIgE9KzkDF/qyX8vThhlWGI=";
  };

  meta = {
    description = "Undo/Recover trashed files/folders";
    homepage = "https://github.com/boydaihungst/restore.yazi";
    license = lib.licenses.agpl3Only;
  };
}
