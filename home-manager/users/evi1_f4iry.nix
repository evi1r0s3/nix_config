{ lib, version, config, ... }:
{
    imports = [
        ../gtk-qt
        ../direnv
        ../fcitx5
        ../helix
        ../kitty
        #../ghostty
        ../Pictures
        ../shell
        ../zellij
        ../emacs
        ../hyprland
        # ../foot
    ];

    home = {
        username = "evi1_f4iry";
        homeDirectory = lib.mkForce "/home/evi1_f4iry";
        stateVersion = "${version}";
    };

    sops = {
        defaultSopsFile = ../../secrets/secrets.yaml;
        defaultSopsFormat = "yaml";
        age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    };

    programs.home-manager.enable = true;

    sops.secrets = {
      "github/username" = { };  
      "github/email" = { };  
    };

    sops.templates."git-config" = {
        content = ''
            [user]
                name = ${config.sops.placeholder."github/username"}
                email = ${config.sops.placeholder."github/email"}
        '';
    };
    
    programs.git = {
        enable = true;
        settings = {
            init.defaultBranch = "main";
        };
        includes = [
            { path = config.sops.templates."git-config".path; }
        ];
    };
}
