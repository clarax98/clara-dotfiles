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

# ─────────────────────────────────────────
#  1. Paquetes pacman
# ─────────────────────────────────────────
header "── Instalando paquetes ───────────────────────────"

PKGS=(
    # terminal y shell
    ghostty
    zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
    atuin
    # prompt y CLI
    starship
    eza
    zoxide
    fzf
    bat
    ripgrep
    fastfetch
    # utilidades
    numlockx
    git
    curl
    wget
    htop
    btop
    xdotool
    # fuentes
    ttf-jetbrains-mono-nerd
    noto-fonts
    noto-fonts-emoji
)

MISSING=()
for pkg in "${PKGS[@]}"; do
    if pacman -Q "$pkg" &>/dev/null; then
        ok "$pkg"
    else
        warn "$pkg  →  pendiente"
        MISSING+=("$pkg")
    fi
done

if [[ ${#MISSING[@]} -gt 0 ]]; then
    info "Instalando ${#MISSING[@]} paquetes con pacman..."
    sudo pacman -S --needed --noconfirm "${MISSING[@]}"
    ok "Paquetes instalados"
fi

# ─────────────────────────────────────────
#  2. Temas de iconos y cursores
# ─────────────────────────────────────────
header "── Temas: candy-icons y Sweet-cursors ───────────"

ICONS_DIR="$HOME/.local/share/icons"
CURSORS_DIR="$HOME/.icons"
mkdir -p "$ICONS_DIR" "$CURSORS_DIR"

if [[ -d "$ICONS_DIR/candy-icons" ]]; then
    ok "candy-icons  →  ya instalado"
else
    info "Clonando candy-icons..."
    git clone --depth=1 https://github.com/EliverLara/candy-icons.git "$ICONS_DIR/candy-icons"
    ok "candy-icons instalado"
fi

if [[ -d "$CURSORS_DIR/Sweet-cursors" ]]; then
    ok "Sweet-cursors  →  ya instalado"
else
    info "Clonando Sweet-cursors..."
    git clone --depth=1 https://github.com/EliverLara/Sweet-cursors.git "$CURSORS_DIR/Sweet-cursors"
    ok "Sweet-cursors instalado"
fi

# ─────────────────────────────────────────
#  3. Microsoft Edit
# ─────────────────────────────────────────
header "── Editor: Microsoft Edit ───────────────────────"

if command -v edit &>/dev/null; then
    ok "edit  →  $(edit --version 2>/dev/null)"
else
    info "Descargando Microsoft Edit..."
    EDIT_VERSION=$(curl -s https://api.github.com/repos/microsoft/edit/releases/latest | grep '"tag_name"' | cut -d'"' -f4 | tr -d 'v')
    EDIT_URL="https://github.com/microsoft/edit/releases/download/v${EDIT_VERSION}/edit-${EDIT_VERSION}-x86_64-linux-gnu.tar.gz"
    mkdir -p "$HOME/.local/bin"
    curl -sL "$EDIT_URL" | tar -xz -C "$HOME/.local/bin/"
    chmod +x "$HOME/.local/bin/edit"
    ok "edit  →  $(edit --version 2>/dev/null)"
fi

# ─────────────────────────────────────────
#  4. Plugins zsh (sourced directamente desde pacman)
# ─────────────────────────────────────────
header "── Plugins zsh ──────────────────────────────────"

for plugin in zsh-autosuggestions zsh-syntax-highlighting; do
    if [[ -f "/usr/share/zsh/plugins/$plugin/$plugin.zsh" ]]; then
        ok "$plugin  →  disponible"
    else
        warn "$plugin  →  /usr/share/zsh/plugins/$plugin/ no encontrado"
    fi
done

# ─────────────────────────────────────────
#  5. Shell de login (zsh)
# ─────────────────────────────────────────
header "── Shell de login ───────────────────────────────"

ZSH_PATH="$(command -v zsh)"
if [[ "$SHELL" == "$ZSH_PATH" ]]; then
    ok "zsh  →  ya es el shell de login"
else
    warn "Shell actual: $SHELL  →  cambiando a zsh"
    chsh -s "$ZSH_PATH"
    ok "Shell cambiado a zsh (efectivo en la próxima sesión)"
fi

# ─────────────────────────────────────────
#  6. Configuración de git
# ─────────────────────────────────────────
header "── Configuración de git ─────────────────────────"

GIT_NAME="$(git config --global user.name 2>/dev/null || true)"
GIT_EMAIL="$(git config --global user.email 2>/dev/null || true)"

if [[ -n "$GIT_NAME" && -n "$GIT_EMAIL" ]]; then
    ok "git user  →  $GIT_NAME <$GIT_EMAIL>"
else
    warn "git user no configurado — se usará el valor del .gitconfig del repo"
fi

# ─────────────────────────────────────────
#  7. Kvantum: Slot Dark theme
# ─────────────────────────────────────────
header "── Kvantum: Slot Dark ───────────────────────────"

KVANTUM_DEST="$HOME/.config/Kvantum"
mkdir -p "$KVANTUM_DEST"

if [[ -d "$KVANTUM_DEST/Slot-Dark-Kvantum" ]]; then
    ok "Slot-Dark-Kvantum  →  ya instalado"
else
    cp -r "$DOTFILES_DIR/kvantum/Slot-Dark-Kvantum" "$KVANTUM_DEST/"
    ok "Slot-Dark-Kvantum  →  instalado"
fi

if [[ -f "$KVANTUM_DEST/kvantum.kvconfig" && ! -L "$KVANTUM_DEST/kvantum.kvconfig" ]]; then
    mv "$KVANTUM_DEST/kvantum.kvconfig" "$KVANTUM_DEST/kvantum.kvconfig.bak"
fi
ln -sf "$DOTFILES_DIR/kvantum/kvantum.kvconfig" "$KVANTUM_DEST/kvantum.kvconfig"
ok "kvantum.kvconfig  →  Slot-Dark-Kvantum activo"

if command -v kwriteconfig6 &>/dev/null; then
    kwriteconfig6 --file kdeglobals --group KDE --key widgetStyle kvantum
    ok "Widget style  →  kvantum"
fi

# ─────────────────────────────────────────
#  8. Variables de entorno Wayland
# ─────────────────────────────────────────
header "── Variables de entorno Wayland ─────────────────"

mkdir -p "$HOME/.config/environment.d"

# ─────────────────────────────────────────
#  8. Backup de configs existentes
# ─────────────────────────────────────────
header "── Backup de configuraciones existentes ──────────"

backup_file() {
    local target="$1"
    if [[ -L "$target" ]]; then
        rm "$target"
        info "Symlink previo eliminado: $target"
    elif [[ -e "$target" ]]; then
        mv "$target" "${target}.bak"
        warn "Backup: $(basename "$target") → ${target}.bak"
    fi
}

backup_file "$HOME/.config/ghostty/config"
backup_file "$HOME/.zshrc"
backup_file "$HOME/.config/starship.toml"
backup_file "$HOME/.config/fastfetch/config.jsonc"
backup_file "$HOME/.config/bat/config"
backup_file "$HOME/.config/atuin/config.toml"
backup_file "$HOME/.config/gtk-3.0/settings.ini"
backup_file "$HOME/.config/gtk-4.0/settings.ini"
backup_file "$HOME/.nanorc"
backup_file "$HOME/.gitconfig"
backup_file "$HOME/.gitignore_global"
backup_file "$HOME/.config/environment.d/wayland.conf"
backup_file "$HOME/.config/xremap/config.yml"

# ─────────────────────────────────────────
#  9. Instalar configuraciones (symlinks)
# ─────────────────────────────────────────
header "── Enlazando archivos de configuración ──────────"

link_config() {
    local src="$1"
    local dest="$2"
    mkdir -p "$(dirname "$dest")"
    ln -sf "$src" "$dest"
    ok "$(basename "$src")  →  $dest"
}

link_config "$DOTFILES_DIR/ghostty/config"               "$HOME/.config/ghostty/config"
link_config "$DOTFILES_DIR/zsh/.zshrc"                   "$HOME/.zshrc"
link_config "$DOTFILES_DIR/starship/starship.toml"       "$HOME/.config/starship.toml"
link_config "$DOTFILES_DIR/fastfetch/config.jsonc"       "$HOME/.config/fastfetch/config.jsonc"
link_config "$DOTFILES_DIR/bat/config"                   "$HOME/.config/bat/config"
link_config "$DOTFILES_DIR/atuin/config.toml"            "$HOME/.config/atuin/config.toml"
link_config "$DOTFILES_DIR/gtk/gtk-3.0/settings.ini"     "$HOME/.config/gtk-3.0/settings.ini"
link_config "$DOTFILES_DIR/gtk/gtk-4.0/settings.ini"     "$HOME/.config/gtk-4.0/settings.ini"
link_config "$DOTFILES_DIR/nano/.nanorc"                 "$HOME/.nanorc"
link_config "$DOTFILES_DIR/git/.gitconfig"               "$HOME/.gitconfig"
link_config "$DOTFILES_DIR/git/.gitignore_global"        "$HOME/.gitignore_global"
link_config "$DOTFILES_DIR/wayland/wayland.conf"              "$HOME/.config/environment.d/wayland.conf"
link_config "$DOTFILES_DIR/xremap/config.yml"                 "$HOME/.config/xremap/config.yml"

# ── Icono Clara Corp ──────────────────────────────────────────────────────────
mkdir -p "$HOME/.local/share/pixmaps"
for size in 16 24 32 48 64 96 128 256 512; do
    mkdir -p "$HOME/.local/share/icons/hicolor/${size}x${size}/apps"
    magick "$DOTFILES_DIR/icon/clara-glow.png" \
        -resize "${size}x${size}" \
        "$HOME/.local/share/icons/hicolor/${size}x${size}/apps/clara.png" 2>/dev/null
done
cp "$DOTFILES_DIR/icon/clara-glow.png" "$HOME/.local/share/pixmaps/clara.png"
gtk-update-icon-cache -f "$HOME/.local/share/icons/hicolor" 2>/dev/null || true
ok "icono clara  →  instalado en hicolor (16–512px) + pixmaps"

# ─────────────────────────────────────────
#  10. Terminal por defecto en KDE (Ghostty)
# ─────────────────────────────────────────
header "── Terminal por defecto en KDE ──────────────────"

if command -v kwriteconfig6 &>/dev/null; then
    kwriteconfig6 --file kdeglobals --group General --key TerminalApplication ghostty
    kwriteconfig6 --file kdeglobals --group General --key TerminalService ghostty.desktop
    ok "Terminal KDE  →  ghostty"
else
    warn "kwriteconfig6 no encontrado — configura la terminal manualmente en Ajustes del sistema"
fi

# ─────────────────────────────────────────
#  11. Andromeda Launcher (widget Plasma)
# ─────────────────────────────────────────
header "── Andromeda Launcher ───────────────────────────"

# Andromeda Launcher es un widget de KDE Plasma preinstalado en CachyOS.
# El widget ID varía por instalación, así que el shortcut se configura
# manualmente: clic derecho en el widget → Configurar shortcut → Meta
info "Andromeda Launcher es un widget Plasma — asigna la tecla Super"
info "manualmente: clic derecho en el widget del panel → Asignar atajo"

# ─────────────────────────────────────────
#  Fin
# ─────────────────────────────────────────
echo
echo -e "${GREEN}${BOLD}  Instalación completada.${RESET}"
echo -e "   Abre una nueva terminal o ejecuta ${BOLD}source ~/.zshrc${RESET} para aplicar los cambios."
echo
