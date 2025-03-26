{ pkgs, ... }:
{
  imports = [
    # TODO: Add hardware-configuration.nix
    ./test-hw-conf.nix
  ];

  networking.hostName = "poppy";

  hardware.graphics = {
    enable = true;
    # TODO: Add relevant driver packages
    # https://wiki.nixos.org/wiki/Accelerated_Video_Playback
    # extraPackages = with pkgs; [ ];
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

  services.cage =
    let
      # TODO: Update to relevant URL
      url = "https://nerdherd4043.org/";
    in
    {
      enable = true;
      program = "/run/current-system/sw/bin/firefox --kiosk ${url}";
      extraArguments = [
        "-d"
        "-m last"
      ];
      environment = {
        WLR_LIBINPUT_NO_DEVICES = "1";
        MOZ_ENABLE_WAYLAND = "1";
      };
      user = "nerdherd4043";
    };

  environment.systemPackages = with pkgs; [
    curl
    git
    nh
    usbutils
  ];

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
