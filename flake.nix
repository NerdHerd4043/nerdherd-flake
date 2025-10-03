{
  description = "Nix configurations for nerdherd4043";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-parts,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      perSystem =
        { pkgs, system, ... }:
        {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [
              inputs.agenix.overlays.default
            ];
            config.allowUnfree = true;
          };

          formatter = pkgs.nixfmt-rfc-style;

          packages = {
            nixos-anywhere-install = import ./pkgs/nixos-anywhere-install.nix { inherit pkgs; };
          };

          devShells = {
            default = pkgs.mkShell {
              packages = with pkgs; [
                agenix
                home-manager
                nh
                nixos-anywhere
              ];
            };
          };
        };

      flake = {
        homeConfigurations = {
          "nerdherd4043" = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = import nixpkgs {
              system = "x86_64-linux";
              overlays = [
                inputs.agenix.overlays.default
                inputs.rust-overlay.overlays.default
              ];
            };
            modules = [ ./home/hosts/nerdherd4043.nix ];
          };
        };

        nixosConfigurations = {
          poppy = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit self inputs; };
            modules = [
              ./nixos/modules
              ./nixos/hosts/poppy/configuration.nix
              inputs.agenix.nixosModules.default
              inputs.disko.nixosModules.disko
            ];
          };

          caveserver = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit self inputs; };
            modules = [
              ./nixos/modules
              ./nixos/hosts/caveserver/configuration.nix
              inputs.agenix.nixosModules.default
              inputs.disko.nixosModules.disko
            ];
          };
        };
      };
    };
}
