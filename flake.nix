{
  description = "Zeide's NixOS configuration | @PZeide";

  inputs = {
    #
    # System inputs
    #

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
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

    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland?ref=v0.45.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };

    hyprsplit = {
      # Use commit b98cc80aab041677cd7648f6e44c18e8f36fa907 because there is an issue with flakes recently
      url = "github:shezdy/hyprsplit?ref=b98cc80aab041677cd7648f6e44c18e8f36fa907";
      inputs.hyprland.follows = "hyprland";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    walker = {
      url = "github:abenz1267/walker";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:fufexan/zen-browser-flake";
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

          modules = modules;
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
