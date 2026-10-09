{ nixpkgs-unstable, ... }:
let
  remnote-hidpi = nixpkgs-unstable.symlinkJoin {
    name = "remnote";
    paths = [
      nixpkgs-unstable.remnote
    ];
    buildInputs = [ nixpkgs-unstable.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/remnote \
        --add-flags "--force-device-scale-factor=1.75"
      sed -i "s|Exec=.*|Exec=$out/bin/remnote|" $out/share/applications/remnote.desktop
    '';
  };
in
{
  environment.systemPackages = with nixpkgs-unstable; [
    remnote-hidpi
  ];
}
