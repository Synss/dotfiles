{ lib }:
cfg:
{
  packages,
  lspPackages ? [ ],
}:
lib.mkMerge [
  (lib.mkIf cfg.enable {
    home.packages = packages;
  })
  (lib.mkIf (cfg.enable && cfg.lsp.enable) {
    home.packages = lspPackages;
  })
]
