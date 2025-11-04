---------------------------
-- Options               --
---------------------------
-- Basics
vim.o.relativenumber = true
vim.o.number = true
vim.o.scrolloff = 4
vim.o.winborder = "bold"
vim.o.signcolumn = "yes"
vim.o.termguicolors = true
vim.o.swapfile = false
vim.o.winbar = "%=%F"
vim.g.mapleader = " "

-- Tabs
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = false

-- Folds
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.foldlevelstart = 99

---------------------------
-- Plugins               --
---------------------------
vim.pack.add({
	-- Themes
	{ src = "https://github.com/uZer/pywal16.nvim" },                   -- pywal16 theme, needs pywal16 installed
	{ src = "https://github.com/bluz71/vim-moonfly-colors" },           -- manual fallback theme, pywal16 doesnt always make nice ones :(

	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },         -- Icons for Oil and others
	{ src = "https://github.com/nvim-lua/plenary.nvim" },               -- dependency of harpoon

	{ src = "https://github.com/neovim/nvim-lspconfig" },               -- lsp configuration database
	{ src = "https://github.com/mason-org/mason.nvim" },                -- language server manager

	{ src = "https://github.com/romainl/vim-cool" },                    -- hides highlight after search
	{ src = "https://github.com/lukas-reineke/indent-blankline.nvim" }, -- indentation lines
	{ src = "https://github.com/norcalli/nvim-colorizer.lua" },         -- colour Highlights -> #771155
	{ src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim" }, -- inline diagnostics
	{ src = "https://gitlab.com/HiPhish/rainbow-delimiters.nvim" },     -- rainbow parenthesis, needs Tree-Sitter

	{ src = "https://github.com/stevearc/oil.nvim" },                   -- file browser
	{ src = "https://github.com/nvim-mini/mini.pick" },                 -- file fuzzy finder
	{ src = "https://github.com/ThePrimeagen/harpoon" },                -- quick file changing
	{ src = "https://github.com/ggandor/leap.nvim" },                   -- cursor jumping
	{ src = "https://github.com/tpope/vim-surround" },                  -- surrounding text objects (try [cs"'])
	{ src = "https://github.com/akinsho/toggleterm.nvim" },             -- persistent floating terminal
	{
		src = "https://github.com/saghen/blink.cmp",                    -- autocomplete
		branch = "main"
	},
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter", -- TreeSitter, improved syntax highlighting and syntax tree
		branch = "main"
	},
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },

	{ src = "https://github.com/mfussenegger/nvim-dap" }, -- Debug Adapter Protocol
	{ src = "https://github.com/mfussenegger/nvim-jdtls" }, -- Java Dev Tools
	{ src = "https://github.com/danymat/neogen" }, -- Documentation/Annotation generation

})


---------------------------
-- Plugin Setup          --
---------------------------
vim.cmd [[ colorscheme pywal16 ]]

require("tiny-inline-diagnostic").setup({ preset = "minimal" }) -- needs loading before lsp
require("mason").setup()
require("ibl").setup()                                          -- ibl is indent blankline (i keep forgetting that)
require("leap").set_default_mappings()
require("colorizer").setup()
require("mini.pick").setup()
require("neogen").setup()

vim.lsp.enable({
	"lua_ls", "jdtls", "rust_analyzer", "bash-language-server", "css-lsp",
	"lemminx", "python-lsp-server", "yaml-language-server",
})

vim.lsp.config(
	"lua_ls", {
		settings = {
			Lua = {
				workspace = {
					library = vim.api.nvim_get_runtime_file("", true)
				}
			}
		}
	}
-- More lsp configs here eventually
)

require("oil").setup({
	keymaps = {
		["<Esc>"] = { "actions.close" },
		["q"] = { "actions.close" },
	},
	view_options = { show_hidden = true, }
})

require("toggleterm").setup({
	direction = "float",
	open_mapping = [[<leader>s]],
	insert_mappings = false,
	terminal_mappings = false,
	start_in_insert = true,
})

require("blink.cmp").setup({
	keymap = { preset = "super-tab" }, -- tab to complete
	fuzzy = {
		implementation = "prefer_rust",
		prebuilt_binaries = {
			force_version = "1.*"
		}
	},
	sources = {
		default = { 'lsp', 'path', 'snippets', 'buffer' },
	},
})

require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"c", "lua", "python", "vim", "vimdoc",
		"query", "markdown", "markdown_inline", "java", "rust",
	},
	sync_install = true,
	auto_install = true,
	ignore_install = {},
	modules = {},
	additional_vim_regex_highlighting = false,
	highlight = { enable = true },
	incremental_selection = { enable = true },
	indentation = { enable = true },
	folding = { enable = true },
	injections = { enable = true },
})

---------------------------
-- Binds                 --
---------------------------
vim.keymap.set("n", "<leader>w", ":w<CR>") -- [w]rite
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float) -- [d]iagnostics
vim.keymap.set("n", "<leader>m", ":Pick help<CR>")          -- minipick help searcher [m]anual

-- System Clipboard
-- leader y/p to use system clipboard
vim.keymap.set({ "n", "v", "x", "l" }, "<leader>y", '"+y')
vim.keymap.set("n", "<leader>p", '"+p')

-- Files
vim.keymap.set("n", "<leader>ff", ":Pick files<CR>") -- [f]ind [f]iles
vim.keymap.set("n", "<leader>fg", ":Pick grep_live pattern='<cword>'<CR>") -- [f]ind [g]rep 
vim.keymap.set("n", "<leader>fs", ":Oil --float<CR>") -- [f]ile [s]ystem

-- Generate
vim.keymap.set("n", "<leader>gd", ":!mvn clean compile javadoc:javadoc<CR>") -- [g]enerate [d]ocs
vim.keymap.set("n", "<leader>gc", ":Neogen class<CR>") -- [g]enerate [c]lass annotation
vim.keymap.set("n", "<leader>gt", ":Neogen type<CR>")  -- [g]enerate [t]ype annotation
vim.keymap.set("n", "<leader>gf", ":Neogen func<CR>")  -- [g]enerate [f]unction annotation

-- Toggleterm
vim.keymap.set('t', '<esc>', require("toggleterm").toggle_all) -- [t]erminal escape
-- vim.keymap.set('t', '<esc>', '<C-\\><C-n>') -- terminal escape

-- Harpoon
vim.keymap.set("n", "<leader>a", require("harpoon.mark").add_file) -- [a]dd file to harpoon
vim.keymap.set("n", "<leader>h", require("harpoon.ui").toggle_quick_menu) -- open [h]arpoon menu
for i = 1, 9 do
	vim.keymap.set("n", "<leader>" .. i, function() require("harpoon.ui").nav_file(i) end)
end -- leader 1-9 to harpoon to that file


---------------------------
-- Custom Commands       --
---------------------------
-- Custom Command for toggling Pywal theme and a set one
-- since it sometimes makes awful themes for syntax highlighting
local is_theme_pywal = true

local function toggle_pywal_theme()
	if is_theme_pywal then
		vim.cmd [[ colorscheme moonfly ]]
		is_theme_pywal = false
	else
		vim.cmd [[ colorscheme pywal16 ]]
		is_theme_pywal = true
	end
	vim.cmd [[
		highlight Normal guibg=none
		highlight NonText guibg=none
		highlight Normal ctermbg=none
		highlight NonText ctermbg=none
		highlight LineNr guibg=none
		highlight SignColumn guibg=none
		highlight StatusLine guibg=none
		highlight Winbar guibg=none
	]]
end

vim.api.nvim_create_user_command('TogglePywal', toggle_pywal_theme, {})
vim.keymap.set("n", "<leader>C", toggle_pywal_theme)

-- Custom Command for toggling a terminal that autoopens into a set command based on language
-- :make can definitely do this job, but this works fine (tho no quickfix).
local Terminal       = require('toggleterm.terminal').Terminal
local build_terminal = Terminal:new({ hidden = true, close_on_exit = false })

local function run_terminal_toggle()
	if vim.bo.filetype == "java" then
		build_terminal.cmd = "mvn -q clean compile exec:java"
	elseif vim.bo.filetype == "python" then
		build_terminal.cmd = "python \"" .. vim.api.nvim_buf_get_name(0) .. "\""
	elseif vim.bo.filetype == "lua" then
		build_terminal.cmd = "lua \"" .. vim.api.nvim_buf_get_name(0) .. "\""
	else
		print("No build command set for filetype: " .. vim.bo.filetype)
		return
	end
	build_terminal:toggle()
end

local function test_terminal_toggle()
	if vim.bo.filetype == "java" then
		build_terminal.cmd = "mvn test" -- "mvn -q clean compile exec:java"
	else
		print("No build command set for filetype: " .. vim.bo.filetype)
		return
	end
	build_terminal:toggle()
end


local function compile()
	if vim.bo.filetype == "java" then
		vim.cmd [[JdtCompile]]
	else
		vim.cmd [[make]]
	end
end

vim.keymap.set('n', '<leader>r', run_terminal_toggle)
vim.keymap.set('n', '<leader>t', test_terminal_toggle)
vim.keymap.set('n', '<leader>c', compile)
