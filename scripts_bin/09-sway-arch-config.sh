#!/bin/bash

# Colori per l'output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== CachyOS Sway 'Ricing' Installer ===${NC}"
echo "Questo script installerà pacchetti, farà il backup delle config esistenti"
echo "e imposterà un ambiente Sway completo con tema Catppuccin."
echo ""
read -p "Premi INVIO per continuare o Ctrl+C per annullare..."

# 1. INSTALLAZIONE PACCHETTI
echo -e "${GREEN}[1/5] Installazione pacchetti necessari...${NC}"

# Lista pacchetti ufficiali
PKGS=(
  sway swaybg swaylock-effects swayidle
  waybar swaync rofi-wayland
  kitty starship
  ttc-iosevka-nerd ttf-jetbrains-mono-nerd ttf-font-awesome
  papirus-icon-theme
  grim slurp wl-clipboard
  polkit-gnome
  pavucontrol
  thunar thunar-archive-plugin
  nwg-look
  stow git
)

# Installazione con pacman
sudo pacman -S --needed --noconfirm "${PKGS[@]}"

# Installazione tema GTK da AUR (usando paru che è standard su CachyOS)
if command -v paru &>/dev/null; then
  echo -e "${BLUE}Installazione tema Catppuccin GTK con paru...${NC}"
  paru -S --needed --noconfirm catppuccin-gtk-theme-mocha
else
  echo -e "${RED}Paru non trovato. Salto installazione tema GTK AUR.${NC}"
fi

# 2. PREPARAZIONE DIRECTORY E BACKUP
echo -e "${GREEN}[2/5] Backup e creazione struttura Dotfiles...${NC}"

DOTFILES_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/config_backup_$(date +%Y%m%d_%H%M%S)"

mkdir -p "$DOTFILES_DIR"
mkdir -p "$BACKUP_DIR"

# Funzione per backup
backup_config() {
  target="$1"
  if [ -d "$CONFIG_DIR/$target" ] || [ -L "$CONFIG_DIR/$target" ]; then
    echo "Backup di $target in $BACKUP_DIR"
    mv "$CONFIG_DIR/$target" "$BACKUP_DIR/"
  fi
}

# Rimuovi/Backup config esistenti per evitare conflitti con Stow
backup_config "sway"
backup_config "waybar"
backup_config "kitty"
backup_config "rofi"
backup_config "swaync"
# Starship usa un file singolo, non una cartella in .config solitamente, ma per stow usiamo la struttura
if [ -f "$CONFIG_DIR/starship.toml" ]; then mv "$CONFIG_DIR/starship.toml" "$BACKUP_DIR/"; fi

# Creazione struttura cartelle per Stow
mkdir -p "$DOTFILES_DIR/sway/.config/sway"
mkdir -p "$DOTFILES_DIR/waybar/.config/waybar"
mkdir -p "$DOTFILES_DIR/kitty/.config/kitty"
mkdir -p "$DOTFILES_DIR/rofi/.config/rofi"
mkdir -p "$DOTFILES_DIR/swaync/.config/swaync"
mkdir -p "$DOTFILES_DIR/starship/.config"

# 3. GENERAZIONE FILE DI CONFIGURAZIONE
echo -e "${GREEN}[3/5] Generazione dei file di configurazione...${NC}"

# --- SWAY CONFIG ---
cat <<'EOF' >"$DOTFILES_DIR/sway/.config/sway/config"
# --- Variabili ---
set $mod Mod4
set $term kitty
set $menu rofi -show drun -theme-str 'window {width: 500px;}'

# --- Output & Input ---
output * bg $HOME/Immagini/wallpaper.jpg fill
input type:keyboard {
    xkb_layout it
}

# --- Aspetto ---
font pango:JetBrainsMono Nerd Font 10
gaps inner 10
gaps outer 5
default_border pixel 2
default_floating_border pixel 2

# Colori Catppuccin Mocha
set $base #1e1e2e
set $text #cdd6f4
set $sky  #89dceb
set $overlay #6c7086
set $red  #f38ba8

client.focused           $sky    $base      $text   $sky      $sky
client.focused_inactive  $overlay $base     $text   $overlay  $overlay
client.unfocused         $overlay $base     $text   $overlay  $overlay
client.urgent            $red    $base      $text   $red      $red

# --- Avvio Automatico ---
exec swaync
exec /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
exec_always waybar

# --- Keybindings ---
bindsym $mod+Return exec $term
bindsym $mod+d exec $menu
bindsym $mod+q kill
bindsym $mod+Shift+e exec swaynag -t warning -m 'Vuoi uscire?' -B 'Esci' 'swaymsg exit'
bindsym $mod+Shift+r reload
bindsym Print exec grim -g "$(slurp)" $HOME/Immagini/Screenshot_$(date +%Y-%m-%d_%H-%M-%S).png

# Navigazione
bindsym $mod+h focus left
bindsym $mod+j focus down
bindsym $mod+k focus up
bindsym $mod+l focus right
bindsym $mod+Shift+h move left
bindsym $mod+Shift+j move down
bindsym $mod+Shift+k move up
bindsym $mod+Shift+l move right
bindsym $mod+f fullscreen toggle
bindsym $mod+Shift+space floating toggle

# Workspaces
bindsym $mod+1 workspace number 1
bindsym $mod+2 workspace number 2
bindsym $mod+3 workspace number 3
bindsym $mod+4 workspace number 4
bindsym $mod+Shift+1 move container to workspace number 1
bindsym $mod+Shift+2 move container to workspace number 2
bindsym $mod+Shift+3 move container to workspace number 3
bindsym $mod+Shift+4 move container to workspace number 4
EOF

# --- WAYBAR CONFIG ---
cat <<'EOF' >"$DOTFILES_DIR/waybar/.config/waybar/config"
{
    "layer": "top",
    "position": "top",
    "height": 34,
    "margin-top": 5,
    "margin-left": 10,
    "margin-right": 10,
    "spacing": 10,
    "modules-left": ["sway/workspaces", "sway/mode"],
    "modules-center": ["clock"],
    "modules-right": ["pulseaudio", "network", "battery", "tray"],
    "sway/workspaces": {
        "disable-scroll": true,
        "all-outputs": true,
        "format": "{name}"
    },
    "clock": {
        "format": " {:%H:%M   %d/%m}",
        "tooltip-format": "<big>{:%Y %B}</big>\n<tt>{calendar}</tt>"
    },
    "battery": {
        "states": { "warning": 30, "critical": 15 },
        "format": "{icon} {capacity}%",
        "format-icons": ["", "", "", "", ""]
    },
    "network": {
        "format-wifi": " {essid}",
        "format-ethernet": " Eth",
        "format-disconnected": "⚠ No Net"
    },
    "pulseaudio": {
        "format": "{icon} {volume}%",
        "format-icons": { "default": ["", "", ""] },
        "on-click": "pavucontrol"
    }
}
EOF

# --- WAYBAR CSS ---
cat <<'EOF' >"$DOTFILES_DIR/waybar/.config/waybar/style.css"
* { border: none; border-radius: 0; font-family: "JetBrainsMono Nerd Font"; font-weight: bold; font-size: 14px; min-height: 0; }
window#waybar { background: transparent; color: #cdd6f4; }
#workspaces { background: #1e1e2e; margin: 0 5px; padding: 0 5px; border-radius: 16px; border: 1px solid #cba6f7; }
#workspaces button { padding: 0 5px; background: transparent; color: #cdd6f4; }
#workspaces button.focused { color: #cba6f7; }
#clock, #battery, #network, #pulseaudio, #tray, #mode { padding: 0 10px; margin: 0 5px; background: #1e1e2e; color: #cdd6f4; border-radius: 16px; border: 1px solid #89dceb; }
#clock { color: #fab387; border-color: #fab387; }
#battery.charging { color: #a6e3a1; border-color: #a6e3a1; }
#battery.critical:not(.charging) { background-color: #f38ba8; color: #1e1e2e; animation-name: blink; animation-duration: 0.5s; animation-iteration-count: infinite; }
@keyframes blink { to { background-color: #ffffff; } }
EOF

# --- KITTY CONFIG ---
cat <<'EOF' >"$DOTFILES_DIR/kitty/.config/kitty/kitty.conf"
font_family      JetBrainsMono Nerd Font
bold_font        auto
italic_font      auto
bold_italic_font auto
font_size 11.0
window_padding_width 10
background_opacity 0.85
confirm_os_window_close 0
background #1e1e2e
foreground #cdd6f4
selection_background #585b70
selection_foreground #cdd6f4
url_color #f5e0dc
cursor #f5e0dc
cursor_text_color #1e1e2e
tab_bar_style powerline
EOF

# --- STARSHIP CONFIG ---
cat <<'EOF' >"$DOTFILES_DIR/starship/.config/starship.toml"
format = """
[╭─](bold blue)$directory$git_branch
[╰─](bold blue)$character
"""
[directory]
style = "bold lavender"
truncation_length = 3
truncation_symbol = "…/"
[git_branch]
symbol = " "
style = "bold pink"
[character]
success_symbol = "[➜](bold green)"
error_symbol = "[✗](bold red)"
EOF

# 4. DOWNLOAD WALLPAPER
echo -e "${GREEN}[4/5] Scaricando Wallpaper...${NC}"
mkdir -p "$HOME/Immagini"
# Scarica un wallpaper Catppuccin style
curl -sL "https://raw.githubusercontent.com/zhichaoh/catppuccin-wallpapers/main/misc/footprints.png" -o "$HOME/Immagini/wallpaper.jpg"

if [ $? -ne 0 ]; then
  echo "Download wallpaper fallito. Creazione placeholder."
  convert -size 1920x1080 xc:#1e1e2e "$HOME/Immagini/wallpaper.jpg" 2>/dev/null || touch "$HOME/Immagini/wallpaper.jpg"
fi

# 5. APPLICAZIONE CON STOW E SETUP FINALE
echo -e "${GREEN}[5/5] Applicazione configurazioni con Stow...${NC}"

cd "$DOTFILES_DIR"
stow sway
stow waybar
stow kitty
stow rofi
stow swaync
stow starship

# Aggiunta Starship alla shell
SHELL_CFG=""
if [[ $SHELL == *"zsh"* ]]; then
  SHELL_CFG="$HOME/.zshrc"
elif [[ $SHELL == *"bash"* ]]; then
  SHELL_CFG="$HOME/.bashrc"
fi

if [ -n "$SHELL_CFG" ] && [ -f "$SHELL_CFG" ]; then
  if ! grep -q "starship init" "$SHELL_CFG"; then
    echo 'eval "$(starship init $(basename $SHELL))"' >>"$SHELL_CFG"
    echo "Starship aggiunto a $SHELL_CFG"
  fi
else
  echo -e "${RED}Impossibile rilevare file config della shell. Aggiungi manualmente 'eval \"\$(starship init zsh)\"' al tuo .zshrc${NC}"
fi

# Reload font cache
fc-cache -f

echo -e "${BLUE}=== Installazione Completata ===${NC}"
echo "1. I vecchi file config sono in: $BACKUP_DIR"
echo "2. I nuovi dotfiles sono in: $DOTFILES_DIR"
echo "3. Riavvia il computer o fai logout/login per vedere tutti i cambiamenti."
echo "4. Per personalizzare i temi GTK, apri 'nwg-look' dal menu dopo il riavvio."
