{
  pkgs,
  mod,
  ...
}:
let
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
    #
    # See also `nix/modules/languages`
    marksman # -                   marksman
    nil # -                        nil_ls
    typos-lsp # -                  typos_lsp
  ];

  home.file.".config/nvim" = mod.mkLink "nvim";

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
