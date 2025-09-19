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

    user = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "User account that should receive the hyprpaper Home Manager configuration.";
    };

    wallpaper = mkOption {
      type = types.str;
      default = "";
      description = "Path to wallpaper image";
    };
  };
  
  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.user != null;
        message = "modules.hyprpaper.enable requires modules.hyprpaper.user to be set.";
      }
    ];

    # Add hyprpaper to system packages
    environment.systemPackages = with pkgs; [
      hyprpaper
    ];

    # Configure home-manager for the user
    home-manager.users = mkIf (cfg.user != null) {
      "${cfg.user}" = { pkgs, ... }: {
        # Hyprpaper configuration
        xdg.configFile."hypr/hyprpaper.conf".text = ''
          preload = ${cfg.wallpaper}
          wallpaper = ,${cfg.wallpaper}
          splash = false
          ipc = on
        '';
      };
    };
  };
}
