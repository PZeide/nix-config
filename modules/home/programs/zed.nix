{
  config,
  lib,
  pkgs,
  ...
}: {
  options.zeide.programs.zed = with lib; {
    enable = mkEnableOption "zed editor";

    theme = {
      name = mkOption {
        type = types.str;
        description = ''
          Theme to set.
        '';
        default = "Yūgen Kuro (幽玄黒)";
      };

      extension = mkOption {
        type = with types; nullOr str;
        description = ''
          Extension id of the theme to set.
        '';
        default = "yugen";
      };
    };

    iconTheme = {
      name = mkOption {
        type = types.str;
        description = ''
          Icon theme to set.
        '';
        default = "Zed (Default)";
      };

      extension = mkOption {
        type = with types; nullOr str;
        description = ''
          Extension id of the icon theme to set.
        '';
        default = null;
      };
    };
  };

  config = let
    cfg = config.zeide.programs.zed;
  in
    lib.mkIf cfg.enable {
      programs.zed-editor = {
        enable = true;

        extraPackages = with pkgs; [
          nixd
          alejandra
          clang-tools
        ];

        extensions =
          [
            # LSPs & Syntax higlighting
            "angular"
            "astro"
            "basher"
            "biome"
            "cargo-tom"
            "csharp"
            "csv"
            "dockerfile"
            "env"
            "fish"
            "git-firefly"
            "glsl"
            "golangci-lint"
            "graphql"
            "hsls"
            "html"
            "hurl"
            "ini"
            "java"
            "kotlin"
            "make"
            "mdx"
            "meson"
            "neocmake"
            "nix"
            "oxc"
            "qml"
            "slang"
            "snippets"
            "sql"
            "svelte"
            "terraform"
            "toml"
            "typespec"
            "vue"
            "xml"
            "zig"

            # Others
            "gitignore-template"
          ]
          ++ (lib.optional (cfg.theme.extension != null) cfg.theme.extension)
          ++ (lib.optional (cfg.iconTheme.extension != null) cfg.iconTheme.extension);

        userKeymaps = [
          {
            bindings = {
              "ctrl-alt-i" = "project_panel::ToggleHideGitIgnore";
            };
          }
        ];

        userSettings = {
          auto_update = false;
          base_keymap = "VSCode";
          load_direnv = "direct";
          ensure_final_newline_on_save = true;

          lsp = {
            biome.settings.require_config_file = true;
            nixd.initialization_options.formatting.command = ["alejandra" "--quiet" "--"];
            yaml-language-server.settings.yaml.schemaStore.enable = true;
          };

          agent_servers.codex-acp.type = "registry";
          format_on_save = "on";
          formatter = "language_server";

          theme = lib.mkForce cfg.theme.name;
          icon_theme = lib.mkForce cfg.iconTheme.name;

          collaboration_panel.button = false;

          telemetry = {
            diagnostics = false;
            metrics = false;
          };

          languages.Nix = {
            language_servers = ["nixd" "!nil"];
            formatter.external = {
              command = "alejandra";
              arguments = ["--quiet" "--"];
            };
          };
        };

        mutableUserKeymaps = false;
        mutableUserSettings = true;
      };

      stylix.targets.zed.enable = true;
    };
}
