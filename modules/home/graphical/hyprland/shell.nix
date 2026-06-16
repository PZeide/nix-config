{
  config,
  lib,
  inputs,
  system,
  ...
}: {
  imports = [inputs.shiny-shell.homeManagerModules.default];

  config = {
    xdg.configFile."hypr/xdph.conf".text = ''
      screencopy {
        max_fps=0
        custom_picker_binary=${inputs.shiny-shell.packages.${system}.default}/bin/shiny-hyprland-share-picker
      }
    '';

    programs.shiny-shell = {
      enable = true;

      settings = {
        appearance = {
          color = let
            colors = lib.importJSON (
              config.stylix.palette.generators.semantic
              config.stylix.polarity
              config.stylix.image
            );

            color = name: colors.${name};
          in {
            primary = color "primary";
            overPrimary = color "on_primary";
            primaryContainer = color "primary_container";
            overPrimaryContainer = color "on_primary_container";
            primaryFixed = color "primary_fixed";
            primaryFixedDim = color "primary_fixed_dim";
            overPrimaryFixed = color "on_primary_fixed";
            overPrimaryFixedVariant = color "on_primary_fixed_variant";

            secondary = color "secondary";
            overSecondary = color "on_secondary";
            secondaryContainer = color "secondary_container";
            overSecondaryContainer = color "on_secondary_container";
            secondaryFixed = color "secondary_fixed";
            secondaryFixedDim = color "secondary_fixed_dim";
            overSecondaryFixed = color "on_secondary_fixed";
            overSecondaryFixedVariant = color "on_secondary_fixed_variant";

            tertiary = color "tertiary";
            overTertiary = color "on_tertiary";
            tertiaryContainer = color "tertiary_container";
            overTertiaryContainer = color "on_tertiary_container";
            tertiaryFixed = color "tertiary_fixed";
            tertiaryFixedDim = color "tertiary_fixed_dim";
            overTertiaryFixed = color "on_tertiary_fixed";
            overTertiaryFixedVariant = color "on_tertiary_fixed_variant";

            error = color "error";
            overError = color "on_error";
            errorContainer = color "error_container";
            overErrorContainer = color "on_error_container";

            surfaceDim = color "surface_dim";
            surface = color "surface";
            surfaceBright = color "surface_bright";
            surfaceVariant = color "surface_variant";
            surfaceContainerLowest = color "surface_container_lowest";
            surfaceContainerLow = color "surface_container_low";
            surfaceContainer = color "surface_container";
            surfaceContainerHigh = color "surface_container_high";
            surfaceContainerHighest = color "surface_container_highest";
            overSurface = color "on_surface";
            overSurfaceVariant = color "on_surface_variant";

            outline = color "outline";
            outlineVariant = color "outline_variant";

            inverseSurface = color "inverse_surface";
            inverseOverSurface = color "inverse_on_surface";
            inversePrimary = color "inverse_primary";

            shadow = color "shadow";
            scrim = color "scrim";
          };

          font.family = with config.stylix.fonts; {
            sans = sansSerif.name;
            mono = monospace.name;
          };
        };

        bar.enabled = true;
        brightness.enabled = true;

        launcher = {
          enabled = true;
          applications.useSystemd = true;
          calculator.enabled = true;

          webSearch = {
            enabled = true;
            url = "https://kagi.com/search?q=%s";
          };
        };

        lockScreen.enabled = true;
        overview.enabled = true;
        player.preferred = ["cider"];
        polkit.enabled = true;

        session = {
          username = "Thibaud";
          facePath = "${config.zeide.theme.face}";
        };

        sharePicker.enabled = true;
        wallpaper.path = "${config.stylix.image}";
      };
    };
  };
}
