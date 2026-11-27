# Neovim config

A Neovim config built with [lazy.nvim](https://github.com/folke/lazy.nvim). It includes:

- **Language servers:** the built-in LSP, with servers installed by Mason
- **Completion:** blink.cmp
- **Highlighting:** tree-sitter
- **Finding files and text:** Telescope
- **Files:** oil.nvim and neo-tree
- **Git:** Neogit and gitsigns
- **Debugging:** nvim-dap, for Python and Node
- **Theme:** tokyonight (night), recolored to the CachyOS `cachyos-nord` palette

## Requirements

| Tool | Why |
|---|---|
| **Neovim 0.12+** | Required by nvim-treesitter (`main` branch) and `vim.lsp.config` |
| git, curl, tar | Plugin and parser downloads |
| ripgrep, fd | Telescope grep / file search |
| A C compiler | Building tree-sitter parsers and telescope-fzf-native |
| **tree-sitter CLI 0.26.1+** | Building tree-sitter parsers. Install it with a package manager or the release binary, **not npm** |
| make (macOS/Linux) or **cmake** (Windows) | Building telescope-fzf-native (fast fuzzy sorting) |
| Node.js | TypeScript language server, JS debugger |
| Python 3 | pyright, debugpy |
| A [Nerd Font](https://www.nerdfonts.com/) | Icons. Set it as your terminal font |

The optional tools aren't required for startup. Without the tree-sitter CLI, Neovim uses its bundled parsers. Without make or cmake, Telescope uses its slower built-in sorter.

## Languages

Every language below gets:

- **Highlighting** from tree-sitter
- **Language-server features** from Mason (completion, go-to-definition, diagnostics, rename)
- **Formatting** from conform.nvim, which formats on save. Toggle that with `<leader>uf`.

Everything is listed in `lua/config/languages.lua`.

Mason installs the servers and tools itself. Some of them need the language's toolchain on your `PATH`. **If a toolchain is missing, those servers and tools are skipped** at startup, so Neovim still starts cleanly. Install the toolchain and restart Neovim, and Mason picks them up.

| Language | Server | Formatter | Debugger | Toolchain you install |
|---|---|---|---|---|
| C / C++ | clangd | clang-format | codelldb | C compiler (Xcode CLT / gcc / clang / MSVC) |
| Python | pyright, ruff | ruff | debugpy | Python 3 |
| Go | gopls | goimports, gofmt | delve | Go |
| C# | omnisharp | csharpier | netcoredbg | .NET SDK |
| TypeScript / JavaScript / React | vtsls, eslint | prettier | js-debug | Node.js |
| Svelte | svelte | prettier (+ `prettier-plugin-svelte` in the project) | | Node.js |
| Angular | angularls, html | prettier | js-debug | Node.js, project with `angular.json` |
| Vue | vue_ls + vtsls plugin | prettier | js-debug | Node.js |
| PHP | intelephense | LSP | | Node.js (PHP for running code) |
| Ruby | ruby-lsp | LSP (rubocop if in the bundle) | | Ruby 3+ and `gem` (not macOS's built-in `/usr/bin/ruby`) |
| Java | jdtls | LSP | | JDK 21+ |
| Rust | rust-analyzer | LSP (rustfmt) | codelldb | rustup, then `rustup component add rust-analyzer rustfmt` |
| YAML | yamlls + SchemaStore | prettier | | Node.js |
| JSON | jsonls + SchemaStore | prettier | | Node.js |
| Terraform | terraformls, tflint | terraform fmt | | Terraform CLI |
| HTML / CSS | html, cssls | prettier | | Node.js |

Notes:

- **Filetypes:** `*.tf` files are set to `terraform`; Neovim's default for that extension is TinyFugue. `*.component.html` files are set to `htmlangular`.
- **Formatters:** formatters installed in the project (such as `node_modules/.bin/prettier`) are used before Mason's copies, so your project's own settings apply.
- **Status:** run `:Mason` to see what's installed, `:LspInfo` (or `:checkhealth vim.lsp`) for running servers, and `:ConformInfo` for formatters.

### Toolchains

| | macOS | Debian / Ubuntu | Windows |
|---|---|---|---|
| Go | `brew install go` | `sudo apt install golang` (or go.dev/dl) | `winget install GoLang.Go` |
| .NET SDK | `brew install --cask dotnet-sdk` | [Microsoft packages](https://learn.microsoft.com/dotnet/core/install/linux) | `winget install Microsoft.DotNet.SDK.8` |
| Java (JDK 21+) | `brew install openjdk` | `sudo apt install openjdk-21-jdk` | `winget install EclipseAdoptium.Temurin.21.JDK` |
| Rust | `brew install rustup && rustup-init` | `curl https://sh.rustup.rs -sSf \| sh` | `winget install Rustlang.Rustup` |
| Ruby | `brew install ruby` | `sudo apt install ruby-full` | `winget install RubyInstallerTeam.RubyWithDevKit.3.3` |
| PHP | `brew install php` | `sudo apt install php-cli` | `winget install PHP.PHP.8.3` |
| Terraform | `brew tap hashicorp/tap && brew install hashicorp/tap/terraform` | [HashiCorp apt repo](https://developer.hashicorp.com/terraform/install) | `winget install Hashicorp.Terraform` |

Mason also needs `unzip` and `gzip` on macOS and Linux. Most systems already have them; on Debian/Ubuntu, `sudo apt install unzip`. On Windows, it uses the `tar` that ships with Windows.

## macOS

```sh
xcode-select --install                     # C compiler + make
brew install neovim git ripgrep fd node python cmake tree-sitter-cli
brew install --cask font-fira-code-nerd-font

git clone <this-repo> ~/.config/nvim
nvim
```

## Linux

Distro packages of Neovim are often too old. Check `nvim --version` (it must be 0.12 or newer). If it's older, use the [official release](https://github.com/neovim/neovim/releases/latest):

```sh
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz   # or nvim-linux-arm64
sudo rm -rf /opt/nvim && sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
sudo mv /opt/nvim-linux-x86_64 /opt/nvim
echo 'export PATH="/opt/nvim/bin:$PATH"' >> ~/.bashrc   # or ~/.zshrc
```

Then install the other tools.

**Debian / Ubuntu**

```sh
sudo apt install git curl tar ripgrep fd-find build-essential cmake nodejs npm python3 python3-venv xclip
# fd is installed as `fdfind`. Link it so Telescope finds it:
mkdir -p ~/.local/bin && ln -s "$(which fdfind)" ~/.local/bin/fd
```

**Fedora**

```sh
sudo dnf install git curl tar ripgrep fd-find gcc make cmake nodejs python3 xclip
```

**Arch**

```sh
sudo pacman -S neovim git curl tar ripgrep fd base-devel cmake nodejs npm python tree-sitter-cli xclip
```

**tree-sitter CLI (Debian, Ubuntu, Fedora).** Arch already installed it above. On other distros, the package is often missing or too old, so use the release binary:

```sh
curl -LO https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-x64.gz  # or -arm64
gunzip tree-sitter-linux-x64.gz
chmod +x tree-sitter-linux-x64
mkdir -p ~/.local/bin && mv tree-sitter-linux-x64 ~/.local/bin/tree-sitter
tree-sitter --version   # 0.26.1 or newer
```

If you have Rust installed, `cargo install --locked tree-sitter-cli` also works.

**Clipboard.** Use `xclip` on X11. On Wayland, install `wl-clipboard` instead.

**Font.** Download FiraCode from <https://www.nerdfonts.com/font-downloads>, unzip it into `~/.local/share/fonts`, and run `fc-cache -f`.

Then install the config:

```sh
git clone <this-repo> ~/.config/nvim
nvim
```

## Windows

Run this in PowerShell:

```powershell
winget install Neovim.Neovim Git.Git BurntSushi.ripgrep.MSVC sharkdp.fd OpenJS.NodeJS.LTS Python.Python.3.12 Kitware.CMake
winget install Microsoft.PowerShell      # optional: pwsh is used instead of Windows PowerShell when present
```

**C compiler.** Pick one of these:

```powershell
winget install zig.zig        # small, works for tree-sitter parsers
# or
winget install LLVM.LLVM      # clang
# or: Visual Studio Build Tools with the "Desktop development with C++" workload
#     (then launch nvim from the "Developer PowerShell" so cl.exe is on PATH)
```

**tree-sitter CLI.** Download `tree-sitter-windows-x64.gz` from
<https://github.com/tree-sitter/tree-sitter/releases/latest>. Extract it, rename the file to `tree-sitter.exe`, and put it in a folder on your `PATH`. Or, with [Scoop](https://scoop.sh):

```powershell
scoop install tree-sitter
tree-sitter --version   # 0.26.1 or newer
```

**Font.** Run `scoop bucket add nerd-fonts; scoop install FiraCode-NF`, or download FiraCode from nerdfonts.com and install it. Then select it in Windows Terminal: Settings → Profile → Appearance → Font face.

**Config.** The config goes in `%LOCALAPPDATA%\nvim`:

```powershell
git clone <this-repo> $env:LOCALAPPDATA\nvim
nvim
```

Open a new terminal after installing, so your `PATH` picks up the new tools.

## First launch

1. lazy.nvim installs itself and every plugin.
2. Mason installs the language servers, formatters and debug adapters for every toolchain it finds. This takes a few minutes the first time. Run `:Mason` to watch the progress.
3. If the tree-sitter CLI is present, the language parsers are compiled. To watch or re-run this, use `:TSUpdate`.

Restart Neovim once everything is done. To check the setup:

```vim
:checkhealth           " everything
:checkhealth nvim-treesitter
:checkhealth telescope
:Lazy                  " plugin status / updates
```

Python virtualenvs: activate the venv in your shell before launching `nvim`, and pyright and debugpy will use it.

## Keymaps

Leader is `Space`. Press it and wait to see every binding in which-key.

| Keys | Action |
|---|---|
| `<leader><space>` / `<leader>ff` | Find files |
| `<leader>fg` / `<leader>fw` | Grep / grep word under cursor |
| `<leader>fb` / `<leader>fr` | Buffers / recent files |
| `<leader>fh` / `<leader>fk` | Help / keymaps |
| `<leader>f/` | Search current buffer |
| `<leader>ft` | Pick theme |
| `<leader>fc` | Edit config |
| `<leader>pp` / `pf` / `pg` | Switch project (under `~/Projects/Code`) / find / grep in project |
| `-` | Open parent directory (oil) |
| `<leader>e` | File tree (neo-tree) |
| `<C-h/j/k/l>` | Move between windows |
| `<S-h>` / `<S-l>` / `<leader>bd` | Previous / next / delete buffer |
| `<C-\>` | Toggle terminal (`<Esc><Esc>` leaves terminal mode) |
| `gc` / `gcc` | Comment (built in) |
| **LSP** | |
| `K` | Hover |
| `gd` | Definition |
| `grr` / `gri` / `grt` | References / implementation / type definition (built in) |
| `grn` / `gra` | Rename / code action (built in) |
| `gO` | Document symbols (built in) |
| `<leader>cf` / `<leader>uf` | Format buffer or selection / toggle format on save |
| `<leader>cs` / `cS` | Document symbols / workspace symbols |
| `<leader>cd` / `[d` / `]d` | Line diagnostics / previous / next |
| `<leader>ch` | Toggle inlay hints |
| **Completion** | `<C-space>` open, `<C-n>`/`<C-p>` select, `<C-y>` accept, `<C-e>` close |
| **Git** | |
| `<leader>gg` / `<leader>gd` | Neogit / Diffview |
| `]h` / `[h` | Next / previous hunk |
| `<leader>gp` / `gr` / `gb` | Preview / reset hunk / blame line |
| **Debug** | |
| `<F5>` / `<F10>` / `<F11>` / `<F12>` | Continue / step over / into / out |
| `<leader>db` / `dc` / `dr` / `dq` / `du` | Breakpoint / continue / restart / terminate / toggle UI |

## Layout

```
init.lua               leader, OS detection, projects dir
lua/config/languages.lua   servers, tools and parsers for every language (edit this to add one)
lua/config/            options, keymaps, autocmds, lazy bootstrap
lua/plugins/           one file per area (ui, telescope, lsp, format, dap, git, files, terminal)
```

To change where the project picker looks, edit `vim.g.projects_dir` in `init.lua`.
