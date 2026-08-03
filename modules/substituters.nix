{ lib, ...}:
{
   nix.settings = {
        substituters = lib.mkForce [
            #"https://mirrors.cernet.edu.cn/nix-channels/store"
            #"https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
            #"https://mirrors.ustc.edu.cn/nix-channels/store"
            #"https://mirror.sjtu.edu.cn/nix-channels/store"
            "https://nix-community.cachix.org"
            "https://cache.nixos.org"
        ];
        trusted-public-keys = [
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        ];

        # 保存关键依赖包，阻止被垃圾回收
        keep-outputs = true;
        keep-derivations = true;
    };  
}
