fastfetch

# ─────────────────────────────────────────
#  Autocompletado
# ─────────────────────────────────────────
autoload -U compinit && compinit

# ─────────────────────────────────────────
#  Plugins
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
alias e="edit"
alias nano="edit"
alias micro="edit"
alias vi="edit"

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
export EDITOR="edit"
export VISUAL="edit"
export PATH="$HOME/.local/bin:$PATH"

numlockx on
