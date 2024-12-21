{
  description = "Zeide's NixOS configuration | @PZeide";

  inputs = {
    #
    # System inputs
    #

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #
    # User inputs
    #

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    apple-fonts = {
      url = "github:Lyndeno/apple-fonts.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs = {
        nixpkgs.follows = "hyprland/nixpkgs";
        hyprlang.follows = "hyprland/hyprlang";
      };
    };

    hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };

    hyprsplit = {
      url = "github:shezdy/hyprsplit";
      inputs.hyprland.follows = "hyprland";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    walker.url = "github:abenz1267/walker";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neve = {
      url = "github:redyf/Neve";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let
      nixosSystem' =
        system: modules:

        nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = {
            mod = module: ./system/${module}.nix;
            home = variant: import (./system/home/default.nix) variant;
            inherit inputs system;
          };

          modules = modules ++ [
            (import ./pkgs)
            {
              nixpkgs.overlays = [ inputs.nur.overlays.default ];
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        nilou = nixosSystem' "x86_64-linux" [
          ./hosts/nilou
        ];

        jane = nixosSystem' "x86_64-linux" [
          ./hosts/jane
        ];
      };
    };
}
