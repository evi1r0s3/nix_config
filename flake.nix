{
    description = "NixOS config";
    inputs = {
        # stable
        #nixpkgs-stable-tsinghua.url = "git+https://mirrors.tuna.tsinghua.edu.cn/git/nixpkgs.git?ref=nixos-25.11&shallow=1";
        #nixpkgs-stable-ustc.url = "git+https://mirrors.ustc.edu.cn/git/nixpkgs.git?ref=nixos-25.05&shallow=1";
        #nixpkgs-stable-sjtu.url = "git+https://mirror.sjtu.edu.cn/git/nixpkgs.git?ref=nixos-25.05&shallow=1";
        nixpkgs-stable-org.url = "github:Nixos/nixpkgs/nixos-26.05";
        # unstable
        #nixpkgs-unstable-tsinghua.url = "git+https://mirrors.tuna.tsinghua.edu.cn/git/nixpkgs.git?ref=nixos-unstable&shallow=1";
        #nixpkgs-unstable-ustc.url = "git+https://mirrors.ustc.edu.cn/git/nixpkgs.git?ref=nixos-unstable&shallow=1";
        #nixpkgs-unstable-sjtu.url = "git+https://mirror.sjtu.edu.cn/git/nixpkgs.git?ref=nixos-unstable&shallow=1";
        nixpkgs-unstable-org.url = "github:Nixos/nixpkgs/nixos-unstable";

        sops-nix = {
          url = "github:Mic92/sops-nix";
          inputs.nixpkgs.follows = "nixpkgs-stable-org";
        };
        
        hm.url = "github:nix-community/home-manager/release-26.05";
        nur.url = "github:nix-community/NUR";
        ashell.url = "github:MalpenZibo/ashell";

        rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
    };

    outputs = { self, ... }@inputs:
        let
            user-name = "evi1_f4iry";
            version = "26.05";
            arch-os = "x86_64-linux";
            #lib = inputs.nixpkgs-stable-tsinghua.lib;
            lib = inputs.nixpkgs-stable-org.lib;
            #nixpkgs-default = inputs.nixpkgs-stable-tsinghua;
            #nixpkgs-stable = import inputs.nixpkgs-stable-tsinghua {
            nixpkgs-stable = import inputs.nixpkgs-stable-org {
                system = arch-os;
                config.allowUnfree = true;
                config.permittedInsecurePackages = [ "openssl-1.1.1w" ];
                config. problems.handlers = {
                     rtl88xxau-aircrack.broken = "warn"; # or "ignore"
                };
            };
            #nixpkgs-unstable = import inputs.nixpkgs-unstable-tsinghua {
            nixpkgs-unstable = import inputs.nixpkgs-unstable-org {
                system = arch-os;
                config.allowUnfree = true;
                config.permittedInsecurePackages = [ "openssl-1.1.1w" ];
            };
            nur-pkgs = import inputs.nur { pkgs = nixpkgs-unstable; nurpkgs = nixpkgs-unstable; };
            nixpkgs-default = nixpkgs-stable;
        in {
            nixosConfigurations = {
           
            ZenNixOS = lib.nixosSystem {
                    system = arch-os;
                    specialArgs = {
                        inherit nixpkgs-default;
                        inherit nixpkgs-unstable;
                        inherit nur-pkgs;
                        inherit user-name;
                        inherit version;
                        inherit inputs;
                    };

                    modules = [
                        # sops
                        inputs.sops-nix.nixosModules.sops
                        # home-manager
                        inputs.hm.nixosModules.home-manager {
                            home-manager = {
                                useGlobalPkgs = true;
                                useUserPackages = true;
                                extraSpecialArgs = {
                                        inherit nixpkgs-default;
                                        inherit nixpkgs-unstable;
                                        inherit nur-pkgs;
                                        inherit user-name;
                                        inherit version;
                                        inherit inputs;
                                };
                                users.${user-name} = {
                                    imports = [
                                        inputs.sops-nix.homeManagerModules.sops
                                        ./home-manager/users/${user-name}.nix
                                    ];
                                };
                            };
                        }
                        
                        # others
                        # basic
                        ./modules/substituters.nix
                        ./hosts/Asus_ZenBook_UX8402ZE
                        ./modules/zen_kernel.nix
                        #./modules/lightdm.nix
                        #./modules/sddm.nix
                        # rules
                        ./modules/garbage_collect.nix
                        ./modules/security.nix
                        ./modules/sops.nix
                        #./modules/udev_rules.nix
                        # env
                        ./modules/zsh.nix
                        ./modules/sshd.nix
                        ./modules/fonts.nix
                        ./modules/fcitx5.nix
                        ./modules/basic_tools.nix
                        #./modules/plasma.nix
                        #./modules/dolphin.nix
                        ./modules/thunar.nix
                        ./modules/hyprland.nix
                        #./modules/tuigreet_hyprland.nix
                        # tools
                        #./modules/python.nix
                        ./modules/flatpak.nix
                        ./modules/docker.nix
                        ./modules/flipper_zero.nix
                        ./modules/offsec_SDR.nix
                        ./modules/offsec_tools.nix
                        ./modules/python.nix
                        ./modules/wireshark.nix
                        ./modules/singbox.nix
                        ./modules/netbird.nix
                        ./modules/cloudflare-warp.nix
                        ./modules/telegram.nix
                        #./modules/nur_basic_tools.nix
                        ./modules/wps-cn.nix
                        ./modules/wechat.nix
                        ./modules/wemeet.nix
                        ./modules/remnote.nix
                        ./modules/obsidian.nix
                        ./modules/vscode.nix
                        #./modules/siyuan.nix
                        #./modules/nextcloud-client.nix
                        #./modules/seafile_drive.nix
                        #./modules/opencloud.nix
                        #./modules/siyuan.nix
                        #./modules/trilium.nix
                        #./modules/emacs.nix
                        # costom tools
                    ];
            };
        };
    };
}
