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
  };

  config = let
    selfConfig = config.zeide.programs.zed;
  in
    lib.mkIf selfConfig.enable {
      programs.zed-editor = {
        enable = true;

        extraPackages = with pkgs; [
          nixd
          alejandra
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
            "golangci-lint"
            "graphql"
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
            "qml"
            "snippets"
            "sql"
            "svelte"
            "terraform"
            "toml"
            "vue"
            "xml"
            "zig"

            # Others
            "gitignore-template"
            "mistral-vibe"
          ]
          ++ (lib.optional (selfConfig.theme.extension != null) selfConfig.theme.extension);

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

          format_on_save = "on";
          formatter = "language_server";
          features.edit_prediction_provider = "codestral";

          theme = lib.mkForce selfConfig.theme.name;

          collaboration_panel.button = false;

          telemetry = {
            diagnostics = false;
            metrics = false;
          };

          languages = {
            Nix = {
              language_servers = ["nixd" "!nil"];
              formatter.external = {
                command = "alejandra";
                arguments = ["--quiet" "--"];
              };
            };

            JavaScript.formatter.language_server.name = "biome";
            TypeScript.formatter.language_server.name = "biome";
            TSX.formatter.language_server.name = "biome";
            JSON.formatter.language_server.name = "biome";
            JSONC.formatter.language_server.name = "biome";
            CSS.formatter.language_server.name = "biome";
            GraphQL.formatter.language_server.name = "biome";
          };
        };

        mutableUserKeymaps = false;
        mutableUserSettings = false;
      };

      stylix.targets.zed.enable = true;
    };
}
