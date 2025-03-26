{ config, lib, ... }:

let
  cfg = config.herd.boot;
  inherit (lib)
    mkEnableOption
    mkIf
    mkDefault
    ;
in
{
  options.herd.boot = {
    enable = mkEnableOption "herd boot";
  };

  config = mkIf cfg.enable {
    boot = {
      tmp = {
        useTmpfs = mkDefault true;
        cleanOnBoot = true;
      };

      loader = {
        efi.canTouchEfiVariables = true;
        grub = {
          enable = true;
          efiSupport = true;
          device = "nodev";
          splashImage = null;
        };
      };
    };
  };
}
