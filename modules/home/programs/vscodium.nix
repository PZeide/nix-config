{
  config,
  secrets,
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

      extension = mkOption {
        type = with types; nullOr str;
        description = ''
          Extension id of the color theme to set.
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
        default = "flow-dark";
      };

      extension = mkOption {
        type = with types; nullOr str;
        description = ''
          Extension id of the icon theme to set.
        '';
        default = "thang-nm.flow-icons";
      };
    };
  };

  config = let
    selfConfig = config.zeide.programs.vscodium;

    settingsPath = "${config.xdg.configHome}/VSCodium/User/settings.json";
    settingsStorePath = config.home.file."${settingsPath}".source;

    autoExtensions = pkgs.nix4vscode.forVscodePrerelease ([
        # General
        "maattdd.gitless"
        "usernamehw.errorlens"
        "fabiospampinato.vscode-todo-plus"
        "mkhl.direnv"

        # Formatters / Linters
        "biomejs.biome"
        "esbenp.prettier-vscode"
        "tamasfe.even-better-toml"
        "redhat.vscode-yaml"

        # Nix
        "jnoortheen.nix-ide"

        # JavaScript / TypeScript / Web
        "chamboug.js-auto-backticks"
        "dbaeumer.vscode-eslint"
        "bradlc.vscode-tailwindcss"
        "Vue.volar"
        "svelte.svelte-vscode"

        # GraphQL
        "GraphQL.vscode-graphql"
        "GraphQL.vscode-graphql-syntax"

        # Rust
        "rust-lang.rust-analyzer"

        # Nushell
        "TheNuProjectContributors.vscode-nushell-lang"

        # Shell
        "timonwong.shellcheck"

        # QT / QML
        "TheQtCompany.qt-core"
        "TheQtCompany.qt-qml"

        # C/C++
        "llvm-vs-code-extensions.vscode-clangd"
        "mesonbuild.mesonbuild"
      ]
      ++ (lib.optional (selfConfig.colorTheme.extension != null) selfConfig.colorTheme.extension)
      ++ (lib.optional (selfConfig.iconTheme.extension != null && selfConfig.iconTheme.extension != "thang-nm.flow-icons")
        selfConfig.iconTheme.extension)
      ++ (lib.optional (config.zeide.services.wakatime.enable) "wakatime.vscode-wakatime"));

    pkgsExtensions = with pkgs.vscode-extensions; [
      ms-vscode.cmake-tools
      vadimcn.vscode-lldb
      foxundermoon.shell-format
      ms-python.python
    ];
  in
    lib.mkIf selfConfig.enable {
      home = {
        activation.vscodiumSettings =
          lib.hm.dag.entryAfter
          ["writeBoundary"]
          ''
            template="${settingsStorePath}"
            target="${settingsPath}"

            flowicons_license=$(cat "${secrets.flowicons-license.path}")

            mkdir -p "$(dirname "$target")"
            ${pkgs.gnused}/bin/sed "s#@flowicons-license-age@#$flowicons_license#g" "$template" > "$target"
          '';

        file."${settingsPath}".enable = false;
      };

      programs.vscode = {
        enable = true;
        package = pkgs.vscodium;

        mutableExtensionsDir = true;
        profiles.default = {
          enableUpdateCheck = false;
          enableExtensionUpdateCheck = false;

          extensions = autoExtensions ++ pkgsExtensions;

          userSettings = let
            formatterConfig = {
              "biomejs.biome" = [
                "javascript"
                "javascriptreact"
                "typescript"
                "typescriptreact"
                "astro"
                "svelte"
                "vue"
                "tailwind"
                "json"
                "jsonc"
                "css"
                "graphql"
              ];

              "esbenp.prettier-vscode" = [
                "html"
                "postcss"
                "less"
                "scss"
              ];

              "foxundermoon.shell-format" = [
                "shellscript"
                "dockerfile"
              ];

              "tamasfe.even-better-toml" = ["toml"];

              "redhat.vscode-yaml" = ["yaml"];

              "mesonbuild.mesonbuild" = ["meson"];

              "llvm-vs-code-extensions.vscode-clangd" = [
                "c"
                "cpp"
                "cuda-cpp"
                "objective-c"
                "objective-cpp"
              ];

              "ms-python.python" = ["python"];
            };

            formatterSettings =
              lib.foldlAttrs (
                acc: formatter: langs:
                  acc
                  // builtins.listToAttrs (map (lang: {
                      name = "[${lang}]";
                      value = {"editor.defaultFormatter" = formatter;};
                    })
                    langs)
              ) {}
              formatterConfig;
          in
            with config.stylix.fonts;
              {
                # Force configure lsp paths to avoid issues
                "biome.lsp.bin" = lib.getExe pkgs.biome;
                "prettier.prettierPath" = "${pkgs.nodePackages.prettier}/lib/node_modules/prettier/";
                "nix.serverPath" = lib.getExe pkgs.nixd;
                "nix.serverSettings"."nixd"."formatting"."command" = [
                  (lib.getExe pkgs.alejandra)
                ];
                "shellcheck.executablePath" = lib.getExe pkgs.shellcheck;
                "qt-qml.qmlls.customExePath" = "${pkgs.qt6.qtdeclarative}/bin/qmlls";
                "clangd.path" = "${pkgs.clang-tools}/bin/clangd";
                "mesonbuild.languageServerPath" = pkgs.lib.getExe pkgs.mesonlsp;

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
                "editor.codeActionsOnSave" = {
                  "source.organizeImports.biome" = "explicit";
                };

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

                "flow-icons.licenseKey" = "@flowicons-license-age@";

                "nix.enableLanguageServer" = true;
                "nix.hiddenLanguageServerErrors" = [
                  "textDocument/formatting"
                  "textDocument/definition"
                ];

                "svelte.enable-ts-plugin" = true;
                "qt-qml.doNotAskForQmllsDownload" = true;

                "mesonbuild.downloadLanguageServer" = false;
                "mesonbuild.languageServer" = "mesonlsp";
                "mesonbuild.modifySettings" = false;

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
              // formatterSettings;
        };
      };

      stylix.targets.vscode.enable = true;
    };
}
