{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    devcontainer
    cmake

    # OCaml
    ocaml
    dune

    # md to pdf compliation
    pandoc

    gitlab-runner
  ];
}
