{
  config,
  lib,
  inputs,
  ...
}: {
  options.zeide.programs.zen-browser = with lib; {
    enable = mkEnableOption "zen browser";
  };

  imports = [inputs.zen-browser.homeModules.beta];

  config = let
    selfConfig = config.zeide.programs.zen-browser;
  in
    lib.mkIf selfConfig.enable {
      home.file.".zen/default/chrome/bubble-clean".source = "${inputs.bubble-clean-zen}/chrome/bubble-clean";

      programs.zen-browser = {
        enable = true;

        policies = let
          mkExtensionSettings = builtins.mapAttrs (_: pluginId: {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/${pluginId}/latest.xpi";
            installation_mode = "force_installed";
          });
        in {
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

          ExtensionSettings = mkExtensionSettings {
            "uBlock0@raymondhill.net" = "ublock-origin";
            "78272b6fa58f4a1abaac99321d503a20@proton.me" = "proton-pass";
            "sponsorBlocker@ajay.app" = "sponsorblock";
            "search@kagi.com" = "kagi-search";
            "{aecec67f-0d10-4fa7-b7c7-609a2db280cf}" = "violentmonkey";
            "companion@seelie.me" = "seelie-companion";
          };

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
                "https://github.com/DandelionSprout/adfilt/raw/master/LegitimateURLShortener.txt"
              ];
            };
          };
        };

        profiles.default = with config.lib.stylix.colors.withHashtag; {
          isDefault = true;

          userChrome = ''
            @import "bubble-clean/bubble-clean.css";

            /* Disable close button */
            .titlebar-close {
              display: none !important;
            }
          '';

          userContent = ''
            @import "bubble-clean/bubble-content.css";
          '';

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

          containers = {
            personal = {
              id = 1;
              name = "Personal";
              color = "turquoise";
              icon = "fingerprint";
            };

            work = {
              id = 2;
              name = "Work";
              color = "yellow";
              icon = "briefcase";
            };
          };

          settings = {
            #  Downloads first go to the operating system's temp directory before final location
            "browser.download.start_downloads_in_tmp_dir" = true;

            # Allow transparent browser if no background is defined
            "browser.tabs.allow_transparent_browser" = true;

            # Blank startup and new tab page
            "browser.newtabpage.enabled" = false;
            "browser.startup.homepage" = "chrome://browser/content/blanktab.html";

            # Attempts to reject cookies where possible and ignores other types of banners
            "cookiebanners.service.mode" = 1;
            "cookiebanners.service.mode.privateBrowsing" = 1;

            # Decreases minimum interval between content reflows
            "content.notify.interval" = 100000;

            # Disabling installing extensions
            "extensions.autoDisableScopes" = 0;

            # Prevent PiP from opening when switching tabs
            "media.videocontrols.picture-in-picture.enable-when-switching-tabs.enabled" = false;

            # Disabling Zen welcome screen
            "zen.welcome-screen.seen" = true;

            # Enable Linux transparency
            "zen.widget.linux.transparency" = true;

            # Don't disable transparency if inactive
            "zen.view.grey-out-inactive-windows" = false;

            # Enable and configure tab groups (experimental)
            "browser.tabs.groups.enabled" = true;
            "tab.groups.background" = true;
            "tab.groups.borders" = true;
            "tab.groups.theme-folders" = true;

            # Use FileChooser from XDG Desktop Portal
            "widget.use-xdg-desktop-portal.file-picker" = 1;

            # Zen preferences
            "zen.theme.accent-color" = base08;
            "zen.theme.color-prefs.amoled" = true;
            "zen.theme.color-prefs.use-workspace-colors" = false;
            "zen.urlbar.behavior" = "normal";
            "zen.view.use-single-toolbar" = false;
            "zen.urlbar.replace-newtab" = false;
          };
        };
      };
    };
}
