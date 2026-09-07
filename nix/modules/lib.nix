{ config, dotfilesDir }:
{
  mkLink = path: {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/${path}";
  };
}
