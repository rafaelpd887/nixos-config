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
    autoStart = false;
  };

  # =========================
  # 🎮 GAMING
  # =========================
  programs.steam.enable = true;
  programs.gamemode.enable = true;

  # =========================
  # 🪟 HYPRLAND + AUTOLOGIN DIRETO (sem greetd)
  # =========================
  programs.hyprland.enable = true;

  # Autologin direto no TTY1
  services.getty.autologinUser = "rafael";

  # Inicia Hyprland automaticamente com configurações recomendadas para NVIDIA
  environment.loginShellInit = ''
    if [[ "$(tty)" == "/dev/tty1" ]]; then
      exec env \
        WLR_NO_HARDWARE_CURSORS=1 \
        GBM_BACKEND=nvidia-drm \
        __GLX_VENDOR_LIBRARY_NAME=nvidia \
        LIBVA_DRIVER_NAME=nvidia \
        start-hyprland
    fi
  '';

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
  # ⌨️ TECLADO ABNT2
  # =========================
  services.xserver = {
    layout = "br";
    xkbVariant = "abnt2";
  };

  # Também aplica no console (TTY)
  console.useXkbConfig = true;

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

  # Opcional: algumas coisas em português
  i18n.extraLocaleSettings = {
    LC_TIME = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
  };

  system.stateVersion = "25.11";
}