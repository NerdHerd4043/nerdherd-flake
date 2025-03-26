{ pkgs, ... }:
{
  imports = [
    # TODO: Add hardware-configuration.nix
    ./test-hw-conf.nix
  ];

  herd = {
    networking.wifi.enable = true;
  };

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
    };
  };

  programs.firefox = {
    enable = true;
    preferences = {
      # TODO: Edit firefox preferences for accelerated video playback
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
        "-d" # Don't render client-side decorations
        "-m last" # Use only the last monitor connected
        "-s" # Allow TTY switching
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
