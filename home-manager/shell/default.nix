{
  home.file.".zshrc".source = ./.zshrc;
  home.file.".config/atuin/config.toml".source = ./atuin_config.toml;
  home.file.".config/starship.toml".source = ./starship.toml;
  home.file.".config/lsd" = {
    source = ./lsd;
    recursive = true;
  };
}
