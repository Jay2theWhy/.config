# Neovim config

A lightweight Neovim config. Plugins are managed by the built-in
[`vim.pack`](https://neovim.io/doc/user/pack.html#vim.pack), so there's no plugin
manager to bootstrap. Language servers and formatters are installed by
[mason.nvim](https://github.com/mason-org/mason.nvim) and started with Neovim's
native `vim.lsp.enable()`.

## Requirements

Neovim **0.12.6 or newer** (`vim.pack` was added in 0.12).

The editor needs these tools on `PATH` before first launch. Mason uses most of
them to build packages:

| Tool | Needed for | If missing |
|---|---|---|
| `git` | `vim.pack` (all plugins) | `init.lua` aborts, so no plugins, colorscheme or keymaps |
| `tree-sitter` CLI **>= 0.26.1** | building treesitter parsers | every parser fails with `ENOENT ... 'tree-sitter'` |
| C compiler (`cc`/`gcc`) | building treesitter parsers | parser builds fail |
| `node` + `npm` | ts_ls, pyright, cssls, html, jsonls, eslint, tailwindcss, prettier | those 8 Mason packages fail |
| `python3` (with `venv`) | black, isort | those Mason packages fail |
| `unzip` | stylua | stylua fails |
| `curl` or `wget` | Mason downloads | Mason can't fetch anything |

### macOS

```sh
xcode-select --install   # git, cc, python3, unzip, curl
brew install neovim tree-sitter-cli
# Node: any install works (Homebrew, nvm, ...), as long as it's on PATH when nvim starts
brew install node        # or: nvm install --lts
```

### Ubuntu / Debian

```sh
sudo apt install git gcc libc6-dev unzip curl nodejs npm python3 python3-venv
```

- **Neovim:** apt's version is too old. Use the
  [release tarball](https://github.com/neovim/neovim/releases/tag/v0.12.6) instead.
- **tree-sitter CLI:** apt's `tree-sitter-cli` is 0.20.x, which is too old. Use the
  [release binary](https://github.com/tree-sitter/tree-sitter/releases) instead.
  The nvim-treesitter docs also advise against the npm package.

```sh
curl -fsSL https://github.com/tree-sitter/tree-sitter/releases/download/v0.26.1/tree-sitter-linux-x64.gz \
  | gunzip > ~/.local/bin/tree-sitter && chmod +x ~/.local/bin/tree-sitter   # use linux-arm64 on ARM
```

## Install

1. Put this directory at `~/.config/nvim`.
2. Start `nvim`. `vim.pack` lists all 12 plugins and asks you to confirm once.
   Because `nvim-pack-lock.json` is committed, they're installed in one batch at
   the pinned commits.
3. Wait for the background installs to finish. They don't block the editor:
   - Treesitter downloads and compiles 16 parsers (watch `:messages`).
   - Mason installs 7 language servers and 4 formatters (watch `:Mason`).
     The first run takes a minute or two, depending on your connection.
4. Restart Neovim. Servers only attach to buffers opened after their install
   finished.

### Verify

```vim
:checkhealth vim.pack      " plugins installed and match the lockfile
:checkhealth vim.lsp       " enabled servers and whether their binaries exist
:Mason                     " all 11 packages show as installed
:checkhealth nvim-treesitter
```

## Troubleshooting

Hiccups found while setting this up in a clean Ubuntu 24.04 container and a
clean macOS profile:

- **"No `git` executable" on startup.** Install git. The error aborts all of
  `init.lua`, so the editor starts completely unconfigured.
- **Parsers fail with `ENOENT ... 'tree-sitter'`.** Install the tree-sitter CLI
  (0.26.1 or newer), then run `:TSUpdate` or restart.
- **"mason: failed to install …" warnings.** The message names the missing
  tool, almost always `npm`. Mason itself only logs failures to `:MasonLog`, so
  the config adds these warnings. Install the tool and restart: missing packages
  are retried automatically on every launch, with no cleanup needed.
- **Node from nvm or another version manager isn't found.** Neovim inherits
  `PATH` from the shell that launched it. If you start nvim from a GUI or launcher
  that doesn't load your shell profile, Node won't be on `PATH`. Launch from a
  terminal, or install a system Node (`brew install node`).
- **tailwindcss doesn't attach.** That's expected outside a project. It needs a
  tailwind config, `package.json`, or `.git` root. In a bare folder, the html
  server also logs a harmless `"/<default workspace root>" does not exist` error.
- **eslint doesn't attach.** It only starts in projects with an ESLint config.
- **Ubuntu's Node 18** is old but works. Every server installed and attached in
  testing.

## Layout

```
init.lua               leader keys, then settings -> maps -> pack
lua/config/settings.lua  editor options
lua/config/maps.lua      general keymaps
lua/config/pack.lua      PackChanged build hooks + plugin load order
lua/plugins/*.lua        one file per plugin: vim.pack.add() then setup
nvim-pack-lock.json      pinned plugin revisions (commit this)
```

## Plugins

| Plugin | Purpose |
|---|---|
| catppuccin | colorscheme |
| nvim-treesitter (+ nvim-ts-autotag) | parsers, highlighting, indent, auto-close tags |
| mason.nvim + nvim-lspconfig | install servers/formatters; server configs for `vim.lsp.enable` |
| conform.nvim | format on save, `<leader>f` |
| gitsigns.nvim | git signs in the sign column |
| telescope.nvim (+ plenary) | fuzzy finding |
| harpoon (harpoon2) | file bookmarks |
| nvim-autopairs | auto-close brackets/quotes |
| nvim-colorizer.lua (catgoose) | inline color previews |

## Managing plugins

```vim
:lua vim.pack.update()                 " review and apply updates (updates the lockfile)
:lua vim.pack.update(nil, { target = 'lockfile' })   " sync disk to the committed lockfile
```

- **Add a plugin:** create `lua/plugins/<name>.lua` with `vim.pack.add({ "https://github.com/..." })`
  plus its setup, and add `<name>` to the list in `lua/config/pack.lua`.
- **Remove a plugin:** delete its file and its entry in the list, then
  `:lua vim.pack.del({ "<plugin-dir-name>" })`.
- **Change a plugin's source or branch:** edit its `src`/`version`, then run
  `:lua vim.pack.update({ "<name>" })`. Editing the spec alone doesn't
  re-clone it.
- **Add a language server:** add the Mason package name to `ensure_installed` and
  the lspconfig server name to `vim.lsp.enable` in `lua/plugins/lsp.lua`. The
  two names often differ (e.g. `css-lsp` vs `cssls`).

## Keymaps

Leader is `<Space>`. Run `:map` (or `:nmap <leader>`) to list them with descriptions.

| Keys | Action |
|---|---|
| `<leader>w` / `<leader>q` | save / quit |
| `jk` (insert) | escape |
| `<leader>e` / `<leader>r` | netrw sidebar / netrw in current window |
| `<C-r>` (in netrw) | refresh listing (netrw's own `<C-l>` is remapped to move right) |
| `<leader>\|` / `<leader>-` | split right / split below |
| `<C-h/j/k/l>` | move between windows |
| `<M-arrows>` | resize windows by 2 (left Option in WezTerm; `<C-arrows>` belong to macOS Spaces) |
| `<leader>ff` `fg` `fb` | telescope: files, grep, buffers |
| `<leader>gs` / `<leader>gc` | telescope: git status / git commits |
| `<leader>a` / `<leader>h` | harpoon: add file / menu |
| `<leader>1`–`<leader>4` | harpoon: jump to file 1–4 |
| `<leader>cf` | format file/selection |
| `<C-Space>` / `<BS>` | expand / shrink treesitter selection |

LSP keymaps are Neovim 0.12's built-in defaults:

| Keys | Action |
|---|---|
| `K` | hover documentation |
| `grn` / `gra` | rename / code action |
| `grr` / `gri` / `grt` | references / implementation / type definition |
| `gO` | document symbols |
| `<C-]>` | go to definition |
| `[d` / `]d` / `<C-w>d` | previous / next / show diagnostic |
| `<C-s>` (insert) | signature help |
