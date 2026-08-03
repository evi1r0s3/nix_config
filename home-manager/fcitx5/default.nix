{
  home.file.".local/share/fcitx5/themes/dracula" = {
    source = ./dracula;
    recursive = true;
  };
  home.file.".config/fcitx5/conf/classicui.conf".source = ./classicui.conf;
  gtk = {
    gtk2.extraConfig = "gtk-im-module=\"fcitx\"";
    gtk3.extraConfig = {
      gtk-im-module="fcitx";
    };
    gtk4.extraConfig = {
      gtk-im-module="fcitx";
    };
  };
}
