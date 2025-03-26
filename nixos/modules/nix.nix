{
  inputs,
  config,
  lib,
  ...
}:

let
  cfg = config.herd.nix;
  inherit (lib)
    mkDefault
    mkEnableOption
    mkIf
    ;
in
{
  options.herd.nix = {
    enable = mkEnableOption "herd nix";
  };

  config = mkIf cfg.enable {
    nix = {
      # Auto Maintainence
      optimise.automatic = true;

      # Channels
      channel.enable = false;
      nixPath = [
        "nixpkgs=${inputs.nixpkgs}"
        "home-manager=${inputs.home-manager}"
      ];

      settings = {
        auto-optimise-store = true;

        # Flakes
        experimental-features = [
          "nix-command"
          "flakes"
        ];

        trusted-users = mkDefault [
          "nerdherd4043"
        ];

        substituters = [
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
        ];

        trusted-substituters = config.nix.settings.substituters;

        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };
    };
  };
}
