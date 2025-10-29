{ lib, config, ... }:

let
  cfg = config.herd.wiki-js;
in {
  options.herd.wiki-js = {
    enable = lib.mkEnableOption "nerdherd wiki-js instance";
  };

  config = lib.mkIf cfg.enable {
     systemd.services.wiki-js = {
       requires = [ "postgresql.service" ];
       after    = [ "postgresql.service" ];
     };

     services.wiki-js = {
       enable = true;
       settings = {
         port = 3434;
         db = {
           db = "wiki-js";
           host = "/run/postgresql";
           type = "postgres";
           user = "wiki-js";
         };
       };
     };

     services.postgresql = {
       enable = true;
       ensureDatabases = [ "wiki-js" ];
       ensureUsers = [{
         name = "wiki-js";
         ensureDBOwnership = true;
       }];
     };
   };
}
