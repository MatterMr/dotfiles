{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    gh
		git
    cmake
		wget
		nodejs
		stow
  ];
	
}
