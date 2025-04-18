{
  config,
  lib,
  pkgs,
  ...
}: {
  options.zeide.programs.vscodium = with lib; {
    enable = mkEnableOption "vscodium code editor";

    colorTheme = {
      name = mkOption {
        type = types.str;
        description = ''
          Color theme to set.
        '';
        default = "Default Dark Modern";
      };

      package = mkOption {
        type = with types; nullOr package;
        description = ''
          Package of the color theme to set.
        '';
        default = null;
      };
    };

    iconTheme = {
      name = mkOption {
        type = types.str;
        description = ''
          Icon theme to set.
        '';
        default = "vs-seti";
      };

      package = mkOption {
        type = with types; nullOr package;
        description = ''
          Package of the icon theme to set.
        '';
        default = null;
      };
    };
  };

  config = let
    selfConfig = config.zeide.programs.vscodium;
  in
    lib.mkIf selfConfig.enable {
      programs.vscode = {
        enable = true;
        package = pkgs.vscodium;

        mutableExtensionsDir = false;

        profiles.default = {
          enableUpdateCheck = false;
          enableExtensionUpdateCheck = false;

          extensions = with pkgs.vscode-marketplace;
            [
              # General
              wakatime.vscode-wakatime
              maattdd.gitless
              usernamehw.errorlens
              fabiospampinato.vscode-todo-plus

              # Formatters
              esbenp.prettier-vscode
              tamasfe.even-better-toml

              # Nix
              jnoortheen.nix-ide

              # JavaScript / TypeScript / Web
              chamboug.js-auto-backticks
              dbaeumer.vscode-eslint
              bradlc.vscode-tailwindcss
              vue.volar
              prisma.prisma

              # GraphQL
              graphql.vscode-graphql
              graphql.vscode-graphql-syntax

              # Rust
              rust-lang.rust-analyzer

              # Python
              ms-python.python
            ]
            ++ (lib.optionals (selfConfig.colorTheme.package != null) [selfConfig.colorTheme.package])
            ++ (lib.optionals (selfConfig.iconTheme.package != null) [selfConfig.iconTheme.package]);

          userSettings = let
            formattersConfig = {
              javascript = "esbenp.prettier-vscode";
              javascriptreact = "esbenp.prettier-vscode";
              typescript = "esbenp.prettier-vscode";
              typescriptreact = "esbenp.prettier-vscode";
              json = "esbenp.prettier-vscode";
              jsonc = "esbenp.prettier-vscode";
              json5 = "esbenp.prettier-vscode";
              css = "esbenp.prettier-vscode";
              postcss = "esbenp.prettier-vscode";
              less = "esbenp.prettier-vscode";
              scss = "esbenp.prettier-vscode";
              graphql = "esbenp.prettier-vscode";
              markdown = "esbenp.prettier-vscode";
              mdx = "esbenp.prettier-vscode";
              html = "esbenp.prettier-vscode";
              handlebars = "esbenp.prettier-vscode";
              vue = "esbenp.prettier-vscode";
              yaml = "esbenp.prettier-vscode";
            };
          in
            with config.stylix.fonts;
              {
                "breadcrumbs.enabled" = true;

                "editor.colorDecorators" = true;
                "editor.tabSize" = 2;
                "editor.detectIndentation" = true;
                "editor.wordWrap" = "on";
                "editor.smoothScrolling" = true;

                "editor.cursorBlinking" = "smooth";
                "editor.cursorSmoothCaretAnimation" = "on";
                "editor.cursorStyle" = "line";

                "editor.bracketPairColorization.enabled" = true;
                "editor.bracketPairColorization.independentColorPoolPerBracketType" = true;

                "editor.formatOnSave" = true;
                "editor.formatOnPaste" = true;

                "terminal.integrated.fontFamily" = lib.mkForce "'${monospace.name}', 'Symbols Nerd Font Mono'";
                "editor.fontFamily" = lib.mkForce "'${monospace.name}', 'Symbols Nerd Font Mono'";

                "terminal.integrated.cursorBlinking" = true;

                "files.eol" = "\n";
                "files.insertFinalNewline" = true;
                "files.trimTrailingWhitespace" = true;

                "git.autofetch" = true;
                "git.confirmSync" = false;
                "git.enableSmartCommit" = true;
                "git.showInlineOpenFileAction" = false;
                "git.openRepositoryInParentFolders" = "never";
                "git.decorations.enabled" = true;

                "window.menuBarVisibility" = "hidden";
                "window.zoomLevel" = 1;

                "workbench.colorTheme" = lib.mkForce selfConfig.colorTheme.name;
                "workbench.iconTheme" = selfConfig.iconTheme.name;
                "workbench.startupEditor" = "none";
                "workbench.list.smoothScrolling" = true;

                "nix.enableLanguageServer" = true;
                "nix.serverPath" = lib.getExe pkgs.nixd;
                "nix.hiddenLanguageServerErrors" = [
                  "textDocument/formatting"
                  "textDocument/definition"
                ];
                "nix.serverSettings"."nixd"."formatting"."command" = [
                  (lib.getExe pkgs.alejandra)
                ];

                "workbench.colorCustomizations" = {
                  "[${selfConfig.colorTheme.name}]" = with config.lib.stylix.colors.withHashtag; {
                    "terminal.ansiBlack" = "${base00}";
                    "terminal.ansiRed" = "${base08}";
                    "terminal.ansiGreen" = "${base0B}";
                    "terminal.ansiYellow" = "${base0A}";
                    "terminal.ansiBlue" = "${base0D}";
                    "terminal.ansiMagenta" = "${base0E}";
                    "terminal.ansiCyan" = "${base0C}";
                    "terminal.ansiWhite" = "${base05}";
                    "terminal.ansiBrightBlack" = "${base03}";
                    "terminal.ansiBrightRed" = "${base09}";
                    "terminal.ansiBrightGreen" = "${base01}";
                    "terminal.ansiBrightYellow" = "${base02}";
                    "terminal.ansiBrightBlue" = "${base04}";
                    "terminal.ansiBrightMagenta" = "${base06}";
                    "terminal.ansiBrightCyan" = "${base0F}";
                    "terminal.ansiBrightWhite" = "${base07}";
                  };
                };
              }
              // lib.foldlAttrs (acc: lang: formatter:
                {
                  "[${lang}]"."editor.defaultFormatter" = formatter;
                }
                // acc) {}
              formattersConfig;
        };
      };

      stylix.targets.vscode.enable = true;
    };
}
