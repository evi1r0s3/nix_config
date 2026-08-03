{ version, user-name, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./power-control.nix
      ./nvidia.nix
      ./custom-software.nix
      ./bluetooth.nix
      ./time.nix
    ];
  # python Doc build issue bug
  documentation.doc.enable = false;

  boot.loader.systemd-boot = {
    enable = true;
    # 已经在gc中设置
    #configurationLimit = 10;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  
  #boot.loader = {
  #  efi.canTouchEfiVariables = false;
  #  grub = {
  #    enable = true;
  #    device = "nodev";
  #    useOSProber = false;
  #    efiSupport = true;
  #    font = "${nixpkgs-default.nerd-fonts.intone-mono}/share/fonts/truetype/NerdFonts/IntoneMono/IntoneMonoNerdFont-Medium.ttf";
  #    fontSize = 24;
  #    gfxmodeEfi = "2880x1800";
  #  };
  #};

  networking.hostName = "ZenNixOS";
  networking.networkmanager.enable = true;

  users.users.${user-name} = {
        isNormalUser = true;
        description = "${user-name}";
        extraGroups = [ "networkmanager" "wheel" ];
    };

  i18n.defaultLocale = "zh_CN.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
  };

  services.printing.enable = true;

  services.pulseaudio.enable = false;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "${version}";
}
