{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.swaylock;
in
{
  options.modules.swaylock = {
    enable = mkEnableOption "Swaylock screen locker";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      swaylock-effects
      swaylock-fancy
    ];

    home-manager.users.monotoko = { pkgs, ... }: {
      programs.swaylock = {
        enable = true;
        package = pkgs.swaylock-effects;
        
        settings = {
          ignore-empty-password = true;
          disable-caps-lock-text = true;
          font = "Cantarell Regular";
          
          screenshots = true;
          effect-blur = "7x5";
          effect-vignette = "0.5:0.5";
          indicator = true;
          indicator-radius = 120;
          indicator-thickness = 20;
          clock = true;
          timestr = "%I:%M %p";
          datestr = "%A, %d %B";
          
          ring-color = "00aa84";
          key-hl-color = "82dccc";
          line-color = "007d6f";
          separator-color = "111826";
          inside-color = "111826";
          bs-hl-color = "01ccff";
          layout-bg-color = "111826";
          layout-border-color = "00aa84";
          layout-text-color = "ffffff";
          text-color = "ffffff";
        };
      };
    };
  };
}