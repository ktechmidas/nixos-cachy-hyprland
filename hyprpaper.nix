{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.hyprpaper;
in
{
  options.modules.hyprpaper = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable hyprpaper wallpaper manager";
    };
    
    wallpaper = mkOption {
      type = types.str;
      default = "/home/monotoko/Pictures/Media/wallpaper.jpg";
      description = "Path to wallpaper image";
    };
  };
  
  config = mkIf cfg.enable {
    # Add hyprpaper to system packages
    environment.systemPackages = with pkgs; [
      hyprpaper
    ];
    
    # Configure home-manager for the user
    home-manager.users.monotoko = { pkgs, ... }: {
      # Hyprpaper configuration
      xdg.configFile."hypr/hyprpaper.conf".text = ''
        preload = ${cfg.wallpaper}
        wallpaper = ,${cfg.wallpaper}
        splash = false
        ipc = on
      '';
    };
  };
}