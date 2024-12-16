{
  pkgs,
  lib,
  inputs,
  system,
  ...
}:

{
  imports = [ ./module ];

  programs.zen-browser = {
    enable = true;
    package = inputs.zen-browser.packages."${system}".specific;

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

    profiles.default = {
      isDefault = true;
      containersForce = true;

      containers = {
        personal = {
          color = "blue";
          icon = "chill";
          id = 1;
        };

        work = {
          color = "yellow";
          icon = "briefcase";
          id = 2;
        };
      };

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
  };
}
