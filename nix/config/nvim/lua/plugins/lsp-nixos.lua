-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/eslint.lua
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        rust_analyzer = {},
        ruff = {},
        jdtls = {},
        pyright = {},
        nil_ls = {},
        yamlls = {},
        ocamllsp = {},
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "Lua 5.4" }, -- Hyprland embeds standard Lua; confirm vs repo
              workspace = {
                checkThirdParty = false,
                library = {
                  "/run/current-system/sw/share/hypr",
                },
              },
              diagnostics = {
                globals = { "vim", "hl" }, -- silence "undefined global hl" if defs aren't loaded
              },
            },
          },
        },
        -- -- javascript
        --   eslint = {
        -- tailwindcss = {},
        --     filetypes = {
        --       "javascript",
        --       "javascriptreact",
        --       "javascript.jsx",
        --       "typescript", "typescriptreact",
        --       "typescript.tsx",
        --       "vue",
        --       "svelte",
        --       "astro",
        --       "html",
        --     },
        --   },
        -- vtsls = {},
        tailwindcss = {},
        svelte = {},
        volar = {}, -- vue-language-server
        ts_ls = {},
        templ = {},
        gleam = {},
        -- BEGIN CSCI442 devcontainer clangd (added by Claude, 2026-11-08)
        -- Runs clangd inside the CSCI442 dev container for files under student-env, so
        -- diagnostics match `make` (Linux clang + glibc headers, e.g. pthread_barrier_t).
        -- Finds the container by its devcontainer.local_folder label; falls back to host
        -- clangd when the file is elsewhere or the container is not running.
        -- Requires clangd installed in the container image.
        -- TO REMOVE: delete everything between BEGIN/END and restore `clangd = {},`
        clangd = {
          cmd = function(dispatchers, config)
            local host_root = vim.fn.expand("~/Documents/college/senior/CSCI442/student-env")
            local root = config.root_dir or vim.fn.getcwd()
            local cmd = { "clangd", "--background-index" }
            if root:sub(1, #host_root) == host_root then
              local id = vim.fn.trim(vim.fn.system({
                "docker", "ps", "-q", "--filter", "label=devcontainer.local_folder=" .. host_root,
              }))
              if vim.v.shell_error == 0 and id ~= "" then
                cmd = {
                  "docker", "exec", "-i", "-w", "/workspace" .. root:sub(#host_root + 1), id,
                  "clangd", "--background-index",
                  "--path-mappings=" .. host_root .. "=/workspace",
                }
              end
            end
            return vim.lsp.rpc.start(cmd, dispatchers, { cwd = root })
          end,
        },
        -- END CSCI442 devcontainer clangd
      },
    },
  },
  -- adding formatting here as well because why not
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        -- Conform will run multiple formatters sequentially
        python = { "isort", "black" },
        -- You can customize some of the format options for the filetype (:help conform.format)
        rust = { "rustfmt", lsp_format = "fallback" },
        -- Conform will run the first available formatter
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        svelte = { "prettierd", "prettier", stop_after_first = true },
        markdown = { "prettierd", "prettier", stop_after_first = true },
        go = { "goimports", "gofumpt" },
        html = { "prettier" },
        templ = { "rustywind", "templ" },
        nix = { "nixfmt" },
        gleam = { "gleam" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        ocaml = { "ocamlformat" },
      },
      formatters = {
        prettier = {
          require_cwd = true,
        },
      },
    },
  },
}
