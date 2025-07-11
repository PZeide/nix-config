{
  asset,
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  options.zeide.programs.zen-browser = with lib; {
    enable = mkEnableOption "zen browser";
  };

  imports = [inputs.zen-browser.homeModules.beta];

  config = let
    selfConfig = config.zeide.programs.zen-browser;

    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      ublock-origin
      proton-pass
      sponsorblock
      kagi-search
    ];
  in
    lib.mkIf selfConfig.enable {
      home.file = {
        ".zen/default/chrome/pineapple-fried".source = "${inputs.zen-pineapple-fried}/pineapple-fried";
        ".zen/default/chrome/advanced-tab-groups/tabgroups.css".source = "${inputs.zen-advanced-tab-groups}/chrome.css";
        ".zen/default/zen-themes.json".source = asset "zen/zen-themes.json";
      };

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
                "https://github.com/DandelionSprout/adfilt/raw/master/LegitimateURLShortener.txt"
              ];
            };
          };
        };

        profiles.default = with config.lib.stylix.colors.withHashtag; {
          isDefault = true;

          userChrome = ''
            @import "pineapple-fried/pineapple-fried.css";
            @import "advanced-tab-groups/tabgroups.css";

            :root {
              --zen-themed-toolbar-bg-transparent: #151d2096 !important;

              &:-moz-window-inactive {
                --zen-themed-toolbar-bg-transparent: #151d2078 !important;
              }

              --toolbox-bgcolor-inactive: transparent !important;
            }

            #zen-main-app-wrapper {
              transition: background-color 200ms;
            }

            .titlebar-close {
              display: none !important;
            }

            #zen-sidebar-top-buttons {
              display: none !important;
            }
          '';

          userContent = builtins.readFile "${inputs.zen-pineapple-fried}/pineapple-fried/zen-new-tabs/zen-new-tabs.css";

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

          settings = {
            #  Downloads first go to the operating system's temp directory before final location
            "browser.download.start_downloads_in_tmp_dir" = true;

            # Allow transparent browser if no background is defined
            "browser.tabs.allow_transparent_browser" = true;

            # Disable weather on new tab page
            "browser.newtabpage.activity-stream.showWeather" = false;

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

            # Enable and configure tab groups (experimental)
            "browser.tabs.groups.enabled" = true;
            "tab.groups.background" = true;
            "tab.groups.borders" = true;
            "tab.groups.theme-folders" = true;

            # Set zen preferences
            "zen.theme.accent-color" = base0B;
            "zen.theme.color-prefs.amoled" = true;
            "zen.theme.color-prefs.use-workspace-colors" = false;
            "zen.urlbar.behavior" = "normal";
            "zen.view.use-single-toolbar" = false;
            "zen.urlbar.replace-newtab" = false;
          };

          extensions.packages = extensions;
        };
      };
    };
}
