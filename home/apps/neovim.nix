{ inputs, ... }:

{
  imports = [ inputs.nixvim.homeManagerModules.nixvim ];

  home.shellAliases = {
    n = "nvim";
  };

  programs.nixvim = {
    enable = true;
    imports = [ inputs.neve.nixvimModule ];
  };
}
