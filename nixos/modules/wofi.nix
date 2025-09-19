{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.wofi;
in
{
  options.modules.wofi = {
    enable = mkEnableOption "Wofi application launcher";

    user = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "User account that should receive the Wofi Home Manager configuration.";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.user != null;
        message = "modules.wofi.enable requires modules.wofi.user to be set.";
      }
    ];

    environment.systemPackages = with pkgs; [
      wofi
    ];

    home-manager.users = mkIf (cfg.user != null) {
      "${cfg.user}" = { pkgs, ... }: {
        programs.wofi = {
          enable = true;

          settings = {
          allow_images = true;
          hide_scroll = true;
          no_actions = false;
          term = "alacritty";
          mode = "drun";
          show = true;
        };
        
          style = ''
          * {
              font-family: "Hack", monospace;
          }

          window {
              background-color: #007d6f;
          }

          #input {
              margin: 5px;
              border-radius: 0px;
              border: none;
              background-color: #111826;
              color: #ffffff;
          }

          #inner-box {
              background-color: #111826;
          }

          #outer-box {
              margin: 2px;
              padding: 10px;
              background-color: #111826;
          }

          #scroll {
              margin: 5px;
          }

          #text {
              padding: 4px;
              color: #ffffff;
          }

          #entry:nth-child(even){
              background-color: #182545;
          }

          #entry:selected {
              background-color: #00aa84;
          }

          #text:selected {
              background: transparent;
          }
        '';
        };
      };
    };
  };
}
