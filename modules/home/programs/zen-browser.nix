{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  options.zeide.programs.zen-browser = with lib; {
    enable = mkEnableOption "zen browser";
  };

  imports = [inputs.zen-browser.homeModules.default];

  config = let
    selfConfig = config.zeide.programs.zen-browser;

    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      ublock-origin
      proton-pass
      sponsorblock
      tabliss
      kagi-search
    ];
  in
    lib.mkIf selfConfig.enable {
      programs.zen-browser = {
        enable = true;

        policies = {
          AutofillAddressEnabled = true;
          AutofillCreditCardEnabled = false;
          DisableAppUpdate = true;
          DisableFeedbackCommands = true;
          DisableFirefoxAccounts = true;
          DisableFirefoxStudies = true;
          DisablePocket = true;
          DisableSetDesktopBackground = true;
          DisableTelemetry = true;
          DontCheckDefaultBrowser = true;
          NoDefaultBookmarks = true;
          OfferToSaveLogins = false;

          EnableTrackingProtection = {
            Value = true;
            Locked = true;
            Cryptomining = true;
            Fingerprinting = true;
          };

          ExtensionSettings = builtins.listToAttrs (
            builtins.map (
              e:
                lib.nameValuePair e.addonId {
                  installation_mode = "force_installed";
                  install_url = "file://${e.src}";
                  updates_disabled = true;
                }
            )
            extensions
          );

          "3rdparty".Extensions."uBlock0@raymondhill.net" = {
            adminSettings = {
              selectedFilterLists = [
                "ublock-filters"
                "ublock-badware"
                "ublock-privacy"
                "ublock-unbreak"
                "ublock-quick-fixes"
                "ublock-annoyances"
                "easylist"
                "easylist-annoyances"
                "easylist-chat"
                "easylist-newsletters"
                "easylist-notifications"
                "easyprivacy"
                "urlhaus-1"
                "plowe-0"
              ];
            };
          };
        };

        profiles.default = {
          isDefault = true;

          search = {
            force = true;
            default = "Kagi";
            privateDefault = "Kagi";
            engines = {
              "Kagi" = {
                urls = [{template = "https://kagi.com/search?q={searchTerms}";}];
                definedAliases = ["@k"];
                icon = "https://kagi.com/favicon.ico";
                updateInterval = 24 * 60 * 60 * 1000;
              };

              "google".metaData.hidden = true;
              "ddg".metaData.hidden = true;
              "qwant".metaData.hidden = true;
              "wikipedia".metaData.hidden = true;
            };
          };

          settings = with config.lib.stylix.colors.withHashtag; {
            "extensions.autoDisableScopes" = 0;
            "signon.showAutoCompleteFooter" = 0;

            "zen.welcome-screen.seen" = true;
            "zen.theme.accent-color" = base0B;
            "zen.theme.color-prefs.amoled" = true;
            "zen.theme.color-prefs.use-workspace-colors" = false;
            "zen.urlbar.behavior" = "float";
            "zen.view.use-single-toolbar" = false;
          };

          extensions.packages = extensions;
        };
      };
    };
}
