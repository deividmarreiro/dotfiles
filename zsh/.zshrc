# ===================================================================
# .zshrc - Managed by GNU Stow
# ===================================================================

# 1. History Configuration
HISTSIZE=5000
SAVEHIST=5000
HISTFILE=~/.zsh_history
setopt histignorealldups sharehistory

# 2. Keybindings
bindkey -e

# 3. Load Oh My Zsh (Core functions and framework)
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="" # Left blank because we are using Starship
plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-completions)
source $ZSH/oh-my-zsh.sh

# 4. Advanced Completion System (Customized from old config)
# Note: Oh My Zsh already runs compinit, so we just add the styling
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# 5. Tool Manager & Prompt
eval "$(mise activate zsh)"
eval "$(starship init zsh)"

# 6. Environment Variables (API Keys for CLI AI Agents)
export ANTHROPIC_API_KEY="your-anthropic-key-here"
export GEMINI_API_KEY="your-gemini-key-here"

# 7. Custom Aliases
alias c="cursor ."
alias ll="eza -lh --icons"
alias lg="lazygit"
alias ld="lazydocker"