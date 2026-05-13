# ─────────────────────────────────────────
#  Oh My Zsh
# ─────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"

# Sin tema propio — Starship se encarga del prompt
ZSH_THEME=""

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# ─────────────────────────────────────────
#  Historial
# ─────────────────────────────────────────
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

# ─────────────────────────────────────────
#  Prompt — Starship
# ─────────────────────────────────────────
eval "$(starship init zsh)"

# ─────────────────────────────────────────
#  Navegación inteligente — zoxide
# ─────────────────────────────────────────
eval "$(zoxide init zsh)"

# ─────────────────────────────────────────
#  Historial avanzado — Atuin
# ─────────────────────────────────────────
eval "$(atuin init zsh)"

# ─────────────────────────────────────────
#  Búsqueda fuzzy — fzf
# ─────────────────────────────────────────
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

# ─────────────────────────────────────────
#  Aliases
# ─────────────────────────────────────────
alias ls="eza --icons"
alias ll="eza -la --icons --git"
alias la="eza -a --icons"
alias lt="eza --tree --icons"
alias cat="bat"
alias grep="rg"
alias cd="z"         # zoxide reemplaza cd
alias ..="cd .."
alias ...="cd ../.."

# ─────────────────────────────────────────
#  Editor
# ─────────────────────────────────────────
export EDITOR="nvim"
export VISUAL="nvim"
export PATH="$HOME/.local/bin:$PATH"
