{secrets, ...}: {
  # Not really an "app" but only the config file which will be used by all editors

  home.file.".wakatime.cfg".text = ''
    [settings]
    api_key_vault_cmd="cat ${secrets.wakatime-key.path}"
  '';
}
