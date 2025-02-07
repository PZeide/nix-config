{
  inputs,
  system,
  ...
}: {
  fonts = {
    enableDefaultPackages = false;
    enableGhostscriptFonts = false;

    fontconfig.localConf = ''
      <?xml version="1.0"?>
      <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
      <fontconfig>
        <selectfont>
          <rejectfont>
            <pattern>
              <patelt name="family">
                <string>DejaVu Sans</string>
              </patelt>
            </pattern>
          </rejectfont>
        </selectfont>
      </fontconfig>
    '';
  };

  # Use home module for further configuration
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${system}.hyprland;
    portalPackage = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
    withUWSM = true;
  };
}
