{ nixpkgs-default, ... }:
{
  services.flatpak.enable = true;
  xdg.portal.extraPortals = [ nixpkgs-default.xdg-desktop-portal-gtk ];
  
  xdg.portal.config.common.default = "gtk";
  #systemd.services.flatpak-hidpi = {
  #  wantedBy = [ "multi-user.target" ];
  #  after = ["network.target"];
  #  path = [ nixpkgs-default.flatpak ];
  #  script = ''
  #    flatpak override --user --env=QT_SCREEN_SCALE_FACTORS=1.5 --env=XCURSOR_SIZE=24 --filesystem=xdg-download:rw com.tencent.wemeet
  #    flatpak override --user --env=QT_SCREEN_SCALE_FACTORS=2 --env=XCURSOR_SIZE=24 --filesystem=xdg-download:rw com.tencent.WeChat
  #    flatpak override --user --env=QT_SCREEN_SCALE_FACTORS=1.5 --env=XCURSOR_SIZE=24 --filesystem=xdg-download:rw com.dingtalk.DingTalk
  #    flatpak override --user --env=QT_SCREEN_SCALE_FACTORS=2 --env=XCURSOR_SIZE=24 --filesystem=xdg-download:rw --filesystem=home:rw cn.wps.wps_365
  #  '';
  #};
  
  #flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo &
  #flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo &
  #flatpak --user remote-modify flathub --url=https://mirrors.ustc.edu.cn/flathub &
  #flatpak install -y com.tencent.wemeet
  #flatpak install -y cn.wps.wps_365
  #flatpak install -y com.dingtalk.DingTalk
  #flatpak install -y com.tencent.WeChat
}
