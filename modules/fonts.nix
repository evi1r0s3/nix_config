{ nixpkgs-default, ... }:
{
  fonts = {
    packages = [
      ###
      # 25.05
      # vista-fonts-chs
      nixpkgs-default.nerd-fonts.intone-mono
      nixpkgs-default.nerd-fonts.jetbrains-mono
      nixpkgs-default.nerd-fonts.comic-shanns-mono
      # nixpkgs-default.vistafonts-chs
      nixpkgs-default.ubuntu-sans-mono
      nixpkgs-default.noto-fonts-cjk-sans
      nixpkgs-default.unifont
      nixpkgs-default.maple-mono.NF-CN
      nixpkgs-default.sarasa-gothic
      # emojione #
      # wps fonts #
      #pkgs-nur.repos.rewine.ttf-wps-fonts
      #pkgs-nur.repos.rewine.ttf-ms-win10
      #inputs.wpsFonts.packages.${pkgs-default.system}.default
    ];
    fontDir.enable = true;
    fontconfig = {
      enable = true;
      includeUserConf = true;
      # 抗模糊优化
      antialias = true;
      hinting = {
        enable = true;
        style = "medium";
        autohint = true;
      };
      subpixel = {
        lcdfilter = "default";
        rgba = "rgb";
      };
    };
    # /run/current-system/sw/share/X11/fonts/
  };
}

