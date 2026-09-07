return {
  { "pranphy/pamdex.nvim" },
  config = function()
    require("pamdex").setup({
      pandoc = "/path/to/pandoc", -- Default: "pandoc" (assumed to be in your system's PATH)
      template = "latex", -- Default: "latex" (Pandoc's built-in LaTeX template)
      pdf_engine = "lualatex", -- pdf engine for pandoc to use
      pdf_viewer = "zathura", -- pdf viewer to use
      lua_filter = "minted.lua", -- Default: "minted.lua"
      citeproc = true, -- Default: true
      meta_yaml = "meta.yaml", -- Default: "meta.yaml"
      pdf_engine_opts = { "--shell-escape" }, -- Default: { "--shell-escape" }
      transforms = { { "from", "to" } }, -- Replaces Lua string matching pattern `from` to `to` in Markdown content
    })
  end,
}
