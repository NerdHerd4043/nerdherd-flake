{ config, lib, ... }:

let
  cfg = config.herd.module;
  inherit (lib)
    mkEnableOption
    mkIf
    ;
in
{
  options.herd.module = {
    enable = mkEnableOption "herd module";
  };

  config = mkIf cfg.enable {

  };
}
