{
  lib,
  fetchFromGitHub,
  yaziPlugins,
}:
yaziPlugins.mkYaziPlugin rec {
  pname = "piper.yazi";
  version = "0-unstable-2025-06-21";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "3d1efb706924112daed986a4eef634e408bad65e";
    hash = "sha256-GgEg1A5sxaH7hR1CUOO9WV21kH8B2YUGAtOapcWLP7Y=";
  };

  installPhase = ''
    runHook preInstall

    cp -r ${pname} $out
    rm $out/LICENSE
    cp LICENSE $out

    runHook postInstall
  '';

  meta = {
    description = "Pipe any shell command as a previewer";
    homepage = "https://github.com/yazi-rs/plugins/tree/main/piper.yazi";
    license = lib.licenses.mit;
  };
}
