{
  config,
  lib,
  ...
}:
let
  cfg = config.herd.tailscale;
  inherit (lib)
    mkEnableOption
    mkIf
    optionals
    ;
in
{
  options.herd.tailscale = {
    enable = mkEnableOption "tailscale module";
    exitNode = mkEnableOption "exit node";
  };

  config = mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      useRoutingFeatures = "both";
      openFirewall = true;
      extraUpFlags = optionals cfg.exitNode [ "--advertise-exit-node" ];
      extraSetFlags = optionals cfg.exitNode [ "--advertise-exit-node" ];
      authKeyFile = config.age.secrets.tailscale-auth-key.path;
    };

    networking.firewall.trustedInterfaces = [ "tailscale0" ];
  };
}
