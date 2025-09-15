return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			autoinstall = true,
			highlight = { enable = true },
			indent = { enable = true },
		})
	end,
}
