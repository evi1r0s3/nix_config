{ nixpkgs-unstable, lib, user-name, ... }:
{
  environment.systemPackages = with nixpkgs-unstable; [
    hyprpaper
    hyprcursor
    #xorg.xrdb
    xrdb
    xdg-desktop-portal-hyprland
    #hyprland-qtutils
    kdePackages.kwallet
    kdePackages.polkit-kde-agent-1
    rose-pine-hyprcursor
    wev
    wl-clipboard
    cliphist
    tofi
    grim
    swappy
    wf-recorder
    slurp
    networkmanagerapplet
    playerctl
    cmatrix
    # for nvidia
    egl-wayland
    mako
    libnotify
    easyeffects
    ashell
    #waybar
    # for eww
    #eww
    #pamixer
    brightnessctl
    bluetui
    lm_sensors
  ];
  # bar
  services.upower.enable = true;
  # hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true; # recommended for most users
    package = nixpkgs-unstable.hyprland;
  };
  # for x11 app supp
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };
  ##### hyprlock
  # Disable ALL display managers completely
  services.xserver.autorun = false;
  services.xserver.displayManager.lightdm.enable = false;
  services.displayManager.gdm.enable = false;
  services.displayManager.sddm.enable = false;
  services.xserver.displayManager.startx.enable = false;

  # 启动到多用户目标（文本模式）而不是图形模式
  systemd.defaultUnit = lib.mkForce "multi-user.target";

  # 屏蔽显示管理器服务以防止其启动
  systemd.services.display-manager.enable = false;
  # Autologin ONLY on TTY1
  # All other TTYs will require normal login
  services.getty.autologinUser = lib.mkDefault null;
    systemd.services."getty@tty1" = {
    overrideStrategy = "asDropin";
    serviceConfig = {
      ExecStart = lib.mkForce [
        ""
        "${nixpkgs-unstable.util-linux}/bin/agetty --autologin ${user-name} --noclear --keep-baud tty1 115200,38400,9600 $TERM"
      ];
    };
  };

  # 减少 TTY 数量（默认是 6，只需要 3 个）
  services.logind.settings.Login = {
    NAutoVTs = 3;
  };
    # Auto-start Hyprland on TTY1 only
  # This ensures Hyprlock is the first thing users see, and that it can't just be bypassed by flipping to a dif tty
  environment.loginShellInit = ''
    if [[ -z "$DISPLAY" ]] && [[ "$(tty)" == "/dev/tty1" ]]; then      
      # Start Hyprland which will immediately show Hyprlock
      exec start-hyprland
    fi
  '';
  programs.hyprlock.enable = true;
  #####
  

  # for keyring
  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${nixpkgs-unstable.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}
