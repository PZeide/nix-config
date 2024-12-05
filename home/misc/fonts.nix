{
  pkgs,
  inputs,
  ...
}:

{
  stylix.fonts = {
    serif = {
      package = inputs.apple-fonts.packages.${pkgs.system}.ny;
      name = "New York";
    };

    sansSerif = {
      package = inputs.apple-fonts.packages.${pkgs.system}.sf-pro;
      name = "SF Pro Text";
    };

    monospace = {
      package = pkgs.iosevka;
      name = "Iosevka";
    };

    emoji = {
      package = pkgs.noto-fonts-color-emoji;
      name = "Noto Color Emoji";
    };

    sizes = {
      applications = 13;
      desktop = 13;
      popups = 13;
      terminal = 13;
    };
  };

  fonts.fontconfig = {
    enable = true;

    defaultFonts = {
      serif = [ "New York" ];
      sansSerif = [ "SF Pro Text" ];
      monospace = [ "Iosevka" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  # Optional fonts
  home.packages = with pkgs; [
    noto-fonts-cjk-sans
    (pkgs.nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
  ];
}
