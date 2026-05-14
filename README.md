# clara-dotfiles

Dotfiles personales para CachyOS / Arch Linux con KDE Plasma 6.  
Shell: **zsh** · Prompt: **Starship** (Catppuccin Mocha) · Terminal: **Ghostty** (Catppuccin Mocha) · Editor: **Microsoft Edit**

---

## Instalación rápida

```bash
git clone https://github.com/claraogalla/clara-dotfiles.git ~/clara-dotfiles
cd ~/clara-dotfiles
chmod +x install.sh
./install.sh
```

El script instala dependencias, clona temas, configura KDE y enlaza todo con symlinks. No se necesita nada previo.

---

## Qué hace `install.sh`

| Paso | Qué hace |
|------|----------|
| 1 | Instala paquetes pacman que falten (`ghostty`, `zsh`, `starship`, `bat`, `atuin`…) |
| 2 | Descarga **candy-icons** y **Sweet-cursors** desde GitHub si no están |
| 3 | Instala **Oh My Zsh** automáticamente si no existe |
| 4 | Crea symlinks de plugins zsh desde pacman |
| 5 | Cambia el shell de login a **zsh** con `chsh` |
| 6 | Descarga **Microsoft Edit** (editor de terminal) desde GitHub releases |
| 7 | Instala el tema **Slot Dark Kvantum** y lo activa en KDE |
| 8 | Configura variables de entorno Wayland |
| 9 | Backup `.bak` de configs existentes |
| 10 | Enlaza todas las configs con **symlinks** (editar el repo = cambio inmediato) |
| 11 | Registra Ghostty como terminal por defecto en KDE |
| 12 | Muestra instrucciones para asignar **Super** a Andromeda Launcher (widget Plasma) |

---

## Estructura del repo

```
clara-dotfiles/
├── atuin/
│   └── config.toml             →  ~/.config/atuin/config.toml
├── bat/
│   └── config                  →  ~/.config/bat/config
├── fastfetch/
│   └── config.jsonc            →  ~/.config/fastfetch/config.jsonc
├── ghostty/
│   └── config                  →  ~/.config/ghostty/config
├── git/
│   ├── .gitconfig              →  ~/.gitconfig
│   └── .gitignore_global       →  ~/.gitignore_global
├── gtk/
│   ├── gtk-3.0/settings.ini   →  ~/.config/gtk-3.0/settings.ini
│   └── gtk-4.0/settings.ini   →  ~/.config/gtk-4.0/settings.ini
├── icon/
│   ├── clara-mauve.{png,ico}   —  fondo oscuro + trazos mauve
│   ├── clara-white.{png,ico}   —  fondo oscuro + trazos blancos
│   ├── clara-gradient.{png,ico}—  fondo degradado + trazos mauve
│   └── clara-glow.{png,ico}    —  fondo oscuro + efecto neón
├── kvantum/
│   ├── kvantum.kvconfig        →  ~/.config/Kvantum/kvantum.kvconfig
│   └── Slot-Dark-Kvantum/      →  ~/.config/Kvantum/Slot-Dark-Kvantum/
├── nano/
│   └── .nanorc                 →  ~/.nanorc
├── starship/
│   └── starship.toml           →  ~/.config/starship.toml
├── wayland/
│   └── wayland.conf            →  ~/.config/environment.d/wayland.conf
├── xremap/
│   └── config.yml              →  ~/.config/xremap/config.yml
├── zsh/
│   └── .zshrc                  →  ~/.zshrc
├── packages.txt                —  lista de referencia de paquetes
└── install.sh
```

---

## Stack

### Terminal y shell

| Herramienta | Función |
|-------------|---------|
| [Ghostty](https://ghostty.org) | Terminal — rápido, nativo Wayland, splits sin tmux |
| zsh | Shell principal sin Oh My Zsh (plugins directos desde pacman) |
| [Starship](https://starship.rs) | Prompt — Catppuccin Mocha, batería, hora, lenguajes |
| [Atuin](https://atuin.sh) | Historial avanzado — búsqueda fuzzy, contexto por host |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | `cd` inteligente con historial |
| [fzf](https://github.com/junegunn/fzf) | Búsqueda fuzzy interactiva |
| [eza](https://github.com/eza-community/eza) | `ls` con iconos Nerd Font y git status |
| [bat](https://github.com/sharkdp/bat) | `cat` con syntax highlighting |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | `grep` ultrarrápido |
| [fastfetch](https://github.com/fastfetch-cli/fastfetch) | Info del sistema al abrir terminal |
| [Microsoft Edit](https://github.com/microsoft/edit) | Editor de terminal moderno (descargado desde releases) |

### KDE / Wayland

| Herramienta | Función |
|-------------|---------|
| KDE Plasma 6 + KWin Wayland | Entorno de escritorio |
| [Kvantum](https://github.com/tsujan/Kvantum) + Slot Dark | Estilo Qt para apps KDE |
| Andromeda Launcher | Launcher — tecla Super (widget Plasma, preinstalado en CachyOS) |
| xremap | Remapeo de teclas (botón Copilot → XF86Assistant) |
| candy-icons | Tema de iconos |
| Sweet-cursors | Tema de cursores |
| JetBrainsMono Nerd Font | Fuente para terminal y Starship |

---

## Aliases

| Alias | Comando real |
|-------|-------------|
| `ls` | `eza --icons` |
| `ll` | `eza -la --icons --git` |
| `la` | `eza -a --icons` |
| `lt` | `eza --tree --icons` |
| `cat` | `bat` |
| `grep` | `rg` |
| `cd` | `z` (zoxide) |
| `e` / `nano` / `vi` | `edit` (Microsoft Edit) |

---

## Icono (Clara Corp)

Logo personal — mezcla creativa de cebolla y gato. Variantes en `icon/`:

| Variante | Descripción |
|----------|-------------|
| `clara-glow` | Efecto neón con halo mauve — **por defecto** |
| `clara-mauve` | Trazos mauve (#cba6f7) sobre fondo #1e1e2e |
| `clara-white` | Trazos blancos sobre fondo oscuro — máximo contraste |
| `clara-gradient` | Fondo degradado crust→surface0 con trazos mauve |

---

## Atajos de Ghostty

| Atajo | Acción |
|-------|--------|
| `Ctrl+Shift+T` | Nueva tab |
| `Ctrl+Shift+O` | Split horizontal |
| `Ctrl+Shift+E` | Split vertical |
| `Alt+←↑↓→` | Navegar entre splits |
| `Ctrl+Shift+W` | Cerrar tab/split |
| `Ctrl+Shift+F` | Buscar en buffer |
| `Ctrl+Shift+,` | Recargar config |
