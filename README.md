# clara-dotfiles

Dotfiles personales para CachyOS / Arch Linux con KDE Plasma.  
Shell: **zsh** + **Oh My Zsh** · Prompt: **Starship** · Terminal: **Ghostty** · Tema: **Catppuccin Mocha**

---

## Dependencias

Instala todo de una vez:

```bash
sudo pacman -S ghostty zsh starship eza zoxide fzf atuin bat ripgrep ttf-jetbrains-mono-nerd
```

Luego instala **Oh My Zsh** (si aún no lo tienes):

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

| Paquete | Para qué sirve |
|---------|----------------|
| `ghostty` | Emulador de terminal |
| `zsh` | Shell principal |
| `starship` | Prompt cross-shell con info de git y lenguajes |
| `eza` | `ls` con iconos Nerd Font y soporte git |
| `zoxide` | `cd` inteligente con historial de directorios |
| `fzf` | Búsqueda fuzzy interactiva |
| `atuin` | Historial de comandos sincronizado y con contexto |
| `bat` | `cat` con resaltado de sintaxis |
| `ripgrep` | `grep` ultrarrápido |
| `ttf-jetbrains-mono-nerd` | Fuente requerida por Ghostty y Starship |

> **atuin** también se puede instalar vía cargo si prefieres la última versión:
> `cargo install atuin`

---

## Instalación

```bash
git clone https://github.com/tu-usuario/clara-dotfiles.git ~/clara-dotfiles
cd ~/clara-dotfiles
chmod +x install.sh
./install.sh
```

El script, en orden:

1. Verifica todas las dependencias (pacman, atuin, fuente JetBrains).
2. Comprueba que `~/.oh-my-zsh` existe.
3. Clona `zsh-autosuggestions` y `zsh-syntax-highlighting` si no están.
4. Hace backup de tus configs actuales añadiendo `.bak`.
5. Copia cada archivo a su ubicación definitiva.
6. Registra Ghostty como terminal por defecto en KDE con `kwriteconfig6`.

---

## Estructura

```
clara-dotfiles/
├── ghostty/
│   └── config              →  ~/.config/ghostty/config
├── zsh/
│   └── .zshrc              →  ~/.zshrc
├── starship/
│   └── starship.toml       →  ~/.config/starship.toml
└── install.sh
```

---

## Archivos de configuración

### `ghostty/config`

Configuración de Ghostty con:
- **Shell**: zsh con integración nativa.
- **Fuente**: JetBrainsMono Nerd Font Mono 13px.
- **Tema**: Catppuccin Mocha (oscuro) / Catppuccin Latte (claro), auto según el sistema.
- Padding 14px, cursor bloque sin parpadeo, copia automática al portapapeles al seleccionar.

### `zsh/.zshrc`

Configuración de zsh con Oh My Zsh:
- **Plugins**: `git`, `zsh-autosuggestions`, `zsh-syntax-highlighting`.
- **Historial**: 10 000 entradas, sin duplicados, compartido entre sesiones.
- **Aliases**: `ls`/`ll`/`la`/`lt` con eza, `cat` con bat, `grep` con ripgrep, `cd` con zoxide.
- Inicialización de Starship, zoxide y Atuin.
- Editor por defecto: `nvim`.

### `starship/starship.toml`

Prompt de dos líneas con paleta Catppuccin Mocha:
- Línea 1: directorio · rama git · estado git · versión de lenguaje activo · duración del comando (si > 2 s).
- Línea 2: `❯` verde (éxito) o rojo (error).
- Lenguajes detectados: Python, Node.js, Rust, Go, Java.

---

## Atajos de Ghostty

Ghostty no necesita tmux — gestiona splits y tabs de forma nativa.

### Tabs

| Atajo | Acción |
|-------|--------|
| `Ctrl+Shift+T` | Nueva tab |
| `Ctrl+Shift+W` | Cerrar tab / split activo |
| `Ctrl+Tab` | Siguiente tab |
| `Ctrl+Shift+Tab` | Tab anterior |
| `Ctrl+Shift+1…9` | Ir a tab N |

### Splits (paneles)

| Atajo | Acción |
|-------|--------|
| `Ctrl+Shift+O` | Nuevo split (horizontal) |
| `Ctrl+Shift+E` | Nuevo split (vertical) |
| `Alt+←↑↓→` | Navegar entre splits |
| `Ctrl+Shift+Enter` | Maximizar / restaurar split activo |
| `Ctrl+Shift+W` | Cerrar split activo |

### General

| Atajo | Acción |
|-------|--------|
| `Ctrl+Shift+F` | Buscar en el buffer |
| `Ctrl+Shift++` / `Ctrl+Shift+-` | Aumentar / reducir fuente |
| `Ctrl+Shift+0` | Restablecer tamaño de fuente |
| `Ctrl+Shift+C` / `Ctrl+Shift+V` | Copiar / pegar |
| `Ctrl+Shift+,` | Recargar configuración |

> Lista completa: `ghostty +list-keybindings`  
> Los atajos son personalizables en `~/.config/ghostty/config` con la directiva `keybind`.
