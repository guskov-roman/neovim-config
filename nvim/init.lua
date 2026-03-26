-- ## config
-- local opt = vim.opt
local g = vim.g
local opt = vim.opt
local cmd = vim.cmd
local api = vim.api
local fn = vim.fn

g.mapleader = " "
g.maplocalleader = "\\"

opt.showmode = false
opt.shortmess:append{I = true}
opt.termguicolors = true

opt.cmdheight = 0

opt.number = true
opt.relativenumber = true

opt.cursorline = true

opt.autoindent = true -- smartindent, cindent
opt.expandtab = true
-- opt.tabstop = 4
opt.shiftwidth = 0
opt.listchars = "tab:│ ,multispace:┊   " -- ┊ " :h listchars
opt.list = true
-- ? make shell fallback
-- if vim.fn.executable(preferred_shell) == 1 then
opt.shell = "bash" -- ?yash

-- opt.textwidth = 80
opt.so = 7

opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

vim.opt.colorcolumn = '120'
vim.opt.showtabline = 2

opt.clipboard:append("unnamedplus") -- use system clipboard as default register
-- ? add binary files to the list, ?seperate mode if i want to edit a binary file
-- vim.opt.wildignore = { '*.o', '*.a', '__pycache__' }

-- ## plugins

-- packer bootstrap
local ensure_packer = function()
	local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
		vim.cmd [[packadd packer.nvim]]
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

require('packer').startup(function(use)
	use 'wbthomason/packer.nvim' -- self managing
	use 'neovim/nvim-lspconfig'
	use 'lewis6991/gitsigns.nvim'
	use 'preservim/tagbar'
	use 'nvim-treesitter/nvim-treesitter-context'
        use 'preservim/nerdtree'
        use { "ellisonleao/gruvbox.nvim" }
        use { "nanotech/jellybeans.vim" }
	use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.8',
	-- or                            , branch = '0.1.x',
	  requires = { {'nvim-lua/plenary.nvim'} }
	}
	use 'folke/zen-mode.nvim'
	use 'mfussenegger/nvim-dap'
	use {
		'saghen/blink.cmp',
		version = '^1.*',
		config = function()
			require('blink.cmp').setup({
			  -- keymap = { preset = 'supertab' },
			  sources = {
				default = { 'lsp', 'path', 'snippets', 'buffer' },
			  },
			  fuzzy = { implementation = 'lua' },
			  completion = {
				keyword = { range = 'prefix' },
			  },
			  menu = { autoshow = true },
			})
		 end,
	}
	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if packer_bootstrap then
		require('packer').sync()
	end
end)

-- ### plugin setup

require('blink.cmp').setup({
  	  sources = {
		default = { 'lsp', 'path', 'snippets', 'buffer' },
	  },
	  keymap = { preset = 'enter' },
	  fuzzy = { implementation = 'lua' },
})



local blink_caps = require('blink.cmp').get_lsp_capabilities()
vim.lsp.config('clangd', {
	capabilities = require('blink.cmp').get_lsp_capabilities()
})

-- lsp
vim.lsp.enable({
	'clangd',
	'lua_ls',
	'zls',
	'ghdl_ls',
	-- 'pylsp',
	'jedi_language_server',
})

-- telescope
require('telescope').setup({
	defaults = {
		layout_strategy = 'vertical',
		layout_config = { height = 0.95},
		preview = {
			treesitter = {
				enable = false,
			}
		},
		path_display = { "smart" },
		theme = "ivy",
	},
  pickers = {
	-- todo: select theme depending on the screen width
    find_files = {
		theme = "ivy",
		-- sorter = require('telescope.sorters').get_generic_fuzzy_sorter()
	},
    live_grep = { theme = "ivy", },
	-- lsp_references = { theme = "ivy", },
  },
})

-- require('blink.cmp').setup({
--   keymap = { preset = 'supertab' },
-- })
--

local gitsigns = require'gitsigns'

-- ## keybindings

local map = vim.keymap.set
local nmap = function(lhs, rhs) map('n', lhs, rhs, {noremap = true}) end
local imap = function(lhs, rhs) map('i', lhs, rhs, {noremap = true}) end
local vmap = function(lhs, rhs) map('v', lhs, rhs, {noremap = true}) end
local lmap = function(lhs, rhs) map('n', '<leader>' .. lhs, rhs, {noremap = true}) end
local vlmap = function(lhs, rhs) map('v', '<leader>' .. lhs, rhs, {noremap = true}) end
local amap = function(lhs, rhs) map('ca', lhs, rhs, {noremap = true}) end

-- edit mode
imap('kj', "<esc><cmd>w<cr>") -- :<esc> resets status bar
lmap('i', "<cmd>w<cr>")

-- telescope
local tsc_builtin = require('telescope.builtin')
lmap('ff', tsc_builtin.find_files)
lmap('fg', tsc_builtin.live_grep)
lmap('fo', function() tsc_builtin.live_grep({grep_open_files=true}) end)
lmap('fj', tsc_builtin.grep_string)
lmap('b', tsc_builtin.buffers)
lmap('fh', tsc_builtin.help_tags)
-- https://github.com/nvim-telescope/telescope.nvim#pickers
lmap('gr', tsc_builtin.lsp_references)
lmap('gd', tsc_builtin.lsp_definitions)
lmap('gi', tsc_builtin.lsp_implementations)
lmap('gg', tsc_builtin.diagnostics)
lmap('s', tsc_builtin.lsp_document_symbols)

-- lsp
lmap('r', ":lua vim.lsp.buf.rename('')<Left><Left>")
nmap('gF', "<cmd>:lua vim.lsp.buf.format()<cr>")
-- nmap('gi', function()
--   vim.lsp.buf.code_action({
--     filter = function(a) return a.isPreferred end,
--     apply = true
--   })
-- end)
nmap('gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
nmap('gh', '<cmd>lua vim.lsp.buf.hover()<cr>')

-- gitsigns
lmap('ha', gitsigns.stage_hunk)
lmap('hu', gitsigns.undo_stage_hunk)
lmap('hs', gitsigns.select_hunk)
lmap('hr', gitsigns.reset_hunk)
lmap('hA', gitsigns.stage_buffer)
lmap('hR', gitsigns.reset_buffer)
lmap('hp', gitsigns.preview_hunk)
lmap('hi', gitsigns.preview_hunk_inline)
lmap('hb', gitsigns.blame_line)
lmap('hB', gitsigns.blame)
lmap('hd', gitsigns.diffthis)
lmap('tb', gitsigns.toggle_current_line_blame)
lmap('tw', gitsigns.toggle_word_diff)
vlmap('hs', function() gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end)
vlmap('hr', function() gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end)
nmap(']c', function() if vim.wo.diff then vim.cmd.normal({']c', bang = true}) else gitsigns.nav_hunk('next') end end)
nmap('[c', function() if vim.wo.diff then vim.cmd.normal({'[c', bang = true}) else gitsigns.nav_hunk('prev') end end)
-- nmap(']c', gitsigns.next_hunk)
-- nmap('[c', gitsigns.prev_hunk)
map({'o', 'x'}, 'ih', gitsigns.select_hunk) -- make select_hunk work with c,d,y,...
-- add git stash push --staged, optional message

-- zen
lmap('z', require('zen-mode').toggle)

-- if shift still pressed down after ':'
amap('W', 'w')
amap('Wq', 'wq')
amap('Q', 'q')
amap('X', 'x')

-- config
lmap('cj', "<cmd>luafile $MYVIMRC<cr>")
lmap('ck', "<cmd>e $MYVIMRC<cr>")
-- lmap('cr', "<cmd>luafile $MYVIMRC<cr><cmd>PackerClean<cr><cmd>PackerInstall<cr><cmd>PackerCompile<cr>")

-- clipboard
-- lmap('p', '"+p')
-- lmap('P', '"+P')
-- lmap('y', '"+y')
-- vmap('Y', '"+y')
--
vim.keymap.set("n", "<leader>l", ":bnext<CR>")
vim.keymap.set("n", "<leader>h", ":bprevious<CR>")
vim.keymap.set("n", "<leader>q", ":bp <BAR> bd #<CR>")

vim.keymap.set("n", "x", '"_x')
vim.keymap.set({"n", "v"}, "<DEL>", '"_x', {noremap = true})
vim.keymap.set({"n", "v"}, "d", '"_x', {noremap = true})
vim.keymap.set("n", "dd", '"_dd', {noremap = true})
vim.keymap.set("x", "p", 'pgvy', {noremap = true})
vim.keymap.set({"n", "v"}, "y", '"+y', {noremap = true})
vim.keymap.set("n", "<F8>", ':TagbarToggle<CR>')
vim.keymap.set("n", "<F12>", ':NERDTreeToggle<CR>')
-- gp to put cursor after pasted text
nmap('D', '"Add') -- seems like nvim pastes from the last used register
lmap(';', '"add')

-- clean way to close buffer
lmap('d', "<cmd>bp|bd#<cr>")

-- exit
-- lmap('x', "<cmd>x<cr>")
-- lmap('q', "<cmd>q<cr>")

-- clear search highlight
lmap('n', "<cmd>noh<cr>")

-- batch insert at the start of selected lines (usually comments)
vmap('I', ":norm I")

-- double new line
lmap('o', 'o<cr>')
lmap('O', 'i<cr><esc>O')

-- focus the last window
nmap(';', "<c-w><c-w>")

-- window operations (ergonomic focused)
lmap('wl', '<cmd>vs<cr><c-w><c-w>')
lmap('wh', '<cmd>vs<cr>')
lmap('wo', '<cmd>close<cr>')
lmap('wk', '<cmd>sp<cr>')
lmap('wj', '<cmd>sp<cr><c-w><c-w>')

-- ? convert to lua
cmd[[nmap <leader>wL <leader>wl<leader>ff]]

local function apply_lsp_fix()
    vim.lsp.buf.code_action({
        filter = function(action) return action.isPreferred end,
        apply = true,
    })
end

lmap('gf', apply_lsp_fix)

-- edit a word under a cursor
nmap('C', 'ciw')

-- remap reod
nmap('U', "<c-r>")

-- strange excluding search result at the end, requiring -1 for aguments
local function git_diff_apply_selected()
	local function concat_with_newline(c)
		return table.concat(c, '\n') .. '\n'
	end
	local chunk_start_line = fn.search('^@@', 'b') -- search backwards
	local chunk_end_line = fn.search('^@@', 'W') -- do not wrap around the end
	local chunk = api.nvim_buf_get_lines(0, chunk_start_line - 1, chunk_end_line - 1, true)
	-- api.nvim_paste(table.concat(chunk, '\n'), false, -1)
	local diff_header_start_line = fn.search('^diff', 'b')
	local diff_header = api.nvim_buf_get_lines(0, diff_header_start_line - 1, diff_header_start_line + 3, true)
	-- local diff = table.concat(diff_header, '\n') .. '\n' .. table.concat(chunk, '\n') .. '\n'
	local diff = concat_with_newline(diff_header) .. concat_with_newline(chunk)
	local output = fn.system("bash -c 'git apply -'", diff)
	api.nvim_paste(output, false, -1)
end
lmap('j', git_diff_apply_selected)

-- some experimental thihgs with ?signcolumns

-- vim.api.nvim_exec([[iunmap <c-h>]], false)
-- local row = api.nvim_win_get_cursor(0)[1] - 1
-- local ns_id = api.nvim_create_namespace('a')
-- api.nvim_buf_set_extmark(vim.fn.bufnr('%'), ns_id, row, 0, {end_line = 0, id = 1, virt_text = {{"▍"}}, virt_text_pos = 'overlay', virt_lines_leftcol = -1})

-- vim.api.nvim_buf_set_extmark(vim.fn.bufnr('%'), vim.api.nvim_create_namespace('a'), 111, 2, {end_line = 10, id = 1337, virt_text = {{"▍", "a"}}, virt_text_pos = 'overlay'})

-- :h signcolumn, :h sign

-- sign define sign text=|
-- sign place 1 line=140 name=sign file=.config/nvim/init.lua


-- mode for json from hckrnews


-- highlight yanked text

vim.api.nvim_exec([[
augroup YankHighlight
autocmd!
autocmd TextYankPost * silent! lua vim.hl.on_yank{higroup="IncSearch", timeout=300}
augroup end
]], false)

-- ## style

local hl = function(name, val) vim.api.nvim_set_hl(0, name, val) end

-- color palette
local p = {
	white = "#ffffff",
	black = "#000000",
	blue = "#22a5ef",
	darkblue = "#005f87",
	paleblue = "#5f87af",
	lightpaleblue = "#97bfeb",
	chiralgold = "#c59909",
	palegold = "#e8bf97",
	darkgoold = "e48e37",
	red = "#ee1122",
	lightgrey = "#dddddd",
	grey = "#707070",
	darkgrey = "#2f2f2f",
	darkergrey = "#1f1f1f",
	orange = "#dc4d01",
	green = "#b7ceaa",

	xkcd = {
		lightred = "#ff474c",
		goldenrod = "#fac205",
	}
}

local theme = {
	Normal = {fg = p.white},

	Comment = {fg = p.grey},

	-- Constant = {fg = p.chiralgold},
	Constant = {fg = p.paleblue},
	String = {fg = p.paleblue},
	-- Character = {fg = p.white},
	-- Number = {fg = p.white},
	-- Boolean = {fg = p.white},
	-- Float = {fg = p.white},

	Identifier = {fg = p.white},
	Function = {fg = p.palegold},

	Statement = {fg = p.blue},
	-- Conditional = {fg = p.blue},
	-- Repeat = {fg = p.blue},
	-- Label = {fg = p.blue},
	-- Operator = {fg = p.blue},
	-- Keyword = {fg = p.blue},
	-- Exception = {fg = p.blue},

	PreProc = {fg = p.blue},
	-- Include = {fg = p.blue},
	-- Define = {fg = p.blue},
	-- Macro = {fg = p.blue},
	-- PreCondit = {fg = p.blue},

	Type = {fg = p.blue},
	-- StorageClass = {fg = p.blue},
	-- Structure = {fg = p.blue},
	-- Typedef = {fg = p.blue},

	Special = {fg = p.blue},
	-- SpecialChar = {fg = p.blue},
	-- Tag = {fg = p.blue},
	-- Delimiter = {fg = p.blue},
	-- SpecialComment = {fg = p.blue},
	-- Debug = {fg = p.blue},

	Todo = {fg = p.blue},

	IncSearch = {fg = p.black, bg = p.lightgrey},
	Search = {fg = p.white, bg = p.darkgrey},

	Pmenu = {fg = p.white, bg = p.black},
	PmenuSel = {fg = p.black, bg = p.white},

	Visual = {bg = p.darkgrey},

	MatchParen = {fg = p.white, bg = p.orange},

	TrailingWhitespace = {bg = p.xkcd.lightred},
	IndentGuides = {fg = p.darkgrey},
	EndOfBuffer = {fg = p.darkgrey},

	SignColumn = {bg = p.black},

	NonText = {fg = p.white, bg = p.black},
	Title = {fg = p.white, bg = p.black},

	Folded = {bg = p.darkgrey},
	-- FoldColumn = {},

	DiffAdd = {fg = p.white, bg = p.black},
	DiffChange = {fg = p.white, bg = p.black},
	DiffDelete = {fg = p.white, bg = p.black},

	StatusLine = {fg = p.white, bg = p.darkblue},
	StatusLineNC = {fg = p.grey},
	StatusLeft = {fg = p.black, bg = p.white, bold = true},
	StatusLeftSepCorner = {fg = p.white},
	StatusLeftSepLine = {fg = p.darkblue},
	StatusRight = {fg = p.black, bg = p.white, bold = false},

	LineNr = {fg = p.grey},
	CursorLineNr = {fg = p.white},
	CursorLine = {bg = p.darkergrey },

	SpecialKey = {fg = p.blue},

	MoreMsg = {fg = p.white},
	Question = {fg = p.white},

	GreenFg = {fg = p.green},
	GreenBg = {fg = p.black, bg = p.green},
	DarkGreen = {bg = "#819775"},
}

-- apply theme
-- for name, val in pairs(theme) do
-- 	hl(name, val)
-- end
-- vim.cmd [[colorscheme habamax]]

vim.o.background = "dark" -- dark or "light" for light mode
-- vim.o.background = "light" -- dark or "light" for light mode
vim.cmd([[colorscheme jellybeans]])

-- highlight trailing whitespaces   
-- ugly 2match 3match system (?better)
-- something resets TrailingWhitespace and IndentGuides matches
-- also syntax before match break doesnt reapply highlight
cmd[[au BufEnter * silent! match IndentGuides /\s\+/]]
cmd[[au WinLeave * silent! match IndentGuides /\s\+/]]
cmd[[au BufEnter * silent! 2match TrailingWhitespace /\s\+$/]]
cmd[[au WinLeave * silent! 2match TrailingWhitespace /\s\+$/]]

-- cmd[[match IndentGuides /\s\+/]] -- keeps trailing highlight

-- disable comment autowrap, disables auto insert of leader comment mark on enter and on o/O,
-- possibly for pasting code from clipboard via <c-v> in insert mode
-- cmd[[autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o]]

-- disable insert comment leader on enter or o/O
cmd[[autocmd FileType * setlocal formatoptions-=r formatoptions-=o]]

-- opt.laststatus=3
-- shape charset  █  █ 
-- something yoinked from mini.statusline
opt.statusline = "%#StatusLeft# " ..
				 "%{luaeval('vim.fn.mode()')} " ..
				 "%#StatusLeftSepCorner#" ..
				 "%{%(nvim_get_current_win()==#g:actual_curwin || &laststatus==3) ? '%#StatusLine#' : '%#StatusLineNC#'%}" ..
				 "%f %m %r" .. -- filename, modified, read-only
				 "%=" .. -- seperator for left and right
				 "%Y  " .. -- filetype
				 "%p%% " .. -- % of the current file
				 "%#StatusLeftSepCorner#" ..
				 "%#StatusRight# " ..
				 "%l:%c " .. -- line:column
				 "%{&ff ==# 'unix' ? '' : '[' .. &ff .. ']'}" --- show fileformat only for dos/mac
