{ nixpkgs-unstable, ... }:
{
  environment.systemPackages = with nixpkgs-unstable; [
    emacs30-nox
    emacs30-pgtk
  ];
}
