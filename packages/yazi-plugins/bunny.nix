{
  lib,
  fetchFromGitHub,
  yaziPlugins,
}:
yaziPlugins.mkYaziPlugin {
  pname = "bunny.yazi";
  version = "0-unstable-2025-07-09";

  src = fetchFromGitHub {
    owner = "stelcodes";
    repo = "bunny.yazi";
    rev = "bd8a767220e606f2c68c7ea7d67d1c0b97b7daf3";
    hash = "sha256-mdVCZMvoe9agrnX7aZeGf0oXGffE2Fhk9f1JNbir8+Q=";
  };

  meta = {
    description = "Bookmarks menu for yazi with persistent and ephemeral bookmarks";
    homepage = "https://github.com/stelcodes/bunny.yazi";
    license = lib.licenses.mit;
  };
}
