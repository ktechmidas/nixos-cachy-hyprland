{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.hyprland;
in
{
  options.modules.hyprland = {
    enable = mkEnableOption "Hyprland window manager configuration";
    
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
    
    appLauncher = mkOption {
      type = types.str;
      default = "wofi";
      description = "Default application launcher";
    };
    
    wallpaper = mkOption {
      type = types.str;
      default = "";
      description = "Path to wallpaper image";
    };
    
    cursorSize = mkOption {
      type = types.int;
      default = 24;
      description = "Cursor size";
    };
    
    cursorTheme = mkOption {
      type = types.str;
      default = "Bibata-Modern-Classic";
      description = "Cursor theme name";
    };
  };

  config = mkIf cfg.enable {
    # Enable Hyprland at the system level
    programs.hyprland.enable = true;
    
    # XDG portal configuration for Wayland
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    };
    
    # Environment variables
    environment.sessionVariables = {
      HYPRCURSOR_SIZE = toString cfg.cursorSize;
      HYPRCURSOR_THEME = cfg.cursorTheme;
      XCURSOR_SIZE = toString cfg.cursorSize;
      XCURSOR_THEME = cfg.cursorTheme;
      QT_CURSOR_SIZE = toString cfg.cursorSize;
    };
    
    # System packages - only essentials for now
    environment.systemPackages = with pkgs; [
      bibata-cursors  # Cursor theme
      wofi  # for app launcher
      swaylock
      swaylock-fancy
      swayidle
      grimblast  # for screenshots
      brightnessctl
      playerctl
      pavucontrol
      alacritty
      waybar
      mako
      networkmanagerapplet
      wob
      kdePackages.polkit-kde-agent-1
      swaybg
      hyprpaper
    ];
    
    # Home-manager configuration for the user
    home-manager.users.monotoko = { pkgs, ... }: {
      # Set cursor theme environment variables for the user session
      home.sessionVariables = {
        HYPRCURSOR_SIZE = toString cfg.cursorSize;
        HYPRCURSOR_THEME = cfg.cursorTheme;
        XCURSOR_SIZE = toString cfg.cursorSize;
        XCURSOR_THEME = cfg.cursorTheme;
      };
      
      wayland.windowManager.hyprland = {
        enable = true;
        
        extraConfig = ''
          # Resize submap configuration
          submap = resize
          bind = , right, resizeactive, 15 0
          bind = , left, resizeactive, -15 0
          bind = , up, resizeactive, 0 -15
          bind = , down, resizeactive, 0 15
          bind = , l, resizeactive, 15 0
          bind = , h, resizeactive, -15 0
          bind = , k, resizeactive, 0 -15
          bind = , j, resizeactive, 0 15
          bind = , escape, submap, reset
          submap = reset

          windowrulev2 = float, title:^(.*Network Manager.*)$
        '';
        
        settings = {
          "$mainMod" = "SUPER";
          
          # Environment variables for cursor
          env = [
            "HYPRCURSOR_THEME,${cfg.cursorTheme}"
            "HYPRCURSOR_SIZE,${toString cfg.cursorSize}"
            "XCURSOR_THEME,${cfg.cursorTheme}"
            "XCURSOR_SIZE,${toString cfg.cursorSize}"
          ];
          
          # Monitor configuration
          monitor = [
            ", preferred, auto, 1"
          ];
          
          # Variables
          "$terminal" = cfg.terminal;
          "$filemanager" = cfg.fileManager;
          "$applauncher" = cfg.appLauncher;
          "$idlehandler" = "swayidle -w timeout 300 'swaylock -f -c 000000' before-sleep 'swaylock -f -c 000000'";
          
          # Screenshot commands
          "$shot-region" = "grimblast copy area";
          "$shot-window" = "grimblast copy active";
          "$shot-screen" = "grimblast copy output";
          
          # Animations
          animations = {
            enabled = true;
            bezier = "overshot, 0.13, 0.99, 0.29, 1.1";
            animation = [
              "windowsIn, 1, 4, overshot, slide"
              "windowsOut, 1, 5, default, popin 80%"
              "border, 1, 5, default"
              "workspacesIn, 1, 6, overshot, slide"
              "workspacesOut, 1, 6, overshot, slidefade 80%"
            ];
          };
          
          # Decorations
          decoration = {
            active_opacity = 1;
            rounding = 4;
            
            blur = {
              size = 15;
              passes = 2;
              xray = true;
            };
            
            shadow = {
              enabled = false;
            };
          };
          
          # General settings
          general = {
            gaps_in = 3;
            gaps_out = 5;
            border_size = 3;
            "col.active_border" = "rgb(41b883)";  # CachyOS green
            "col.inactive_border" = "rgb(0b1924)";  # CachyOS blue
            layout = "dwindle";
            
            snap = {
              enabled = true;
            };
          };
          
          # Input configuration
          input = {
            follow_mouse = 2;
            float_switch_override_focus = 2;
          };
          
          # Gestures
          gestures = {
            workspace_swipe = true;
            workspace_swipe_fingers = 4;
            workspace_swipe_distance = 250;
            workspace_swipe_min_speed_to_force = 15;
            workspace_swipe_create_new = false;
          };
          
          # Group settings
          group = {
            "col.border_active" = "rgb(1f854d)";
            "col.border_inactive" = "rgb(41b883)";
            "col.border_locked_active" = "rgb(279e60)";
            "col.border_locked_inactive" = "rgb(163249)";
            
            groupbar = {
              font_family = "Fira Sans";
              text_color = "rgb(163249)";
              "col.active" = "rgb(1f854d)";
              "col.inactive" = "rgb(41b883)";
              "col.locked_active" = "rgb(279e60)";
              "col.locked_inactive" = "rgb(163249)";
            };
          };
          
          # Misc settings
          misc = {
            font_family = "Fira Sans";
            splash_font_family = "Fira Sans";
            disable_hyprland_logo = true;
            "col.splash" = "rgb(41b883)";
            background_color = "rgb(163249)";
            enable_swallow = true;
            swallow_regex = "^(nautilus|nemo|thunar|btrfs-assistant.)$";
            focus_on_activate = true;
            vrr = 2;
          };
          
          # Render settings
          render = {
            direct_scanout = true;
          };
          
          # Dwindle layout
          dwindle = {
            special_scale_factor = 0.8;
            pseudotile = true;
            preserve_split = true;
          };
          
          # Master layout
          master = {
            new_status = "master";
            special_scale_factor = 0.8;
          };
          
          # Binds settings
          binds = {
            allow_workspace_cycles = true;
            workspace_back_and_forth = true;
            workspace_center_on = true;
            movefocus_cycles_fullscreen = true;
            window_direction_monitor_fallback = true;
          };
          
          # Autostart applications
          exec-once = [
            "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
            "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
            "hyprpaper &"
            "waybar &"
            "fcitx5 -d &"
            "mako &"
            "nm-applet --indicator &"
            "bash -c \"mkfifo /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob && tail -f /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob | wob & disown\" &"
"${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1 &"
            "$idlehandler"
          ] ++ (optional (cfg.wallpaper != "") "swaybg -o * -i ${cfg.wallpaper} -m fill");
          
          # Key bindings
          bind = [
            # Core functionality
            "$mainMod, RETURN, exec, $terminal"
            "$mainMod, E, exec, $filemanager"
            "$mainMod, B, exec, firefox"
            "$mainMod, Q, killactive,"
            "$mainMod SHIFT, M, exec, loginctl terminate-user \"\""
            "$mainMod, V, togglefloating,"
            "$mainMod, SPACE, exec, wofi --show drun"
            "$mainMod, F, fullscreen"
            "$mainMod, Y, pin"
            "$mainMod, J, togglesplit"
            
            # Screenshots
            ", Print, exec, $shot-region"
            "CTRL, Print, exec, $shot-window"
            "ALT, Print, exec, $shot-screen"
            
            # Grouping
            "$mainMod, K, togglegroup,"
            "$mainMod, Tab, changegroupactive, f"
            
            # Gaps
            "$mainMod SHIFT, G, exec, hyprctl --batch \"keyword general:gaps_out 5;keyword general:gaps_in 3\""
            "$mainMod, G, exec, hyprctl --batch \"keyword general:gaps_out 0;keyword general:gaps_in 0\""
            
            # Playback control
            ", XF86AudioPlay, exec, playerctl play-pause"
            ", XF86AudioNext, exec, playerctl next"
            ", XF86AudioPrev, exec, playerctl previous"
            
            # Screen lock and waybar reload
            "$mainMod, L, exec, swaylock-fancy -e -K -p 10 -f Hack-Regular"
            "$mainMod, O, exec, killall -SIGUSR2 waybar"
            
            # Window focus
            "$mainMod, left, movefocus, l"
            "$mainMod, right, movefocus, r"
            "$mainMod, up, movefocus, u"
            "$mainMod, down, movefocus, d"
            
            # Window movement
            "$mainMod SHIFT, left, movewindow, l"
            "$mainMod SHIFT, right, movewindow, r"
            "$mainMod SHIFT, up, movewindow, u"
            "$mainMod SHIFT, down, movewindow, d"
            
            # Window resize mode
            "$mainMod, R, submap, resize"
            
            # Quick resize without entering resize mode
            "$mainMod CTRL SHIFT, right, resizeactive, 15 0"
            "$mainMod CTRL SHIFT, left, resizeactive, -15 0"
            "$mainMod CTRL SHIFT, up, resizeactive, 0 -15"
            "$mainMod CTRL SHIFT, down, resizeactive, 0 15"
            "$mainMod CTRL SHIFT, l, resizeactive, 15 0"
            "$mainMod CTRL SHIFT, h, resizeactive, -15 0"
            "$mainMod CTRL SHIFT, k, resizeactive, 0 -15"
            "$mainMod CTRL SHIFT, j, resizeactive, 0 15"
            
            # Workspace switching (1-10)
            "$mainMod, 1, workspace, 1"
            "$mainMod, 2, workspace, 2"
            "$mainMod, 3, workspace, 3"
            "$mainMod, 4, workspace, 4"
            "$mainMod, 5, workspace, 5"
            "$mainMod, 6, workspace, 6"
            "$mainMod, 7, workspace, 7"
            "$mainMod, 8, workspace, 8"
            "$mainMod, 9, workspace, 9"
            "$mainMod, 0, workspace, 10"
            
            # Move to workspace and switch (CTRL)
            "$mainMod CTRL, 1, movetoworkspace, 1"
            "$mainMod CTRL, 2, movetoworkspace, 2"
            "$mainMod CTRL, 3, movetoworkspace, 3"
            "$mainMod CTRL, 4, movetoworkspace, 4"
            "$mainMod CTRL, 5, movetoworkspace, 5"
            "$mainMod CTRL, 6, movetoworkspace, 6"
            "$mainMod CTRL, 7, movetoworkspace, 7"
            "$mainMod CTRL, 8, movetoworkspace, 8"
            "$mainMod CTRL, 9, movetoworkspace, 9"
            "$mainMod CTRL, 0, movetoworkspace, 10"
            "$mainMod CTRL, left, movetoworkspace, -1"
            "$mainMod CTRL, right, movetoworkspace, +1"
            
            # Move to workspace silently (SHIFT)
            "$mainMod SHIFT, 1, movetoworkspacesilent, 1"
            "$mainMod SHIFT, 2, movetoworkspacesilent, 2"
            "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
            "$mainMod SHIFT, 4, movetoworkspacesilent, 4"
            "$mainMod SHIFT, 5, movetoworkspacesilent, 5"
            "$mainMod SHIFT, 6, movetoworkspacesilent, 6"
            "$mainMod SHIFT, 7, movetoworkspacesilent, 7"
            "$mainMod SHIFT, 8, movetoworkspacesilent, 8"
            "$mainMod SHIFT, 9, movetoworkspacesilent, 9"
            "$mainMod SHIFT, 0, movetoworkspacesilent, 10"
            
            # Workspace navigation
            "$mainMod, PERIOD, workspace, e+1"
            "$mainMod, COMMA, workspace, e-1"
            "$mainMod, slash, workspace, previous"
            "$mainMod, mouse_down, workspace, e+1"
            "$mainMod, mouse_up, workspace, e-1"
            
            # Special workspaces
            "$mainMod, minus, movetoworkspace, special"
            "$mainMod, equal, togglespecialworkspace, special"
            "$mainMod, F1, togglespecialworkspace, scratchpad"
            "$mainMod ALT SHIFT, F1, movetoworkspacesilent, special:scratchpad"

            # Custom
            "ALT_R, Control_R, exec, pkill -SIGUSR1 waybar" # Toggle Waybar visibility

          ];
          
          # Repeatable bindings
          bindel = [
            # Volume control
            ", XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +5% && pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\\d+(?=%)' | awk '{if($1>100) system(\"pactl set-sink-volume @DEFAULT_SINK@ 100%\")}' && pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\\d+(?=%)' | awk '{print $1}' | head -1 > /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob"
            ", XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -5% && pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\\d+(?=%)' | awk '{print $1}' | head -1 > /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob"
            ", XF86AudioMute, exec, amixer sset Master toggle | sed -En '/\\[on\\]/ s/.*\\[([0-9]+)%\\].*/\\1/ p; /\\[off\\]/ s/.*/0/p' | head -1 > /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob"
            
            # Brightness control
            ", XF86MonBrightnessUp, exec, brightnessctl s +5%"
            ", XF86MonBrightnessDown, exec, brightnessctl s 5%-"
          ];
          
          # Mouse bindings
          bindm = [
            "$mainMod, mouse:272, movewindow"
            "$mainMod, mouse:273, resizewindow"
          ];
        };
      };
    };
  };
}
