{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.mako;
in
{
  options.modules.mako = {
    enable = mkEnableOption "Mako notification daemon";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      mako
      libnotify  # For notify-send command
    ];

    home-manager.users.monotoko = { pkgs, ... }: {
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
}