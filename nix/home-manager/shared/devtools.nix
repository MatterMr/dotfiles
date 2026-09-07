{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    cmake

    # OCaml
    ocaml
    dune

  ];
}
