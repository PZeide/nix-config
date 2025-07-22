{
  config,
  lib,
  pkgs,
  inputs,
  system,
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
      violentmonkey
    ];

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

    zen-package = pkgs.wrapFirefox (inputs.zen-browser.packages.${system}.beta-unwrapped.override
      {
        policies = policies;
      }) {};
  in
    lib.mkIf selfConfig.enable {
      home.file.".zen/default/chrome/Nebula".source = "${inputs.zen-nebula}/Nebula";

      programs.zen-browser = {
        enable = true;
        package = lib.mkForce zen-package;

        profiles.default = with config.lib.stylix.colors.withHashtag; {
          isDefault = true;

          userChrome = ''
            @import "Nebula/Nebula.css";

            /* Disable close button */
            .titlebar-close {
              display: none !important;
            }
          '';

          userContent = ''
            @import "Nebula/Nebula-content.css";
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

            # Zen preferences
            "zen.theme.accent-color" = base0B;
            "zen.theme.color-prefs.amoled" = true;
            "zen.theme.color-prefs.use-workspace-colors" = false;
            "zen.urlbar.behavior" = "normal";
            "zen.view.use-single-toolbar" = false;
            "zen.urlbar.replace-newtab" = false;

            # Zen-Nebula config
            "nebula-disable-container-styling" = true;
          };

          extensions.packages = extensions;
        };
      };
    };
}
