{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.herd.minecraft-server;
  inherit (lib)
    mkEnableOption
    mkIf
    ;
in
{
  options.herd.minecraft-server = {
    enable = mkEnableOption "herd minecraft-server";
  };

  config = mkIf cfg.enable {
    users = {
      users.minecraft = {
        isSystemUser = true;
        group = "minecraft";
        shell = pkgs.bashInteractive;
        createHome = true;
        home = "/home/minecraft";
      };
      groups.minecraft = { };
    };

    networking.firewall = {
      allowedUDPPorts = [ 4043 ];
      allowedTCPPorts = [ 4043 ];
    };

    # TODO: Set up a not-jank service
    systemd.services = {
      minecraft =
        let
          # Server config
          server = pkgs.papermcServers.papermc-1_21_4;
          mem = "5G";
          dir = "/home/minecraft/1.21.4paper";

          screen = "${pkgs.screen}/bin/screen";
          cmd = cmd: "${screen} -S minecraft -X stuff \"${cmd}\"^M";
        in
        {
          description = "NerdHerdMC 1.21.4 Paper";
          after = [ "network.target" ];

          reload = ''
            ${cmd "say Server reloading"}
          '';

          script = ''
            ${screen} -DmS minecraft "${pkgs.writeShellScript "start-minecraft" ''
              ${server}/bin/minecraft-server \
              -Xms${mem} -Xmx${mem} -XX:+UseG1GC -XX:+ParallelRefProcEnabled \
              -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions \
              -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 \
              -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 \
              -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 \
              -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 \
              -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 \
              -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 \
              -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true
            ''}"
          '';

          preStop = ''
            ${cmd "say Server shutting down..."}
            ${cmd "save-all"}
            sleep 5
            ${cmd "say Server stopped."}
            ${cmd "stop"}
          '';

          serviceConfig = {
            User = "minecraft";
            Group = "minecraft";
            WorkingDirectory = dir;
            Restart = "on-failure";
          };
          wantedBy = [ "multi-user.target" ];
        };
    };
  };
}
