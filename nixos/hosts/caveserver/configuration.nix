{
  config,
  self,
  pkgs,
  ...
}:
{
  imports = [
    ./disk-configuration.nix
    ./hardware-configuration.nix
  ];

  herd = {
    ddclient.enable = true;
    # TODO: Enable after testing
    # minecraft-server.enable = true;
  };

  networking = {
    hostName = "caveserver";
    fqdn = "emerald.nerdherd4043.org";
  };

  age.secrets = {
    bryan-pass.file = self + "/secrets/bryan-pass.age";
    nullcube-pass.file = self + "/secrets/nullcube-pass.age";
    ravenshade-pass.file = self + "/secrets/ravenshade-pass.age";
  };

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
      bryan = {
        isNormalUser = true;
        description = "Bryan";
        # TODO: Add bryan password
        # hashedPasswordFile = config.age.secrets.bryan-pass.path;
        extraGroups = [
          "networkmanager"
          "video"
          "wheel"
        ];
        openssh.authorizedKeys.keys = [
          # TODO: Add ssh keys
        ];
      };

      nullcube = {
        isNormalUser = true;
        description = "NullCube";
        extraGroups = [
          "networkmanager"
          "video"
          "wheel"
        ];
        hashedPasswordFile = config.age.secrets.nullcube-pass.path;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGrPcaW3xInHVO2toJ8awiJlvgy8USQ9Rhynf2Yk8w8M nullcube@Vulcan"
        ];
      };

      ravenshade = {
        isNormalUser = true;
        description = "Zynh";
        # TODO: Add ravenshade password
        # hashedPasswordFile = config.age.secrets.ravenshade-pass.path;
        extraGroups = [
          "networkmanager"
          "video"
          "wheel"
        ];
        openssh.authorizedKeys.keys = [
          # TODO: Add ssh keys
        ];
      };
    };
  };

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
