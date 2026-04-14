{ config, pkgs, ... }:
let
  wallpaperScript = pkgs.writeShellScriptBin "wallpicker" ''
    WALLDIR="$HOME/Pictures/wallpapers"
    SELECTED=$(ls "$WALLDIR" | ${pkgs.rofi}/bin/rofi -dmenu -p "Wallpaper")
    [ -z "$SELECTED" ] && exit 0
    FULL="$WALLDIR/$SELECTED"
    ${pkgs.hyprpaper}/bin/hyprctl hyprpaper unload all
    ${pkgs.hyprpaper}/bin/hyprctl hyprpaper preload "$FULL"
    ${pkgs.hyprpaper}/bin/hyprctl hyprpaper wallpaper ",$FULL"
  '';
in
{
  home.username = "rafael";
  home.homeDirectory = "/home/rafael";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    # UI & Utils
    thunar
    swaynotificationcenter
    pavucontrol
    playerctl
    btop
    fzf
    direnv
    brightnessctl
    wl-clipboard
    grim
    slurp
    hyprpaper

    # Apps
    firefox
    obsidian

    # Media
    ffmpeg
    mpv

    # Scripts
    wallpaperScript

    # Themes
    papirus-icon-theme
    catppuccin-gtk
    catppuccin-cursors.mochaDark

    # Necessário para o Power Menu
    rofi-power-menu
  ];

  # ====================== HYPRLAND ======================
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";

      env = [
        "LIBVA_DRIVER_NAME,nvidia"
        "XDG_SESSION_TYPE,wayland"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "NIXOS_OZONE_WL,1"
        "WLR_NO_HARDWARE_CURSORS,1"
        "XCURSOR_SIZE,24"
      ];

      bind = [
        "$mod, RETURN, exec, kitty"
        "$mod, D, exec, rofi -show drun"
        "$mod, TAB, exec, rofi -show window"
        "$mod, E, exec, thunar"
        "$mod, F, exec, firefox"
        "$mod, S, exec, steam"
        "$mod, Q, killactive"
        "$mod, W, exec, wallpicker"
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "ALT, TAB, cyclenext"
        "ALT SHIFT, TAB, cyclerprev"
        ", Print, exec, sh -c 'AREA=$(slurp) && [ -n \"$AREA\" ] && grim -g \"$AREA\" ~/Pictures/screenshot.png && wl-copy < ~/Pictures/screenshot.png'"
		
		# Brilho da tela (Teclas F2 e F3 - ajuste conforme seu teclado)
        ", F2, exec, brightnessctl set 5%- && notify-send 'Brilho' \"$(brightnessctl get)%\""
        ", F3, exec, brightnessctl set +5% && notify-send 'Brilho' \"$(brightnessctl get)%\""

        # Volume com wpctl
        ", F6, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && notify-send 'Audio' 'Mute toggled'"
        ", F7, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && notify-send 'Volume' \"$(wpctl get-volume @DEFAULT_AUDIO_SINK@)\""
        ", F8, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ && notify-send 'Volume' \"$(wpctl get-volume @DEFAULT_AUDIO_SINK@)\""

        # ==================== NOVOS ATALHOS ====================
        "$mod, Space, togglefloating"                                      # SUPER + Space = Toggle Floating
        "$mod SHIFT, E, exec, rofi -show power-menu -modi power-menu:rofi-power-menu"  # SUPER + Shift + E = Power Menu
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      general = {
        gaps_in = 6;
        gaps_out = 12;
        border_size = 2;
        "col.active_border" = "rgba(cba6f7ee) rgba(89b4faee) 45deg";
        "col.inactive_border" = "rgba(313244aa)";
        layout = "dwindle";
        resize_on_border = true;
      };

      input.follow_mouse = 1;

      animations = {
        enabled = true;
        bezier = "smooth, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 6, smooth"
          "fade, 1, 5, default"
          "workspaces, 1, 5, default"
        ];
      };

      exec-once = [
        "hyprpaper"
        "waybar"
        "swaync"
        "hyprctl setcursor Catppuccin-Mocha-Dark-Cursors 24"
      ];
    };
  };

  # ====================== TEMA GTK ======================
  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Standard-Blue-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "blue" ];
        size = "standard";
        variant = "mocha";
      };
    };
    cursorTheme = {
      name = "Catppuccin-Mocha-Dark-Cursors";
      package = pkgs.catppuccin-cursors.mochaDark;
      size = 24;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  # Suporte extra para GTK4
  xdg.configFile."gtk-4.0/gtk.css".source =
    "${pkgs.catppuccin-gtk}/share/themes/Catppuccin-Mocha-Standard-Blue-Dark/gtk-4.0/gtk.css";

  # ====================== PROGRAMAS ======================
  programs.kitty.enable = true;

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 34;
        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "network" "cpu" "memory" "pulseaudio" "battery" "tray" ];

        "hyprland/workspaces" = {
          format = "{name}";
          on-click = "activate";
        };
        "clock" = {
          format = "󱑂 {:%H:%M - %d/%m}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };
        "cpu" = { 
          interval = 10;
          format = " {usage}%"; 
        };
        "memory" = { 
          interval = 30;
          format = " {}%"; 
        };
        "network" = {
          format-wifi = " {essid}";
          format-ethernet = "󰈀";
          format-disconnected = "󰖪";
          tooltip-format = "{ifname} via {gwaddr}";
        };
        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-icons = { default = [ "" "" "" ]; };
          on-click = "pavucontrol";
        };
        "battery" = {
          format = "{icon} {capacity}%";
          format-icons = [ "" "" "" "" "" ];
        };
      };
    };
    style = ''
      * {
        font-family: JetBrainsMono Nerd Font;
        font-size: 13px;
      }
      window#waybar {
        background: #1e1e2e;
        color: #cdd6f4;
        border-bottom: 2px solid #cba6f7;
      }
      #workspaces button {
        padding: 0 8px;
        color: #6c7086;
      }
      #workspaces button.active {
        color: #cba6f7;
        background: #313244;
      }
      #clock { color: #89b4fa; margin-right: 10px; }
      #cpu { color: #f38ba8; margin-right: 10px; }
      #memory { color: #a6e3a1; margin-right: 10px; }
      #network { color: #89dceb; margin-right: 10px; }
      #pulseaudio { color: #f9e2af; margin-right: 10px; }
      #battery { color: #fab387; margin-right: 10px; }
      #tray { margin-right: 10px; }
    '';
  };

  programs.rofi = {
    enable = true;
    theme = "catppuccin-mocha";
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
  };

  programs.home-manager.enable = true;
}