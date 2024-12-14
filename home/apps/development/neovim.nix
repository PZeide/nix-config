{ inputs, ... }:

{
  imports = [ inputs.nixvim.homeManagerModules.nixvim ];

  home.shellAliases = {
    n = "nvim";
  };

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    imports = [ inputs.neve.nixvimModule ];
  };
}
