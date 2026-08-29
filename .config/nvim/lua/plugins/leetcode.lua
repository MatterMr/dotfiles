return {
  "kawre/leetcode.nvim",
  build = ":TSUpdate html", -- if you have `nvim-treesitter` installed
  dependencies = {
    -- include a picker of your choice, see picker section for more details
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  opts = {
    ---@type string
    arg = "leetcode.nvim",

    ---@type lc.lang
    lang = "rust",

    cn = { -- leetcode.cn
      enabled = false, ---@type boolean
      translator = true, ---@type boolean
      translate_problems = true, ---@type boolean
    },

    ---@type lc.storage
    storage = {
      home = vim.fn.stdpath("data") .. "/leetcode",
      cache = vim.fn.stdpath("cache") .. "/leetcode",
    },

    ---@type table<string, boolean>
    plugins = {
      non_standalone = false,
    },

    ---@type boolean
    logging = true,

    injector = {
      ["rust"] = {
        before = { "#[allow(dead_code)]", "fn main(){}", "#[allow(dead_code)]", "struct Solution;" },
      }, ---@type table<lc.lang, lc.inject>
    },

    cache = {
      update_interval = 60 * 60 * 24 * 7, ---@type integer 7 days
    },

    editor = {
      reset_previous_code = true, ---@type boolean
      fold_imports = true, ---@type boolean
    },

    console = {
      open_on_runcode = true, ---@type boolean

      dir = "row", ---@type lc.direction

      size = { ---@type lc.size
        width = "90%",
        height = "75%",
      },

      result = {
        size = "60%", ---@type lc.size
      },

      testcase = {
        virt_text = true, ---@type boolean

        size = "40%", ---@type lc.size
      },
    },

    description = {
      position = "left", ---@type lc.position

      width = "40%", ---@type lc.size

      show_stats = true, ---@type boolean
    },

    ---@type lc.picker
    picker = { provider = nil },

    hooks = {
      ---@type fun(question: lc.ui.Question)[]
      ["question_enter"] = {
        function()
          local file_extension = vim.fn.expand("%:e")
          if file_extension == "rs" then
            local target_dir = vim.fn.stdpath("data") .. "/leetcode"
            local output_file = target_dir .. "/rust-project.json"

            if vim.fn.isdirectory(target_dir) == 1 then
              local crates = ""
              local next = ""

              local rs_files = vim.fn.globpath(target_dir, "*.rs", false, true)
              for _, f in ipairs(rs_files) do
                local file_path = f
                crates = crates .. next .. '{"root_module": "' .. file_path .. '","edition": "2021","deps": []}'
                next = ","
              end

              if crates == "" then
                print("No .rs files found in directory: " .. target_dir)
                return
              end

              local sysroot_src = vim.fn.system("rustc --print sysroot"):gsub("\n", "")
                .. "/lib/rustlib/src/rust/library"

              local json_content = '{"sysroot_src": "' .. sysroot_src .. '", "crates": [' .. crates .. "]}"

              local file = io.open(output_file, "w")
              if file then
                file:write(json_content)
                file:close()

                -- rustaceanvim names its client "rust-analyzer" (hyphen) and
                -- manages it outside lspconfig, so match that name and restart
                -- via rustaceanvim's own command rather than :LspRestart
                -- (which only knows lspconfig-managed clients).
                if #vim.lsp.get_clients({ name = "rust-analyzer" }) > 0 then
                  vim.cmd("RustAnalyzer restart")
                end
              else
                print("Failed to open file: " .. output_file)
              end
            else
              print("Directory " .. target_dir .. " does not exist.")
            end
          end
        end,
      },
    },

    keys = {
      toggle = { "q" }, ---@type string|string[]
      confirm = { "<CR>" }, ---@type string|string[]

      reset_testcases = "r", ---@type string
      use_testcase = "U", ---@type string
      focus_testcases = "H", ---@type string
      focus_result = "L", ---@type string
    },

    ---@type lc.highlights
    theme = {},

    ---@type boolean
    image_support = true,
  },
}
