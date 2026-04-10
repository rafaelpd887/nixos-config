{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    <home-manager/nixos>
  ];

  # =========================
  # 👤 USER
  # =========================
  users.users.rafael = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "video" ];
    shell = pkgs.zsh;
  };

  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.rafael = {
    imports = [ ./home.nix ];
  };

  # =========================
  # 📦 PACKAGES
  # =========================
  environment.systemPackages = with pkgs; [
    git neovim fzf direnv wget btop fastfetch

    # Python + DS
    python3Full
    python3Packages.pandas
    python3Packages.seaborn
    python3Packages.matplotlib
    python3Packages.scikit-learn
    python3Packages.xgboost
    python3Packages.lightgbm
    python3Packages.spyder

    # R
    rWrapper
    rstudio

    # Apps
    firefox obsidian

    # Terminal
    kitty

    # Media
    ffmpeg mpv

    # Gaming
    steam-run
  ];

  # =========================
  # 🎮 GAMING
  # =========================
  programs.steam.enable = true;
  programs.gamemode.enable = true;

  # =========================
  # 🪟 HYPRLAND + AUTOLOGIN
  # =========================
  programs.hyprland.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "Hyprland";
        user = "rafael";
      };
    };
  };

  # =========================
  # 🔊 AUDIO
  # =========================
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # =========================
  # 🌐 NETWORK
  # =========================
  networking.networkmanager.enable = true;

  # =========================
  # ⚡ POWER
  # =========================
  services.power-profiles-daemon.enable = true;

  # =========================
  # 🖥️ NVIDIA
  # =========================
  hardware.graphics.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      offload.enable = true;
      offload.enableOffloadCmd = true;
      nvidiaBusId = "PCI:1:0:0";
      amdgpuBusId = "PCI:4:0:0";
    };
  };

  # =========================
  # 🧠 NIX
  # =========================
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # =========================
  # 🌍 LOCALE
  # =========================
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "25.11";
}