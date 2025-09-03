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
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
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
        { pkgs, ... }:
        {
          formatter = pkgs.nixfmt-rfc-style;
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              agenix
              home-manager
              nh
              nixos-anywhere
            ];
          };
        };

      flake = {
        homeConfigurations = {
          "nerdherd4043" = home-manager.lib.homeManagerConfiguration {
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
            # TODO: Check arch of system
            system = "x86_64-linux";
            specialArgs = { inherit self inputs; };
            modules = [
              ./nixos/modules
              ./nixos/hosts/poppy/configuration.nix
              inputs.disko.nixosModules.disko
            ];
          };
        };
      };
    };
}
