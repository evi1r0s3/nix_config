{ nixpkgs-default, ... }:
let
  wechat-hidpi = nixpkgs-default.symlinkJoin {
    name = "wechat";
    paths = [
      nixpkgs-default.wechat # need to build glibc
    ];
    buildInputs = [ nixpkgs-default.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/wechat \
        --set QT_FONT_DPI 144 \
        --set XCURSOR_SIZE 48 \
        --set QT_SCREEN_SCALE_FACTORS 1.5 \
        --set QT_IM_MODULE fcitx \
        --set QT_AUTO_SCREEN_SCALE_FACTOR 0
      sed -i "s|Exec=.*|Exec=$out/bin/wechat|" $out/share/applications/wechat.desktop
    '';
  };
in
{
  environment.systemPackages = [
    wechat-hidpi
  ];
}
