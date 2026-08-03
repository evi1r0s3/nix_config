{ nixpkgs-unstable, ... }:
let
  obsidian-hidpi = nixpkgs-unstable.symlinkJoin {
    name = "obsidian";
    paths = [
      nixpkgs-unstable.obsidian # need to build glibc
    ];
    buildInputs = [ nixpkgs-unstable.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/obsidian \
        --add-flags "--force-device-scale-factor=1.75"
      sed -i "s|Exec=.*|Exec=$out/bin/obsidian|" $out/share/applications/obsidian.desktop
    '';
  };
in
{
  environment.systemPackages = with nixpkgs-unstable; [
    obsidian-hidpi
    # 用于导出类的插件
    pandoc
    # 用于github copliot接入插件
    nodejs
  ];
}
