inputs:
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.services.uknown;
in
{
  options.services.uknown = {
    enable = lib.mkEnableOption "Uknown Pokemon Quiz";
    package = lib.mkOption {
      type = lib.types.package;
      default = inputs.self.packages.${pkgs.system}.default;
    };
    user = lib.mkOption {
      type = lib.types.str;
      default = "uknown";
    };
    group = lib.mkOption {
      type = lib.types.str;
      default = "uknown";
    };
    db.path = lib.mkOption {
      type = lib.types.path;
    };
    super-secret-key = lib.mkOption {
      type = lib.types.str;
    };
    host = lib.mkOption {
      type = lib.types.str;
      default = config.networking.hostName;
    };
    port = lib.mkOption {
      type = lib.types.port;
      default = 8000;
      description = "Port the application runs on.";
    };
  };
  config = mkIf cfg.enable {
    systemd.services.uknown = {
      description = "Uknown Pokequiz";
      wantedBy = [ "multi-user.target" ];
      environment = {
        PHX_HOST = cfg.host;
        PHX_SERVER = "true";
        SECRET_KEY_BASE = cfg.super-secret-key;
        DATABASE_PATH = cfg.db.path;
      };
      serviceConfig = {
        User = cfg.user;
        ExecStart = "${cfg.package}/bin/server start";
        Restart = "on-failure";
        RestartSec = "5s";
      };

    };

    users.users.uknown = lib.mkIf (cfg.user == "uknown") {
      isSystemUser = true;
      group = cfg.group;
    };
    users.groups.uknown = lib.mkIf (cfg.group == "uknown") { };
  };
}
