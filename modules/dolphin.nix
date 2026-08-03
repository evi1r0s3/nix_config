{ nixpkgs-default, ... }:
let
  dolphin-overlay = nixpkgs-default.symlinkJoin {
    name = "dolphin";
    paths = [
      nixpkgs-default.kdePackages.dolphin
    ];
    buildInputs = [ nixpkgs-default.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/dolphin \
        --set QT_STYLE_OVERRIDE kvantum \
        --set QT_QPA_PLATFORMTHEME qt6ct \
        --set XDG_CONFIG_DIRS "${nixpkgs-default.libsForQt5.kservice}/etc/xdg:$XDG_CONFIG_DIRS" \
        --run "${nixpkgs-default.kdePackages.kservice}/bin/kbuildsycoca6 --noincremental ${nixpkgs-default.libsForQt5.kservice}/etc/xdg/menus/applications.menu"
    '';
  };
in
{
  environment.systemPackages = with nixpkgs-default; [
    kdePackages.konsole
    dolphin-overlay
    kdePackages.kservice
    libsForQt5.kservice
    kdePackages.kio
    kdePackages.kio-fuse # to mount remote filesystems via FUSE
    kdePackages.kio-extras # extra protocols support (sftp, fish and more)
    ## Previews Check Arch Wiki for this: https://wiki.archlinux.org/title/Dolphin#File_previews
    kdePackages.kdegraphics-thumbnailers # Pics, PDF, & Blender??
    kdePackages.ffmpegthumbs # Videos
    icoutils # Ico
    kdePackages.kdesdk-thumbnailers # Extentions
    kdePackages.kimageformats # Gimp
    kdePackages.qtimageformats # Other Pics
    resvg # Svgs
    kdePackages.taglib # Audio
    kdePackages.plasma-workspace # to fix issue with mime associations in dolphin
    
  ];
  #programs.dconf.enable = true;
  #environment.etc."/xdg/menus/applications.menu".text =
  #  builtins.readFile
  #  "${nixpkgs-default.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu"; # Specifically for the nix-daemon (if relevant) // this actually fixed the dolphine mime app issue

}
