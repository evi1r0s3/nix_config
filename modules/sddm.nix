{ nixpkgs-default, ... }:
{
  environment.systemPackages = with nixpkgs-default; [
    rose-pine-hyprcursor
    (sddm-astronaut.override {
      embeddedTheme = "hyptland_kath";
      themeConfig = {
        ScreenWidth = "2880";
        ScreenHeight = "1800";
        Font = "IntoneMono NFM";
        FontSize = "24";
      };
    })
  ];
  services.displayManager.sddm = {
    enable = true;
    enableHidpi = true;
    wayland.enable = true;
    theme = "sddm-astronaut-theme";
    settings.Theme.CursorTheme = "rose-pine-hyprcursor";
    extraPackages = with nixpkgs-default; [
      (sddm-astronaut.override {
        embeddedTheme = "hyptland_kath";
        themeConfig = {
          ScreenWidth = "2880";
          ScreenHeight = "1800";
          Font = "IntoneMono NFM";
          FontSize = "24";
        };
      })
    ];
  };
}
