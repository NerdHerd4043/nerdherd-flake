{ config, lib, ... }:
let
  cfg = config.herd.nginx;
  inherit (lib)
    mkEnableOption
    mkIf
    ;
in
{
  options.herd.nginx = {
    enable = mkEnableOption "nginx module" // {
      default = config.services.nginx.enable;
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [
      80
      443
    ];

    services.nginx = {
      # https://wiki.nixos.org/wiki/Nginx#Hardened_setup_with_TLS_and_HSTS_preloading
      # Use recommended settings
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      # Only allow PFS-enabled ciphers with AES256
      sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";

      appendHttpConfig = ''
        # Enable CSP for your services.
        # add_header Content-Security-Policy "script-src 'self'; object-src 'none'; base-uri 'none';" always;

        # Minimize information leaked to other domains
        add_header 'Referrer-Policy' 'origin-when-cross-origin';

        # DENY = Disable embedding as a frame
        # SAMEORIGIN = Only allow if from the same website
        add_header X-Frame-Options SAMEORIGIN;

        # Prevent injection of code in other mime types (XSS Attacks)
        add_header X-Content-Type-Options nosniff;
      '';
    };
  };
}
