{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.mako;
in
{
  options.modules.mako = {
    enable = mkEnableOption "Mako notification daemon";

    user = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "User account that should receive the Mako Home Manager configuration.";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.user != null;
        message = "modules.mako.enable requires modules.mako.user to be set.";
      }
    ];

    environment.systemPackages = with pkgs; [
      mako
      libnotify  # For notify-send command
    ];

    home-manager.users = mkIf (cfg.user != null) {
      "${cfg.user}" = { pkgs, ... }: {
        services.mako = {
          enable = true;

          settings = {
          max-visible = 10;
          layer = "top";
          font = "Sarasa UI SC 10";
          background-color = "#4c566add";
          text-color = "#d8dee9";
          border-color = "#434c5e";
          border-radius = 7;
          max-icon-size = 48;
          default-timeout = 10000;
          anchor = "top-right";
          margin = "20";
          };
        };
      };
    };
  };
}
