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
    extraGroups = [ "networkmanager" "wheel" "video" "docker" ];
    shell = pkgs.zsh;
  };
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.rafael = {
      imports = [ ./home.nix ];
    };
  };

  # =========================
  # 📦 SYSTEM PKGS & FONTS
  # =========================
  environment.systemPackages = with pkgs; [
    git
    neovim
    wget
    fastfetch
    libnotify
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # =========================
  # 🐳 VIRTUALIZATION & LOGS
  # =========================
  virtualisation.docker = {
    enable = true;
    autoStart = false;
  };
  services.journald.extraConfig = "SystemMaxUse=50M";

  # =========================
  # 🎮 GAMING & HYPRLAND
  # =========================
  programs.steam.enable = true;
  programs.gamemode.enable = true;
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
  # 🔊 AUDIO + BLUETOOTH
  # =========================
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    bluetooth.enable = true;
  };
  hardware.bluetooth.enable = true;

  # =========================
  # 🌐 NETWORK & POWER
  # =========================
  networking.networkmanager.enable = true;

  # =========================
  # 🖥️ NVIDIA + INTEL 
  # =========================
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    powerManagement = {
      enable = true;
      finegrained = true; # Ótimo para economizar energia em notebooks
    };

    prime = {
      offload.enable = true;
      offload.enableOffloadCmd = true;
      
      # Valores baseados no seu CMD do Windows:
      nvidiaBusId = "PCI:1:0:0"; 
      intelBusId = "PCI:0:2:0"; 
    };
  };

  # =========================
  # 🧠 NIX SETTINGS
  # =========================
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  nix.optimise.automatic = true;

  # =========================
  # 🌍 LOCALE
  # =========================
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";
  system.stateVersion = "25.11";
}