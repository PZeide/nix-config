{
  programs = {
    command-not-found.enable = false;
    nix-index.enable = true;

    bat.enable = true;
    jq.enable = true;
    eza.enable = true;
    zoxide.enable = true;

    btop = {
      enable = true;
      settings = {
        theme_background = false;
        rounded_corners = true;
      };
    };

    fastfetch = {
      enable = true;

      settings = {
        logo = {
          type = "none";
        };

        display = {
          separator = "  ";
        };

        modules = [
          {
            type = "title";
            format = "{#1}╭───────────── {#}{user-name-colored} ─────────";
          }
          {
            type = "custom";
            format = "{#1}│ {#}System Information";
          }
          {
            type = "os";
            key = "{#separator}│  {#keys}󰍹 OS";
          }
          {
            type = "kernel";
            key = "{#separator}│  {#keys}󰒋 Kernel";
          }
          {
            type = "uptime";
            key = "{#separator}│  {#keys}󰅐 Uptime";
          }
          {
            type = "packages";
            key = "{#separator}│  {#keys}󰏖 Packages";
            format = "{all}";
          }
          {
            type = "custom";
            format = "{#1}│";
          }
          {
            type = "custom";
            format = "{#1}│ {#}Desktop Environment";
          }
          {
            type = "de";
            key = "{#separator}│  {#keys}󰧨 DE";
          }
          {
            type = "wm";
            key = "{#separator}│  {#keys}󱂬 WM";
          }
          {
            type = "wmtheme";
            key = "{#separator}│  {#keys}󰉼 Theme";
          }
          {
            type = "display";
            key = "{#separator}│  {#keys}󰹑 Resolution";
          }
          {
            type = "shell";
            key = "{#separator}│  {#keys}󰞷 Shell";
          }
          {
            type = "custom";
            format = "{#1}│";
          }
          {
            type = "custom";
            format = "{#1}│ {#}Hardware Information";
          }
          {
            type = "cpu";
            key = "{#separator}│  {#keys}󰻠 CPU";
          }
          {
            type = "gpu";
            key = "{#separator}│  {#keys}󰢮 GPU";
          }
          {
            type = "memory";
            key = "{#separator}│  {#keys}󰍛 Memory";
          }
          {
            type = "disk";
            key = "{#separator}│  {#keys}󰋊 Disk (/)";
            folders = "/";
          }
          {
            type = "custom";
            format = "{#1}│";
          }
          {
            type = "colors";
            key = "{#separator}│";
            symbol = "circle";
          }
          {
            type = "custom";
            format = "{#1}╰───────────────────────────────────────────────────";
          }
        ];
      };
    };
  };

  stylix.targets.bat.enable = true;
  stylix.targets.btop.enable = true;
}
