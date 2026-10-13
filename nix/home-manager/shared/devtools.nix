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

    # Lanugage Support
    # OCaml
    ocaml
    dune
    ocamlPackages.utop

    # Rust
    rustlings
    rustc
    cargo

    # md to pdf compliation
    pandoc

    # AI helper tools
    poppler

    # Extra
    gitlab-runner

  ];
}
