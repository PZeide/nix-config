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
    cfg = config.zeide.programs.zen-browser;
  in
    lib.mkIf cfg.enable {
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
            /* Disable close button */
            .titlebar-close {
              display: none !important;
            }
          '';

          userContent = ''

          '';

          mods = [
            "642854b5-88b4-4c40-b256-e035532109df" # zen transparent
            "906c6915-5677-48ff-9bfc-096a02a72379" # floating status bar
            "253a3a74-0cc4-47b7-8b82-996a64f030d5" # floating history
            "a6335949-4465-4b71-926c-4a52d34bc9c0" # better find bar
          ];

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
            "browser.tabs.allow_transparent_browser" = true;
            "widget.transparent-windows" = true;

            # Don't disable transparency if inactive
            "zen.view.grey-out-inactive-windows" = false;

            # Use FileChooser from XDG Desktop Portal
            "widget.use-xdg-desktop-portal.file-picker" = 1;

            # Zen preferences
            "zen.theme.accent-color" = base08;
            "zen.theme.color-prefs.amoled" = true;
            "zen.theme.color-prefs.use-workspace-colors" = false;
            "zen.urlbar.behavior" = "normal";
            "zen.view.use-single-toolbar" = false;
            "zen.urlbar.replace-newtab" = false;

            # Transparent preferences
            "mod.sameerasw.zen_transparent_sidebar_enabled" = true;
            "mod.sameerasw.zen_transparent_glance_enabled" = true;
            "mod.sameerasw.zen_bg_color_enabled" = true;
            "mod.sameerasw_zen_empty_tab_logo" = 1;
            "mod.sameerasw.zen_transparency_color" = "${base00}96";
            "mod.sameerasw.zen_tab_switch_anim" = true;
            "mod.sameerasw.zen_urlbar_zoom_anim" = true;
            "mod.sameerasw.zen_trackpad_anim" = true;
          };
        };
      };
    };
}
