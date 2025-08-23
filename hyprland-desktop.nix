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
    ./gtk-theme.nix
    ./terminal.nix
  ];

  options.modules.hyprland-desktop = {
    enable = mkEnableOption "Complete Hyprland desktop environment";
    
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
      default = "/usr/share/wallpapers/cachyos-wallpapers/Skyscraper.png";
      description = "Path to wallpaper image";
    };
    
    cursorSize = mkOption {
      type = types.int;
      default = 24;
      description = "Cursor size";
    };
  };

  config = mkIf cfg.enable {
    # Enable all Hyprland desktop components
    modules.hyprland = {
      enable = true;
      terminal = cfg.terminal;
      fileManager = cfg.fileManager;
      appLauncher = "wofi";
      wallpaper = cfg.wallpaper;
      cursorSize = cfg.cursorSize;
    };
    
    modules.waybar.enable = true;
    modules.wofi.enable = true;
    modules.wlogout.enable = true;
    modules.swaylock.enable = true;
    modules.mako.enable = true;
    modules.hyprpaper = {
      enable = true;
      wallpaper = "/home/monotoko/Pictures/Media/wallpaper.jpg";
    };
    
    # Enable GTK theming with Nordic/CachyOS-Nord
    modules.gtk-theme.enable = true;
    
    # Enable enhanced terminal with zsh and starship
    modules.terminal.enable = true;
    
    # Additional system packages that might be useful
    environment.systemPackages = with pkgs; [
      firefox # Web browser (for swallow_regex)
      xdg-utils
      grim    # For screenshots
      slurp   # For area selection
    ];
  };
}
