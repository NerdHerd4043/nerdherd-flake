{ config, lib, ... }:

let
  cfg = config.herd.audio;
  inherit (lib)
    mkEnableOption
    mkIf
    ;
in
{
  options.herd.audio = {
    enable = mkEnableOption "herd audio module";
  };

  config = mkIf cfg.enable {

    # For pipewire, it's not a rootkit I swear
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
