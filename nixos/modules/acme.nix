{ config, lib, ... }:
let
  cfg = config.herd.acme;
  inherit (lib)
    mkEnableOption
    mkIf
    ;
in
{
  options.herd.acme = {
    enable = mkEnableOption "acme module";
  };

  config = mkIf cfg.enable {
    security.acme = {
      acceptTerms = true;
      defaults = {
        email = "thenerdherd4043+acme@gmail.com";
        group = config.services.nginx.group;
        credentialFiles = {
          "CF_DNS_API_TOKEN_FILE" = config.age.secrets.cf-dns-token.path;
        };
      };

      certs = {
        "nerdherd4043.org" = {
          dnsProvider = "cloudflare";
          extraDomainNames = [ "*.nerdherd4043.org" ];
        };
      };
    };
  };
}
