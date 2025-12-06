{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.herd.site-preview;
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.herd.site-preview = {
    enable = mkEnableOption "herd site-preview";
    path = mkOption {
      default = "/srv/http/preview.nerdherd4043.org";
      type = types.path;
      description = ''
        Path to the website files
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ rsync ];

    users = {
      users.nginx.extraGroups = [ "site-preview" ];
      groups.site-preview = { };
      extraUsers.site-preview = {
        group = "site-preview";
        home = cfg.path;
        homeMode = "770";
        createHome = true;
        isSystemUser = true;
        useDefaultShell = true;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJyWkP+3lq7TZlmX4Qo8OOk/Pqt5Kp8x2you4EfbCe8J"
        ];
      };
    };

    services.nginx = {
      enable = true;
      virtualHosts."preview.nerdherd4043.org" = {
        forceSSL = true;
        useACMEHost = "nerdherd4043.org";
        root = cfg.path;
      };
    };
  };
}
