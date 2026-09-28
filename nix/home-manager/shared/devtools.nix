{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # Dev tools
    devcontainer
    cmake
    curl
    netcat
    gcc
    bear

    # OCaml
    ocaml
    dune
    ocamlPackages.utop

    # md to pdf compliation
    pandoc

    # AI helper tools
    poppler

    # Extra
    gitlab-runner
  ];
}
