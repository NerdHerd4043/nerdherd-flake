{ config, lib, ... }:

let
  cfg = config.herd.networking;
  inherit (lib)
    mkDefault
    mkEnableOption
    mkForce
    mkIf
    ;
in
{
  options.herd.networking = {
    enable = mkEnableOption "networking module";
    wifi = mkEnableOption "wifi specific settings and services.";
    disableSSH = mkEnableOption "disabling ssh systemd service";
  };

  config = mkIf cfg.enable {
    # Enable networking
    networking = {
      wireless.iwd = {
        enable = cfg.wifi;
        settings = {
          IPv6.Enabled = true;
          Settings.AutoConnect = true;
        };
      };

      networkmanager = {
        enable = true;
        wifi.backend = mkIf cfg.wifi "iwd";
      };
    };

    programs.mosh.enable = true;
    services.avahi = {
      enable = true;
    };

    # Enable the OpenSSH daemon.
    services.openssh = {
      enable = mkDefault true;
      openFirewall = mkDefault true;
      settings = {
        PasswordAuthentication = mkDefault false;
        KbdInteractiveAuthentication = mkDefault false;
      };
    };

    systemd.services.sshd.wantedBy = mkIf cfg.disableSSH (mkForce [ ]);
  };
}
