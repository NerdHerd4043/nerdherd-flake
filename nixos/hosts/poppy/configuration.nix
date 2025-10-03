{ pkgs, lib, ... }:
{
  imports = [
    ./disk-configuration.nix
    ./hardware-configuration.nix
  ];

  herd = {
    networking.wifi.enable = true;
  };

  networking.hostName = "poppy";

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      # For i5-6500T:
      intel-media-driver
    ];
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
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ3jJxl0RQclWmAUbA2/o5qvIt+yXzF+J3xkHQdr7PlP"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDwZSohB4Ub1uoMZ2rHM7zgK+oBl7CGakKQo3emz2z5b" # Bitwarden
        ];
      };
    };
  };

  programs.firefox.enable = true;

  services.cage =
    let
      # TODO: Update to relevant URL
      url = "https://www.firstinspires.org/";
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
        # WLR_LIBINPUT_NO_DEVICES = "1"; # Disable input devices (maybe?)
        MOZ_ENABLE_WAYLAND = "1";
      };
      user = "nerdherd4043";
    };

  # Always restart the browser when closed
  systemd.services."cage-tty1".serviceConfig.Restart = "always";

  environment.systemPackages = with pkgs; [
    curl
    git
    lazygit
    neovim
    nh
    usbutils
  ];

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
    openFirewall = true;
  };

  networking.firewall.trustedInterfaces = [ "tailscale0" ];

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
