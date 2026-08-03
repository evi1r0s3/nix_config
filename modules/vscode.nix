{ nixpkgs-default, ... }:
let
  vscode-hidpi = nixpkgs-default.symlinkJoin {
    name = "vscode";
    paths = [
      nixpkgs-default.vscode
    ];
    buildInputs = [ nixpkgs-default.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/code \
        --add-flags "--force-device-scale-factor=1.75"
      sed -i "s|Exec=.*|Exec=$out/bin/code|" $out/share/applications/code.desktop
    '';
  };
in
{
  environment.systemPackages = with nixpkgs-default; [
    vscode-hidpi
  ];
}
