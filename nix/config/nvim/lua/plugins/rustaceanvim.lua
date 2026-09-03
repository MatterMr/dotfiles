-- Which diagnostics provider to use, mirroring the LazyVim rust extra.
-- Without this local, `diagnostics` below is a nil global and rust-analyzer
-- diagnostics silently evaluate to disabled.
local diagnostics = vim.g.lazyvim_rust_diagnostics or "rust-analyzer"

return {
  "mrcjkb/rustaceanvim",
  ft = { "rust" },
  opts = {
    server = {
      on_attach = function(_, bufnr)
        vim.keymap.set("n", "<leader>cR", function()
          vim.cmd.RustLsp("codeAction")
        end, { desc = "Code Action", buffer = bufnr })
        vim.keymap.set("n", "<leader>dr", function()
          vim.cmd.RustLsp("debuggables")
        end, { desc = "Rust Debuggables", buffer = bufnr })
      end,
      default_settings = {
        -- rust-analyzer language server configuration
        ["rust-analyzer"] = {
          cargo = {
            allFeatures = true,
            loadOutDirsFromCheck = true,
            buildScripts = {
              enable = true,
            },
          },
          -- Add clippy lints for Rust if using rust-analyzer
          checkOnSave = diagnostics == "rust-analyzer",
          -- Enable diagnostics if using rust-analyzer
          diagnostics = {
            enable = diagnostics == "rust-analyzer",
          },
          procMacro = {
            enable = true,
          },
          files = {
            -- rust-analyzer's setting is `excludeDirs`; the old `exclude`
            -- key was silently ignored, so nothing was actually excluded.
            excludeDirs = {
              ".direnv",
              ".git",
              ".jj",
              ".github",
              ".gitlab",
              "bin",
              "node_modules",
              "target",
              "venv",
              ".venv",
            },
            -- Avoid Roots Scanned hanging, see https://github.com/rust-lang/rust-analyzer/issues/12613#issuecomment-2096386344
            watcher = "client",
          },
        },
      },
    },
  },
  config = function(_, opts)
    -- codelldb is auto-detected from mason by rustaceanvim / the LazyVim rust
    -- extra, so no manual DAP adapter wiring is needed here.
    vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
    if vim.fn.executable("rust-analyzer") == 0 then
      LazyVim.error(
        "**rust-analyzer** not found in PATH, please install it.\nhttps://rust-analyzer.github.io/",
        { title = "rustaceanvim" }
      )
    end
  end,
}
