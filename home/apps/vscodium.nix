{
  config,
  inputs,
  lib,
  pkgs,
  system,
  ...
}:

let
  cfg = config.home.vscodium;
in
{
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
      nixfmt-rfc-style
      nil
    ];

    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;

      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;

      mutableExtensionsDir = false;

      extensions =
        with inputs.nix-vscode-extensions.extensions.${system}.vscode-marketplace;
        [
          # Formatter
          esbenp.prettier-vscode

          # Nix dev
          jnoortheen.nix-ide

          # Web dev
          dbaeumer.vscode-eslint
          bradlc.vscode-tailwindcss
          vue.volar
          graphql.vscode-graphql
          graphql.vscode-graphql-syntax
        ]
        ++ (pkgs.lib.optionals (cfg.colorThemePackage != null) [ cfg.colorThemePackage ]);

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
        "nix.hiddenLanguageServerErrors" = [
          "textDocument/formatting"
          "textDocument/documentSymbol"
        ];
        "nix.serverPath" = lib.getExe pkgs.nil;
        "nix.serverSettings" = {
          "nil" = {
            "formatting" = {
              "command" = [
                (lib.getExe pkgs.nixfmt-rfc-style)
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
