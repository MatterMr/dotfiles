return {
  "inhesrom/remote-ssh.nvim",
  branch = "master",
  event = "VeryLazy",
  dependencies = {
    "inhesrom/telescope-remote-buffer",
    "nvim-telescope/telescope.nvim", -- required by the plugin even though LazyVim uses snacks
    "nvim-lua/plenary.nvim",
    "neovim/nvim-lspconfig",
  },
  config = function()
    require("telescope-remote-buffer").setup()
    require("remote-ssh").setup({
      -- LazyVim sets LSP keymaps via an LspAttach autocmd, so nothing is needed here
      on_attach = function(_, _) end,
      capabilities = require("blink.cmp").get_lsp_capabilities(),
      filetype_to_server = {
        c = "clangd",
        cpp = "clangd",
        rust = "rust_analyzer",
        lua = "lua_ls",
        python = "pylsp",
      },
    })
  end,
}
