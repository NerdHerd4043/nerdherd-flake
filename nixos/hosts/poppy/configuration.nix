{ config, ... }:
{
  imports = [
    # TODO: Add hardware-configuration.nix
    ./test-hw-conf.nix
  ];

  networking = {
    hostName = "poppy";
    openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  users = {
    mutableUsers = false;
    users = {
      nerdherd4043 = {
        isNormalUser = true;
        extraGroups = [
          "networkManager"
          "video"
          "wheel"
        ];
        hashedPassword = "$y$j9T$BN5fvfmYxHqJVGoHUmle.0$fxCfLjaVXeRYRBB1Zju5OEQN.tNic88jyLq.wYbaqZD";
        openssh.authorizedKeys.keys = [
          # TODO: ADD SSH KEYS BEFORE INSTALLATION
        ];
      };

      root.openssh.authorizedKeys.keys = [
        # TODO: (Optional) add root keys for ease of deployment
      ];
    };
  };

  nix = {
    optimise.automatic = true;
    channel.enable = false;
    settings = {
      auto-optimise-store = true;

      # Flakes
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
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

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
