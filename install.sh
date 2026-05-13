#!/usr/bin/env bash
set -euo pipefail

# ─────────────────────────────────────────
#  Colores
# ─────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

info()   { echo -e "${CYAN}  →${RESET} $*"; }
ok()     { echo -e "${GREEN}  ✓${RESET} $*"; }
warn()   { echo -e "${YELLOW}  !${RESET} $*"; }
error()  { echo -e "${RED}  ✗${RESET} $*"; }
header() { echo -e "\n${BOLD}$*${RESET}"; }

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ERRORS=0

# ─────────────────────────────────────────
#  1. Dependencias (pacman)
# ─────────────────────────────────────────
header "── Comprobando dependencias ──────────────────────"

DEPS=(ghostty zsh starship eza zoxide fzf bat ripgrep numlockx)
MISSING=()

for dep in "${DEPS[@]}"; do
    if command -v "$dep" &>/dev/null; then
        ok "$dep"
    else
        warn "$dep  →  no encontrado"
        MISSING+=("$dep")
    fi
done

if [[ ${#MISSING[@]} -gt 0 ]]; then
    echo
    error "Faltan paquetes. Instálalos con:"
    echo -e "    ${BOLD}sudo pacman -S ${MISSING[*]}${RESET}"
    ERRORS=1
fi

# ─────────────────────────────────────────
#  2. Atuin (puede venir de pacman o cargo)
# ─────────────────────────────────────────
header "── Comprobando atuin ────────────────────────────"

if command -v atuin &>/dev/null; then
    ok "atuin"
else
    warn "atuin  →  no encontrado"
    echo
    echo -e "  Instala atuin con ${BOLD}pacman${RESET} (recomendado en CachyOS):"
    echo -e "      ${BOLD}sudo pacman -S atuin${RESET}"
    echo
    echo -e "  O bien con ${BOLD}cargo${RESET} si prefieres la última versión:"
    echo -e "      ${BOLD}cargo install atuin${RESET}"
    ERRORS=1
fi

# ─────────────────────────────────────────
#  3. Fuente JetBrains Nerd Font
# ─────────────────────────────────────────
header "── Comprobando fuente JetBrains Nerd Font ────────"

if fc-list | grep -qi "JetBrains"; then
    ok "JetBrainsMono Nerd Font  →  encontrada"
else
    warn "JetBrainsMono Nerd Font  →  no instalada"
    echo
    echo -e "  Instálala con pacman:"
    echo -e "      ${BOLD}sudo pacman -S ttf-jetbrains-mono-nerd${RESET}"
    echo
    echo -e "  O descárgala desde: https://www.nerdfonts.com/font-downloads"
    echo -e "  y copia los .ttf a ~/.local/share/fonts/ && fc-cache -fv"
    ERRORS=1
fi

# ─────────────────────────────────────────
#  4. Oh My Zsh
# ─────────────────────────────────────────
header "── Comprobando Oh My Zsh ────────────────────────"

if [[ -d "$HOME/.oh-my-zsh" ]]; then
    ok "oh-my-zsh"
else
    error "~/.oh-my-zsh no existe. Instala Oh My Zsh primero:"
    echo
    echo -e '      sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'
    echo
    exit 1
fi

# Salir si hay dependencias faltantes (excepto OMZ que ya salió arriba)
if [[ $ERRORS -ne 0 ]]; then
    echo
    error "Corrige las dependencias anteriores y vuelve a ejecutar install.sh"
    exit 1
fi

# ─────────────────────────────────────────
#  5. Plugins de Oh My Zsh (via pacman + symlink)
# ─────────────────────────────────────────
header "── Plugins de Oh My Zsh ──────────────────────────"

OMZ_PLUGINS="$HOME/.oh-my-zsh/custom/plugins"
ZSH_PLUGIN_PKGS=(zsh-autosuggestions zsh-syntax-highlighting)
MISSING_PLUGINS=()

for pkg in "${ZSH_PLUGIN_PKGS[@]}"; do
    if pacman -Q "$pkg" &>/dev/null; then
        ok "$pkg  →  instalado"
    else
        warn "$pkg  →  no instalado"
        MISSING_PLUGINS+=("$pkg")
    fi
done

if [[ ${#MISSING_PLUGINS[@]} -gt 0 ]]; then
    echo
    error "Faltan plugins zsh. Instálalos con:"
    echo -e "    ${BOLD}sudo pacman -S ${MISSING_PLUGINS[*]}${RESET}"
    exit 1
fi

link_plugin() {
    local name="$1"
    local src="/usr/share/zsh/plugins/$name"
    local dest="$OMZ_PLUGINS/$name"
    if [[ -L "$dest" ]]; then
        ok "$name  →  symlink ya existe"
    else
        ln -sf "$src" "$dest"
        ok "$name  →  symlink creado"
    fi
}

link_plugin "zsh-autosuggestions"
link_plugin "zsh-syntax-highlighting"

# ─────────────────────────────────────────
#  6. Backup de configs existentes
# ─────────────────────────────────────────
header "── Backup de configuraciones existentes ──────────"

backup_file() {
    local target="$1"
    if [[ -L "$target" ]]; then
        rm "$target"
        info "Eliminado symlink previo: $target"
    elif [[ -e "$target" ]]; then
        mv "$target" "${target}.bak"
        warn "Backup: $target → ${target}.bak"
    fi
}

backup_file "$HOME/.config/ghostty/config"
backup_file "$HOME/.zshrc"
backup_file "$HOME/.config/starship.toml"

# ─────────────────────────────────────────
#  7. Instalar configuraciones
# ─────────────────────────────────────────
header "── Copiando archivos de configuración ───────────"

install_file() {
    local src="$1"
    local dest="$2"
    mkdir -p "$(dirname "$dest")"
    cp "$src" "$dest"
    ok "$(basename "$src")  →  $dest"
}

install_file "$DOTFILES_DIR/ghostty/config"      "$HOME/.config/ghostty/config"
install_file "$DOTFILES_DIR/zsh/.zshrc"          "$HOME/.zshrc"
install_file "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"

# ─────────────────────────────────────────
#  8. Terminal por defecto en KDE (Ghostty)
# ─────────────────────────────────────────
header "── Terminal por defecto en KDE ──────────────────"

if command -v kwriteconfig6 &>/dev/null; then
    kwriteconfig6 --file kdeglobals --group General --key TerminalApplication ghostty
    kwriteconfig6 --file kdeglobals --group General --key TerminalService ghostty.desktop
    ok "Terminal KDE  →  ghostty"
    info "Reinicia la sesión o ejecuta: qdbus6 org.kde.KWin /KWin reconfigure"
else
    warn "kwriteconfig6 no encontrado — configura la terminal por defecto manualmente:"
    echo "  Ajustes del sistema → Aplicaciones → Aplicaciones predeterminadas → Terminal"
fi

# ─────────────────────────────────────────
#  Fin
# ─────────────────────────────────────────
echo
echo -e "${GREEN}${BOLD}  Instalación completada.${RESET}"
echo -e "   Abre una nueva terminal o ejecuta ${BOLD}source ~/.zshrc${RESET} para aplicar los cambios."
echo
