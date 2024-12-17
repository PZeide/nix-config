{
  pkgs,
  lib,
  ...
}:

{
  imports = [ ./home-manager.nix ];

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

      OverrideFirstRunPage = "tabliss";
      OverridePostUpdatePage = "tabliss";

      ExtensionsSettings = builtins.listToAttrs (
        builtins.map
          (
            e:
            lib.nameValuePair e.addonId {
              installation_mode = "force_installed";
              install_url = "file://${e.src}";
              updates_disabled = true;
            }
          )
          (
            with pkgs.nur.repos.rycee.firefox-addons;
            [
              ublock-origin
              skip-redirect
              bitwarden
              sponsorblock
              tabliss
            ]
          )
      );

      "3rdparty".Extensions."uBlock0@raymondhill.net" = {
        adminSettings = {
          selectedFilterLists = [
            "user-filters"
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
            "https://github.com/DandelionSprout/adfilt/raw/master/LegitimateURLShortener.txt"
          ];
        };
      };
    };

    /*
      profiles.default = {
        isDefault = true;

            search = {
              force = true;
              default = "Google";
                engines = {
                  "Google".metaData.alias = "@g";

                  "DuckDuckGo".metaData.hidden = true;
                  "Qwant".metaData.hidden = true;
                  "Wikipedia (en)".metaData.hidden = true;
                };

            };

          settings = {
            "extensions.autoDisableScopes" = 0;
          };

      };
    */
  };
}
