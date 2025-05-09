{
  config,
  lib,
  ...
}: {
  options.zeide.programs.gaming.waydroid = with lib; {
    hideDefaultEntries = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to hide default Android entries (settings app, calendar, play store, etc...).
        Other apps installed will not be affected.
      '';
    };
  };

  config = let
    selfConfig = config.zeide.programs.gaming.waydroid;

    hideApps = [
      "waydroid.com.android.calculator2"
      "waydroid.com.android.camera2"
      "waydroid.com.android.contacts"
      "waydroid.com.android.deskclock"
      "waydroid.com.android.documentsui"
      "waydroid.com.android.gallery3d"
      "waydroid.com.android.inputmethod.latin"
      "waydroid.com.android.settings"
      "waydroid.com.android.vending"
      "waydroid.org.lineageos.eleven"
      "waydroid.org.lineageos.etar"
      "waydroid.org.lineageos.jelly"
      "waydroid.org.lineageos.recorder"
    ];
  in {
    home.file =
      lib.mkIf selfConfig.hideDefaultEntries
      (builtins.listToAttrs (map (app: {
          name = ".local/share/applications/${app}.desktop";
          value = {
            text = ''
              [Desktop Entry]
              NoDisplay=true
            '';
            force = true;
          };
        })
        hideApps));
  };
}
