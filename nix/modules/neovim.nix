{
  pkgs,
  config,
  dotfilesDir,
  ...
}:
let
  inherit (import ./lib.nix { inherit config dotfilesDir; }) mkLink;

  mkDataFiles =
    path: files:
    builtins.listToAttrs (
      map (file: {
        name = "${path}/${file.pname}";
        value.source = file;
      }) files
    );
in
{
  home.packages = with pkgs; [
    neovim
    neovim-remote

    # LSP servers | nvim
    actions-languageserver # -     gh_action_ls
    ansible-language-server # -    ansiblels
    bash-language-server # -       bashls
    basedpyright # -               basedpyright
    clang-tools # -                clangd
    groovy-language-server # -     groovyls
    lua-language-server # -        lua_ls
    marksman # -                   marksman
    nil # -                        nil_ls
    nixd # -                       nixd
    perlnavigator # -              perlnavigator
    ruff # -                       ruff
    starpls # -                    starpls
    typos-lsp # -                  typos_lsp
    vscode-langservers-extracted # cssls eslint html jsonls
    yaml-language-server # -       yaml-language-server
  ];

  home.file.".config/nvim" = mkLink "nvim";

  xdg.dataFile =
    with pkgs.vimPlugins;
    mkDataFiles "nvim/site/pack/nix/start" [
      conform-nvim
      fzf-lua
      gruvbox-nvim
      lazyjj-nvim
      lualine-nvim
      mini-ai
      mini-bufremove
      mini-icons
      mini-surround
      nerdy-nvim
      nvim-lspconfig
      nvim-web-devicons
      oil-nvim
      vim-nix
      tiny-inline-diagnostic-nvim
      which-key-nvim
      zoxide-vim
    ];
}
