# 🏠 Dotfiles

My personal configuration files, managed with [GNU Stow](https://www.gnu.org/software/stow/) and an automated setup script.

## 📦 What's Included

### System Tools

| Tool | Description |
|---|---|
| [Zsh](https://www.zsh.org/) | Default shell |
| [Oh My Zsh](https://ohmyz.sh/) | Zsh framework |
| [Starship](https://starship.rs/) | Customizable prompt |
| [fzf](https://github.com/junegunn/fzf) | Fuzzy finder |
| [tmux](https://github.com/tmux/tmux) | Terminal multiplexer |

### Zsh Plugins

- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) — History-based suggestions
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) — Syntax highlighting in the terminal
- [zsh-completions](https://github.com/zsh-users/zsh-completions) — Additional completions

### Dev Tools (via [Mise](https://mise.jdx.dev/))

| Runtime / Tool | Version |
|---|---|
| Node.js | 20 |
| Python | 3.12 |
| Java | 21 |
| Poetry | latest |
| eza | latest |
| lazygit | latest |
| lazydocker | latest |
| neovim | latest |

### AI Tools

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) — Anthropic's coding agent

### Prompt

- **Starship** with the [Catppuccin Powerline](https://starship.rs/presets/catppuccin-powerline) preset (flavor **Mocha**)

> [!TIP]
> To use a different Starship preset, edit `starship/.config/starship.toml` or replace it with your preferred preset:
> ```bash
> starship preset <preset-name> -o ~/.config/starship.toml
> ```
> See all available presets at [starship.rs/presets](https://starship.rs/presets/).
>
> To switch between Catppuccin flavors (Mocha, Frappé, Latte, Macchiato), change the `palette` line in `starship.toml`:
> ```toml
> palette = 'catppuccin_frappe'
> ```

## 📂 Structure

```
dotfiles/
├── setup.sh                          # Automated setup script
├── zsh/
│   └── .zshrc                        # Zsh configuration
└── starship/
    └── .config/
        └── starship.toml             # Starship configuration
```

Each root directory is a **Stow package**. Running `stow -t $HOME */` creates automatic symlinks:

- `zsh/.zshrc` → `~/.zshrc`
- `starship/.config/starship.toml` → `~/.config/starship.toml`

## 🚀 Installation

### Prerequisites

- Ubuntu/Debian or Arch Linux
- A [Nerd Font](https://www.nerdfonts.com/) installed in your terminal (e.g. JetBrainsMono Nerd Font)

### Setup

```bash
git clone https://github.com/deividmarreiro/dotfiles.git ~/git/dotfiles
cd ~/git/dotfiles
chmod +x setup.sh
./setup.sh
```

The script automatically runs the following steps:

1. **Base packages** — `curl`, `git`, `stow`, `unzip`, `fzf`, `tmux`, `zsh`
2. **Zsh** — Oh My Zsh + plugins
3. **Dev tools** — Mise + runtimes and CLIs
4. **AI tools** — Claude Code
5. **Starship** — Prompt installation
6. **Dotfiles** — Symlinks via Stow + sets Zsh as default shell

## ⚙️ Aliases

| Alias | Command |
|---|---|
| `c` | `cursor .` |
| `ll` | `eza -lh --icons` |
| `lg` | `lazygit` |
| `ld` | `lazydocker` |

## 📝 Notes

- The script is **idempotent** — it can be safely run multiple times.
- Supported distributions: **Ubuntu/Debian** and **Arch Linux**.
