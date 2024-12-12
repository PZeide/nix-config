{ pkgs, ... }:

{
  home.packages = with pkgs; [
    podman-tui
    dive
    devbox
  ];

  home.shellAliases = {
    g = "git";
  };

  programs.git = {
    enable = true;

    userName = "Zeide";
    userEmail = "zeide.thibaud@gmail.com";

    signing = {
      key = "~/.ssh/id_ed25519.pub";
      signByDefault = true;
    };

    aliases = {
      a = "add";
      aa = "add -A";
      b = "branch";
      ba = "branch -a";
      c = "commit -m";
      ca = "commit -am";
      pl = "pull";
      ps = "push";
      co = "checkout";
      cob = "checkout -b";
      contributors = "shortlog -nse";
      d = "difftool";
      ds = "difftool --staged";
      lg = "log --graph --pretty='%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset'";
      remotes = "remote -v";
      s = "status -sb";
      undo = "reset HEAD~1";
    };

    extraConfig = {
      gpg.format = "ssh";
      init.defaultBranch = "main";
      core.editor = "nvim";
      color.ui = true;

      push = {
        default = "simple";
        autoSetupRemote = true;
      };
    };

    delta = {
      enable = true;

      options = {
        navigate = true;
        side-by-side = true;
        true-color = "never";

        features = "unobtrusive-line-numbers decorations";
        unobtrusive-line-numbers = {
          line-numbers = true;
          line-numbers-left-format = "{nm:>4}│";
          line-numbers-right-format = "{np:>4}│";
          line-numbers-left-style = "grey";
          line-numbers-right-style = "grey";
        };

        decorations = {
          commit-decoration-style = "bold grey box ul";
          file-style = "bold blue";
          file-decoration-style = "ul";
          hunk-header-decoration-style = "box";
        };
      };
    };
  };
}
