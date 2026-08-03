{ nixpkgs-default, ... }:
{
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  environment.systemPackages = with nixpkgs-default; [
    kdePackages.kate
    kdePackages.konsole
  ];
}
