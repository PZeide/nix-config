{
  lib,
  fetchFromGitHub,
  yaziPlugins,
}:
yaziPlugins.mkYaziPlugin {
  pname = "starship.yazi";
  version = "0-unstable-2025-07-08";

  src = fetchFromGitHub {
    owner = "Rolv-Apneseth";
    repo = "starship.yazi";
    rev = "a63550b2f91f0553cc545fd8081a03810bc41bc0";
    hash = "sha256-PYeR6fiWDbUMpJbTFSkM57FzmCbsB4W4IXXe25wLncg=";
  };

  meta = {
    description = "Starship prompt plugin for yazi ";
    homepage = "https://github.com/Rolv-Apneseth/starship.yazi";
    license = lib.licenses.mit;
  };
}
