#!/bin/bash

# ==========================================
# Universal Dotfiles Setup - Final Version
# ==========================================

FMT_RED=$(printf '\033[38;2;243;139;168m')
FMT_GREEN=$(printf '\033[38;2;166;227;161m')
FMT_BLUE=$(printf '\033[38;2;137;180;250m')
FMT_BOLD=$(printf '\033[1m')
FMT_RESET=$(printf '\033[0m')

command_exists() { command -v "$@" >/dev/null 2>&1; }
fmt_info() { printf '\n%s\n' "${FMT_BOLD}${FMT_BLUE}[*] $*${FMT_RESET}"; }
fmt_success() { printf '%s\n' "${FMT_BOLD}${FMT_GREEN}[+] $*${FMT_RESET}"; }
fmt_error() { printf '%s\n' "${FMT_BOLD}${FMT_RED}[-] Error: $*${FMT_RESET}" >&2; exit 1; }

fmt_info "Detecting Operating System..."
if [ -f /etc/os-release ]; then
  . /etc/os-release
  DISTRO=$ID
else
  fmt_error "Cannot determine OS. /etc/os-release not found."
fi
fmt_success "OS detected: $DISTRO"

install_base_packages() {
  fmt_info "Checking base packages..."
  local PACKAGES="curl git stow unzip fzf tmux zsh"

  if [[ "$DISTRO" == "ubuntu" || "$DISTRO" == "debian" ]]; then
    sudo apt-get update -y --quiet
    sudo apt-get install -y $PACKAGES build-essential
    fmt_success "Ubuntu base packages verified."
  elif [[ "$DISTRO" == "arch" ]]; then
    sudo pacman -Syu --noconfirm
    sudo pacman -S --needed --noconfirm $PACKAGES base-devel
    fmt_success "Arch base packages verified."
  else
    fmt_error "Unsupported distribution: $DISTRO"
  fi
}

setup_zsh_environment() {
  fmt_info "Configuring Zsh Environment..."
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fmt_success "Oh My Zsh installed."
  else
    fmt_success "Oh My Zsh is already installed. Skipping."
  fi

  ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
  fmt_info "Checking Zsh Plugins..."
  [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions" && fmt_success "zsh-autosuggestions installed." || fmt_success "zsh-autosuggestions already installed. Skipping."
  [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" && fmt_success "zsh-syntax-highlighting installed." || fmt_success "zsh-syntax-highlighting already installed. Skipping."
  [ ! -d "$ZSH_CUSTOM/plugins/zsh-completions" ] && git clone https://github.com/zsh-users/zsh-completions "$ZSH_CUSTOM/plugins/zsh-completions" && fmt_success "zsh-completions installed." || fmt_success "zsh-completions already installed. Skipping."
}

setup_dev_tools() {
  fmt_info "Setting up Dev Tools via Mise..."
  
  export PATH="$HOME/.local/bin:$PATH"

  if ! command_exists mise; then
    fmt_info "Installing Mise..."
    curl https://mise.run | sh
    fmt_success "Mise installed."
  else
    fmt_success "Mise is already installed. Skipping."
  fi

  fmt_info "Installing runtimes (Node, Python, Java) and CLI tools..."
  mise use --global node@20
  mise use --global python@3.12
  mise use --global java@21
  mise use --global poetry      # Poetry is now handled natively by Mise
  mise use --global eza
  mise use --global lazygit
  mise use --global lazydocker
  mise use --global neovim
  fmt_success "Universal dev environment tools installed."
}

setup_ai_tools() {
  fmt_info "Installing AI CLI tools..."
  
  eval "$(mise activate bash)"

  # Install Claude Code via NPM
  if ! command_exists claude; then
    npm install -g @anthropic-ai/claude-code
    fmt_success "Claude Code installed."
  else
    fmt_success "Claude Code already installed. Skipping."
  fi
}

setup_starship() {
  fmt_info "Setting up Starship Prompt..."

  if ! command_exists starship; then
    curl -sS https://starship.rs/install.sh | sh -s -- -y
    fmt_success "Starship installed."
  else
    fmt_success "Starship already installed. Skipping."
  fi
}

setup_dotfiles_and_shell() {
  fmt_info "Applying Dotfiles with Stow..."
  
  # Remove default created .zshrc so Stow doesn't fail with conflicts
  if [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
    rm "$HOME/.zshrc"
    fmt_success "Default .zshrc removed for Stow."
  fi

  # Stow the dotfiles (assuming the script is run from the dotfiles directory)
  stow -t "$HOME" zsh starship
  fmt_success "Dotfiles linked."

  # Change default shell
  if [ "$(basename -- "$SHELL")" != "zsh" ]; then
    fmt_info "Changing default shell to Zsh..."
    sudo chsh -s "$(which zsh)" "$USER"
    fmt_success "Shell changed to Zsh."
  else
    fmt_success "Zsh is already the default shell."
  fi
}

# --- Execution ---
install_base_packages
setup_zsh_environment
setup_dev_tools
setup_ai_tools
setup_starship
setup_dotfiles_and_shell

fmt_info "Setup complete! Restarting terminal..."
exec zsh -l