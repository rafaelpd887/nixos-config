{ config, pkgs, ... }:

{
  home.username = "rafael";
  home.homeDirectory = "/home/rafael";

  home.stateVersion = "25.11";

  # =========================
  # 📦 USER PACKAGES
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

    # apps
    firefox
    obsidian
    kitty

    # media
    ffmpeg
    mpv

    # Python (CORRETO)
    (python3.withPackages (ps: with ps; [
      pandas
      seaborn
      matplotlib
      scikit-learn
      xgboost
      lightgbm
    ]))

    # R
    rWrapper
    rstudio

    # fonte
    nerd-fonts.jetbrains-mono
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
        "$mod, E, exec, thunar"
      ];
    };
  };

  # =========================
  # 📊 WAYBAR
  # =========================
  programs.waybar = {
    enable = true;

    settings = [{
      mainBar = {
        layer = "top";
        position = "top";

        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [ "cpu" "memory" "network" "pulseaudio" "battery" ];

        clock.format = "{:%H:%M}";
        cpu.format = " {usage}%";
        memory.format = " {used:0.1f}G";
        network.format-wifi = "";
        network.format-disconnected = "";
        pulseaudio.format = " {volume}%";
        battery.format = " {capacity}%";
      };
    }];

    style = ''
      * {
        font-family: JetBrainsMono Nerd Font;
        font-size: 13px;
      }

      window#waybar {
        background: #11111b;
        color: #cdd6f4;
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
  # 🔔 NOTIFICAÇÕES
  # =========================
  services.swaync.enable = true;

  # =========================
  # 🎨 GTK
  # =========================
  gtk = {
    enable = true;

    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
  };

  # =========================
  # ⚡ ZSH
  # =========================
  programs.zsh = {
    enable = true;

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
      gs = "git status";
    };

    initContent = ''
      PROMPT='%F{blue}%~ %f$(git_prompt_info) %# '
    '';
  };

  programs.home-manager.enable = true;
}