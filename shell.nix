with import <nixpkgs> { };

mkShell {
  buildInputs = [
    sqls
    oracle-instantclient
    plantuml
    vimPlugins.plantuml-syntax
    pandoc
    texliveSmall
  ];
  shellHook = ''
    docker start oracle
    export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath [pkgs.oracle-instantclient]};
    export PLUG_PUML_PATH=$(nix eval --raw nixpkgs#vimPlugins.plantuml-syntax.outPath)
    trap "docker stop oracle" EXIT
  '';
}
