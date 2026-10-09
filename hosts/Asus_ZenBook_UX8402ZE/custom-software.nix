{ pkgs, ... }: {
  environment.systemPackages = [
    (pkgs.callPackage ../../pkgs/burpsuite_pro/package.nix { })
    (pkgs.callPackage ../../pkgs/binary_ninja/package.nix { })
    #(pkgs.callPackage ../../pkgs/remote_desktop_manager/package.nix { })
    #(pkgs.callPackage ../../pkgs/karing/package.nix { })
  ];
}
