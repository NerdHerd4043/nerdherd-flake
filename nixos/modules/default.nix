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
  ];

  options.herd.defaults = mkEnableOption "herd defaults" // {
    default = true;
  };

  config.herd = mkIf cfg.defaults {
  };
}
