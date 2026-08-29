-- Add Rust parsers on top of LazyVim's defaults.
-- LazyVim pins nvim-treesitter to the `main` branch and its own `config`
-- installs parsers AND wires up highlight/indent/folds via a FileType autocmd.
-- `opts_extend` makes `ensure_installed` append, so we ONLY supply opts here.
-- (The old version overrode `config`/`build`, which disabled all of that.)
-- `html` is already in LazyVim's default list, so it doesn't need repeating.
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = { 
			"bash",
			"lua",
			"nix",
			"json",
			"c",
			"cpp",
			"python",
			"rust",
		},
  },
}
