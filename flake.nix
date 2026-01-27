{
  description = "Zeide's NixOS configuration | @PZeide";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    devenv.url = "github:cachix/devenv/v1.11.2";

    stylix = {
      # FIXME matugen branch
      url = "github:nix-community/stylix/89d5e0bffe49c3fa285e93556159be5e27fd600a";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    affinity-nix = {
      url = "github:mrshmllow/affinity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    hyprsplit = {
      url = "github:shezdy/hyprsplit";
      inputs.hyprland.follows = "hyprland";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake/beta";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    bubble-clean-zen = {
      url = "github:nieffka/bubble-clean-zen";
      flake = false;
    };

    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    elysia = {
      url = "git+https://dawn.wine/foxtrottt/elysia-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-webapps = {
      url = "github:TLATER/nix-webapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixcord = {
      url = "github:kaylorben/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wifitui = {
      url = "github:shazow/wifitui";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    librepods = {
      url = "github:Chrisbattarbee/librepods";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    bunny-yazi = {
      url = "github:stelcodes/bunny.yazi";
      flake = false;
    };

    shiny-shell = {
      url = "github:PZeide/shiny-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {nixpkgs, ...} @ inputs: let
    nixosSystem' = system: host:
      nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit
            inputs
            system
            host
            ;

          asset = file: ./assets/${file};
        };

        modules = [
          inputs.agenix.nixosModules.default
          inputs.home-manager.nixosModules.home-manager
          ./packages
          ./modules
          ./hosts/${host}/hardware.nix
          ./hosts/${host}/system.nix
        ];
      };
  in {
    nixosConfigurations = {
      nilou = nixosSystem' "x86_64-linux" "nilou";
      jane = nixosSystem' "x86_64-linux" "jane";
    };
  };
}
