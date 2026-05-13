# ─────────────────────────────────────────
#  Oh My Zsh
# ─────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"

# Sin tema propio — Starship se encarga del prompt
ZSH_THEME=""

plugins=(git)

source $ZSH/oh-my-zsh.sh

# ─────────────────────────────────────────
#  Plugins (instalados via pacman)
# ─────────────────────────────────────────
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

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
alias cd="z"
alias ..="cd .."
alias ...="cd ../.."

# ─────────────────────────────────────────
#  Editor
# ─────────────────────────────────────────
export EDITOR="nano"
export VISUAL="nano"
export PATH="$HOME/.local/bin:$PATH"

numlockx on
