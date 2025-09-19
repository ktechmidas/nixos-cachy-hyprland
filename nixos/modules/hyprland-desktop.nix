{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.hyprland-desktop;
in
{
  imports = [
    ./hyprland.nix
    ./waybar.nix
    ./wofi.nix
    ./wlogout.nix
    ./swaylock.nix
    ./mako.nix
    ./hyprpaper.nix
  ];

  options.modules.hyprland-desktop = {
    enable = mkEnableOption "Complete Hyprland desktop environment";

    user = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "User account that should receive the Hyprland desktop Home Manager configuration.";
    };

    terminal = mkOption {
      type = types.str;
      default = "alacritty";
      description = "Default terminal emulator";
    };
    
    fileManager = mkOption {
      type = types.str;
      default = "nautilus";
      description = "Default file manager";
    };
    
    wallpaper = mkOption {
      type = types.str;
      default = "/usr/share/wallpapers/cachyos-wallpapers/skyscraper.png";
      description = "Path to wallpaper image";
    };
    
    cursorSize = mkOption {
      type = types.int;
      default = 24;
      description = "Cursor size";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.user != null;
        message = "modules.hyprland-desktop.enable requires modules.hyprland-desktop.user to be set.";
      }
    ];

    # Enable all Hyprland desktop components
    modules.hyprland = {
      enable = true;
      terminal = cfg.terminal;
      fileManager = cfg.fileManager;
      appLauncher = "wofi";
      wallpaper = cfg.wallpaper;
      cursorSize = cfg.cursorSize;
      user = cfg.user;
    };
    
    modules.waybar = {
      enable = true;
      user = cfg.user;
    };

    modules.wofi = {
      enable = true;
      user = cfg.user;
    };

    modules.wlogout = {
      enable = true;
      user = cfg.user;
    };

    modules.swaylock = {
      enable = true;
      user = cfg.user;
    };

    modules.mako = {
      enable = true;
      user = cfg.user;
    };

    modules.hyprpaper = {
      enable = true;
      wallpaper = cfg.wallpaper;
      user = cfg.user;
    };
    
    # Enable GTK theming with Nordic/CachyOS-Nord
    #modules.gtk-theme.enable = true;
    
    # Enable enhanced terminal with zsh and starship
    #modules.terminal.enable = true;
    
    # Additional system packages that might be useful
    environment.systemPackages = with pkgs; [
      firefox # Web browser (for swallow_regex)
      xdg-utils
      grim    # For screenshots
      slurp   # For area selection
    ];
  };
}
