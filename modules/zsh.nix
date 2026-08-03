{ nixpkgs-default, ... }:
{
  users.defaultUserShell = nixpkgs-default.zsh;
  environment.systemPackages = with nixpkgs-default; [
    lsd
    atuin
    starship
  ];

  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    histSize = 10000;
  };
}
