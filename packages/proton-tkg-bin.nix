{
  lib,
  stdenvNoCC,
  fetchzip,
  # Can be overridden to alter the display name in steam
  # This could be useful if multiple versions should be installed together
  steamDisplayName ? "Proton TKG",
}:
stdenvNoCC.mkDerivation (finalAttrs: rec {
  pname = "proton-tkg-bin";
  version = "10.6.r6.g74dd8bdd";
  githubRunId = "14728116174";

  src = fetchzip {
    url = "https://nightly.link/Frogging-Family/wine-tkg-git/actions/runs/${githubRunId}/proton-tkg-build.zip";
    hash = "sha256-lx5PHo+U+2LH5xsJPLFJqG2B0sz2AzAU+vJXEqQrqzY=";
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  outputs = [
    "out"
    "steamcompattool"
  ];

  installPhase = ''
    runHook preInstall

    # Make it impossible to add to an environment. You should use the appropriate NixOS option.
    # Also leave some breadcrumbs in the file.
    echo "${finalAttrs.pname} should not be installed into environments. Please use programs.steam.extraCompatPackages instead." > $out

    mkdir $steamcompattool
    tar -xf $src/proton_tkg_${finalAttrs.version}.tar -C $steamcompattool --strip-components=1

    runHook postInstall
  '';

  preFixup = ''
    substituteInPlace "$steamcompattool/compatibilitytool.vdf" \
      --replace-fail "TKG-proton-${finalAttrs.version}" "${steamDisplayName}"
  '';

  meta = {
    description = ''
      Compatibility tool for Steam Play based on Wine and additional patches.

      (This is intended for use in the `programs.steam.extraCompatPackages` option only.)
    '';
    homepage = "https://github.com/Frogging-Family/wine-tkg-git";
    license = lib.licenses.bsd3;
    platforms = ["x86_64-linux"];
    sourceProvenance = [lib.sourceTypes.binaryNativeCode];
  };
})
