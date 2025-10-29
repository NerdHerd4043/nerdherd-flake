{ config, lib, self, ... }:
let
  cfg = config.herd.acme;
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    ;
in
{
  options.herd.acme = {
    enable = mkEnableOption "acme module";
    domain = mkOption {
      default = config.networking.domain;
      type = lib.types.str;
    };
  };

  config = mkIf cfg.enable {
    age.secrets = {
      cf-email.file = self + "/secrets/cf-email.age";
      cf-dns-token.file = self + "/secrets/cf-dns-token.age";
    };

    security.acme = {
      acceptTerms = true;
      defaults = {
        email = "thenerdherd4043+acme@gmail.com";
        group = config.services.nginx.group;
        credentialFiles = {
          "CF_API_EMAIL_FILE" = config.age.secrets.cf-email.path;
          "CF_DNS_API_TOKEN_FILE" = config.age.secrets.cf-dns-token.path;
        };
      };

      certs = {
        "${cfg.domain}" = {
          dnsProvider = "cloudflare";
          extraDomainNames = [ "*.${cfg.domain}" ];
        };
      };
    };
  };
}
