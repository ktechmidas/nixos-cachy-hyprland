{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.wlogout;
in
{
  options.modules.wlogout = {
    enable = mkEnableOption "Wlogout logout menu";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      wlogout
    ];

    home-manager.users.monotoko = { pkgs, ... }: {
      programs.wlogout = {
        enable = true;
        
        layout = [
          {
            label = "lock";
            action = "swaylock";
            text = "Lock";
            keybind = "l";
          }
          {
            label = "hibernate";
            action = "systemctl hibernate";
            text = "Hibernate";
            keybind = "h";
          }
          {
            label = "logout";
            action = "hyprctl dispatch exit";
            text = "Logout";
            keybind = "e";
          }
          {
            label = "shutdown";
            action = "systemctl poweroff";
            text = "Shutdown";
            keybind = "s";
          }
          {
            label = "suspend";
            action = "systemctl suspend";
            text = "Suspend";
            keybind = "u";
          }
          {
            label = "reboot";
            action = "systemctl reboot";
            text = "Reboot";
            keybind = "r";
          }
        ];
        
        style = ''
          * {
              background-image: none;
              box-shadow: none;
          }

          window {
              background-color: rgba(17, 24, 38, 0.9);
          }

          button {
              border-radius: 0;
              border-color: #007d6f;
              text-decoration-color: #ffffff;
              color: #ffffff;
              background-color: #111826;
              border-style: solid;
              border-width: 1px;
              background-repeat: no-repeat;
              background-position: center;
              background-size: 25%;
          }

          button:focus, button:active, button:hover {
              background-color: #00aa84;
              outline-style: none;
          }

          #lock {
              background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/lock.png"));
          }

          #logout {
              background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/logout.png"));
          }

          #suspend {
              background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/suspend.png"));
          }

          #hibernate {
              background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/hibernate.png"));
          }

          #shutdown {
              background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png"));
          }

          #reboot {
              background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png"));
          }
        '';
      };
    };
  };
}