{
  config,
  inputs,
  lib,
  pkgs,
  system,
  ...
}: let
  cfg = config.home.vscodium;
in {
  options.home.vscodium = with lib; {
    colorTheme = mkOption {
      type = types.str;
      description = ''
        Color theme to set.
      '';
      default = "Default Dark Modern";
    };

    colorThemePackage = mkOption {
      type = with types; nullOr package;
      description = ''
        Package of the theme to set.
      '';
      default = null;
    };
  };

  config = {
    home.packages = with pkgs; [
      alejandra
      nixd
    ];

    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;

      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;

      mutableExtensionsDir = false;

      extensions = with inputs.nix-vscode-extensions.extensions.${system}.vscode-marketplace;
        [
          wakatime.vscode-wakatime

          # Misc
          esbenp.prettier-vscode
          tamasfe.even-better-toml

          # Tauri
          tauri-apps.tauri-vscode

          # Nix
          jnoortheen.nix-ide

          # JS
          dbaeumer.vscode-eslint
          bradlc.vscode-tailwindcss
          vue.volar
          prisma.prisma

          # GraphQL
          graphql.vscode-graphql
          graphql.vscode-graphql-syntax

          # Flutter
          dart-code.dart-code
          dart-code.flutter

          # Rust
          rust-lang.rust-analyzer
        ]
        ++ (pkgs.lib.optionals (cfg.colorThemePackage != null) [cfg.colorThemePackage]);

      userSettings = with config.stylix.fonts; {
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
        "editor.defaultFormatter" = "esbenp.prettier-vscode";

        "[nix]" = {
          "editor.defaultFormatter" = "jnoortheen.nix-ide";
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

        "workbench.colorTheme" = lib.mkForce cfg.colorTheme;
        "workbench.startupEditor" = "none";
        "workbench.list.smoothScrolling" = true;

        "nix.enableLanguageServer" = true;
        "nix.serverPath" = lib.getExe pkgs.nixd;
        "nix.hiddenLanguageServerErrors" = [
          "textDocument/formatting"
          "textDocument/definition"
        ];
        "nix.serverSettings" = {
          "nixd" = {
            "formatting" = {
              "command" = [
                (lib.getExe pkgs.alejandra)
              ];
            };
          };
        };

        "workbench.colorCustomizations" = {
          "[${cfg.colorTheme}]" = with config.lib.stylix.colors.withHashtag; {
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
      };
    };

    stylix.targets.vscode.enable = true;
  };
}
