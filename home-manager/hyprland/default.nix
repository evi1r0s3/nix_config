{
  xresources.properties = {
    "Xcursor.size" = 24;
    "Xft.dpi" = 144;
  };

  home.file.".config/hypr" = {
    source = ./hypr;
    recursive = true;
  };

  home.file.".config/ashell" = {
    source = ./ashell;
    recursive = true;
    executable = true;
  };

  home.file.".config/tofi/config".source = ./tofi_config;
  home.file.".config/mako/config".source = ./mako_config;
}
