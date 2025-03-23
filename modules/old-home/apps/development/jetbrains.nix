{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    jetbrains.idea-ultimate
    jetbrains.goland

    kotlin
    kotlin-native
  ];

  home.sessionVariables = let
    target = "${config.home.homeDirectory}/${config.xdg.configFile."jetbrains/ide.vmoptions".target}";
  in {
    IDEA_VM_OPTIONS = target;
    GOLAND_VM_OPTIONS = target;
  };

  xdg.configFile."jetbrains/ide.vmoptions" = {
    recursive = true;
    text = ''
      -Xmx8G
      -Xms4G
      -XX:NewRatio=1
      -Dawt.toolkit.name=WLToolkit
    '';
  };
}
