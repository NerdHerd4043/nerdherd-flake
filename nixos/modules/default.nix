{ config, lib, ... }:
let
  cfg = config.herd;
  mkTrue = (lib.mkOverride 1100 true);
  inherit (lib)
    mkIf
    mkEnableOption
    ;
in
{
  imports = [
    ./audio.nix
    ./networking.nix
  ];

  options.herd.defaults = mkEnableOption "herd defaults" // {
    default = true;
  };

  config.herd = mkIf cfg.defaults {
    audio.enable = mkTrue;
    networking.enable = mkTrue;
  };
}
