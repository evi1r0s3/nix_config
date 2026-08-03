{ nixpkgs-default, ... } :
{
  programs.helix = with nixpkgs-default; {
    enable = true;
        defaultEditor = true;
    extraPackages = [
      bash-language-server
      biome
      clang-tools
      docker-compose-language-service
      dockerfile-language-server
      golangci-lint
      golangci-lint-langserver
      gopls
      gotools
      marksman
      nil
      nixd
      nixpkgs-fmt
      sql-formatter
      ruff
      (python3.withPackages (p: (with p; [
        python-lsp-ruff
        python-lsp-server
      ])))
      rust-analyzer
      tailwindcss-language-server
      taplo
      terraform-ls
      typescript
      vscode-langservers-extracted
      yaml-language-server
    ];
  };
  home.file.".config/helix/config.toml".source = ./config.toml;
}
