{ nixpkgs-default, ... }:
  let
    wpsoffice-cn-hidpi = nixpkgs-default.symlinkJoin {
      name = "wps-office-cn";
      paths = [ nixpkgs-default.wpsoffice-cn ];
      buildInputs = [ nixpkgs-default.makeWrapper ];
      postBuild = ''
        for bin in $(ls $out/bin); do
          wrapProgram $out/bin/$bin \
            --set QT_FONT_DPI 144 \
            --set XCURSOR_SIZE 48 \
            --set QT_SCREEN_SCALE_FACTORS 1.5 \
            --set QT_AUTO_SCREEN_SCALE_FACTOR 0 \
            --set QT_IM_MODULE fcitx5
        done
        for desktop in $(ls $out/share/applications); do
          sed -i "s|Exec=.*/bin/\(.*\)|Exec=$out/bin/\1|" $out/share/applications/$desktop
        done
      '';
    };
  in
{
  environment.systemPackages = [
    wpsoffice-cn-hidpi
  ];
}
