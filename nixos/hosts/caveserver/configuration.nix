{ pkgs, ... }:
{
  imports = [
    ./disk-configuration.nix
    # TODO: Hardware configuration
    # ./hardware-configuration.nix
  ];

  herd = {
  };

  networking.hostName = "caveserver";

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      # For intel i7-4820K
      intel-vaapi-driver
    ];
  };

  users = {
    mutableUsers = false;
    users = {
      nerdherd4043 = {
        isNormalUser = true;
        extraGroups = [
          "networkmanager"
          "video"
          "wheel"
        ];
        hashedPassword = "$y$j9T$BN5fvfmYxHqJVGoHUmle.0$fxCfLjaVXeRYRBB1Zju5OEQN.tNic88jyLq.wYbaqZD";
        openssh.authorizedKeys.keys = [
          # TODO: Add SSH keys
        ];
      };
    };
  };

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
