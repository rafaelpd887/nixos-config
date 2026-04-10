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

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.rafael = {
    imports = [ ./home.nix ];
  };

  # =========================
  # 📦 SYSTEM 
  # =========================
  environment.systemPackages = with pkgs; [
    git
    neovim
    wget
    fastfetch
  ];

  # =========================
  # 🐳 DOCKER 
  # =========================
  virtualisation.docker = {
    enable = true;
    autoStart = false; # não inicia no boot (zero consumo idle)
  };

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
  services.blueman.enable = true;

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