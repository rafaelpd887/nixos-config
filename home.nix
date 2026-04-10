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

  # =========================
  # 📦 PACKAGES
  # =========================
  home.packages = with pkgs; [

    # UI
    waybar
    rofi
    thunar
    swaynotificationcenter

    # utils
    pavucontrol
    playerctl
    btop
    fzf
    direnv
    brightnessctl

    # apps
    firefox
    obsidian
    kitty

    # media
    ffmpeg
    mpv

    # wayland
    wl-clipboard
    grim
    slurp
    hyprpaper

    # wallpaper script
    wallpaperScript

    # fonts + icons
    nerd-fonts.jetbrains-mono
    papirus-icon-theme
    catppuccin-gtk
    catppuccin-cursors.mochaDark
  ];

  # =========================
  # 🪟 HYPRLAND
  # =========================
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {

      "$mod" = "SUPER";

      bind = [

        "$mod, RETURN, exec, kitty"
        "$mod, Q, killactive"
        "$mod, D, exec, rofi -show drun"
        "$mod, TAB, exec, rofi -show window"
        "$mod, E, exec, thunar"

        # 🖼️ wallpaper
        "$mod, W, exec, wallpicker"

        # ALT TAB
        "ALT, TAB, cyclenext"
        "ALT SHIFT, TAB, cyclerprev"

        # workspaces
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"

        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"

        # screenshots
        ", Print, exec, grim -g \"$(slurp)\" ~/Pictures/screenshot.png"
        "$mod, Print, exec, grim -g \"$(slurp)\" - | wl-copy"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      general = {
        gaps_in = 6;
        gaps_out = 12;
        border_size = 2;
        layout = "dwindle";
      };

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
      ];
    };
  };

  # =========================
  # 📊 WAYBAR (Catppuccin Mocha)
  # =========================
  programs.waybar = {
    enable = true;

    style = ''
      * {
        font-family: JetBrainsMono Nerd Font;
        font-size: 13px;
      }

      window#waybar {
        background: #1e1e2e;
        color: #cdd6f4;
      }

      #workspaces button {
        padding: 0 6px;
        color: #6c7086;
      }

      #workspaces button.active {
        color: #cba6f7;
      }

      #clock { color: #89b4fa; }
      #cpu { color: #f38ba8; }
      #memory { color: #a6e3a1; }
      #network { color: #89dceb; }
      #pulseaudio { color: #f9e2af; }
      #battery { color: #fab387; }
    '';
  };

  # =========================
  # 🎨 GTK (CATPPUCCIN)
  # =========================
  gtk = {
    enable = true;

    theme = {
      name = "Catppuccin-Mocha-Standard-Blue-dark";
      package = pkgs.catppuccin-gtk;
    };

    cursorTheme = {
      name = "Catppuccin-Mocha-Dark-Cursors";
      package = pkgs.catppuccin-cursors.mochaDark;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  # =========================
  # 🧠 ROFI THEME (leve + clean)
  # =========================
  programs.rofi = {
    enable = true;

    theme = ''  
      * {
        background: #1e1e2e;
        foreground: #cdd6f4;
        selected: #89b4fa;
      }

      window {
        background-color: @background;
      }

      element selected {
        background-color: @selected;
        text-color: #1e1e2e;
      }
    '';
  };

  # =========================
  # ⚡ ZSH
  # =========================
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
  };

  programs.home-manager.enable = true;
}