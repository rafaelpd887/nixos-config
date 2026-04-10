{ config, pkgs, ... }:

{
  home.username = "rafael";
  home.homeDirectory = "/home/rafael";

  home.stateVersion = "25.11";

  # =========================
  # 📦 PACKAGES (LEVE)
  # =========================
  home.packages = with pkgs; [

    # UI core
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

    # wayland essentials
    wl-clipboard
    grim
    slurp
    hyprpaper

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

      # =========================
      # ⌨️ KEYBINDS
      # =========================
      bind = [

        # apps
        "$mod, RETURN, exec, kitty"
        "$mod, Q, killactive"
        "$mod, D, exec, rofi -show drun"
        "$mod, TAB, exec, rofi -show window"   # 🔥 ALT+TAB LEVE VISUAL
        "$mod, E, exec, thunar"

        # ALT + TAB nativo
        "ALT, TAB, cyclenext"
        "ALT SHIFT, TAB, cyclerprev"
        "ALT, TAB, bringactivetotop"

        # workspaces
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"

        # mover janela
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"

        # screenshot file
        ", Print, exec, grim -g \"$(slurp)\" ~/Pictures/screenshot.png"

        # screenshot clipboard
        "$mod, Print, exec, grim -g \"$(slurp)\" - | wl-copy"

        # volume
        ", XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%"
        ", XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%"
        ", XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"

        # brilho
        ", XF86MonBrightnessUp, exec, brightnessctl set +10%"
        ", XF86MonBrightnessDown, exec, brightnessctl set 10%-"
      ];

      # =========================
      # 🖱️ MOUSE
      # =========================
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      # =========================
      # 🎞️ ANIMAÇÕES LEVES
      # =========================
      animations = {
        enabled = true;

        bezier = "smooth, 0.05, 0.9, 0.1, 1.05";

        animation = [
          "windows, 1, 6, smooth"
          "windowsOut, 1, 6, default, popin 80%"
          "fade, 1, 5, default"
          "workspaces, 1, 5, default"
        ];
      };

      # =========================
      # 🧱 LAYOUT
      # =========================
      general = {
        gaps_in = 6;
        gaps_out = 12;
        border_size = 2;
        layout = "dwindle";
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      # =========================
      # 🖼️ STARTUP
      # =========================
      exec-once = [
        "hyprpaper"
        "waybar"
        "swaync"
      ];
    };
  };

  # =========================
  # 📊 WAYBAR
  # =========================
  programs.waybar.enable = true;

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