{ nixpkgs-default , ... }:
{
  gtk = {
    enable = true;
    theme.name = "Dracula";
    theme.package = nixpkgs-default.dracula-theme;
    iconTheme.name = "Papirus-Dark";
    iconTheme.package = nixpkgs-default.papirus-icon-theme;
    gtk3.extraConfig = {
      "gtk-application-prefer-dark-theme" = "1";
    };
    gtk4.extraConfig = {
      "gtk-application-prefer-dark-theme" = "1";
    };
  };
  qt = {
    enable = true;
    style = {
      name = "kvantum";
    };
  };
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = "Dracula";
      color-scheme = "prefer-dark";
    };
  };

  home.packages = [
    nixpkgs-default.dracula-theme
    nixpkgs-default.kdePackages.qtstyleplugin-kvantum
    nixpkgs-default.kdePackages.qqc2-desktop-style  # Required for KDE Connect and QML apps
    nixpkgs-default.kdePackages.breeze  # Provides Breeze Dark color scheme
  ];
  
  xdg.configFile = {
    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=Dracula
    '';
    "Kvantum/Dracula".source = "${nixpkgs-default.dracula-theme}/share/Kvantum/Dracula";
  };
}
