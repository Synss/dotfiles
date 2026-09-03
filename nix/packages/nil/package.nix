{
  lib,
  symlinkJoin,
  makeWrapper,
  nil,
  nixfmt,
}:
symlinkJoin {
  name = "nil-wrapped-${nil.version}";
  paths = [ nil ];
  nativeBuildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/nil --prefix PATH : ${lib.makeBinPath [ nixfmt ]}
  '';
  meta = nil.meta;
}
