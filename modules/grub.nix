{ nixpkgs-default, ... }:
{
  boot.loader = {
    efi.canTouchEfiVariables = false;
    grub = {
      enable = true;
      device = "nodev";
      useOSProber = false;
      efiSupport = true;
      font = "${nixpkgs-default.nerd-fonts.intone-mono}/share/fonts/truetype/NerdFonts/IntoneMono/IntoneMonoNerdFont-Medium.ttf";
      fontSize = 24;
      gfxmodeEfi = "2880x1800";
    };
  };
  
}
