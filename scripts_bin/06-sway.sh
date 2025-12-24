#!/bin/bash
set -e

echo "----------------------------------------------------"
echo "🚀 HOST REAL METAL: Installazione Sway & Tools su CachyOS"
echo "----------------------------------------------------"

# 1. Aggiornamento Repository
# -Syu: Sincronizza (S), Aggiorna pacchetti (y), Aggiorna sistema (u)
sudo pacman -Syu --noconfirm

# 2. Installazione Pacchetti
# NOTA SUI NOMI:
# - mako-notifier -> mako
# - network-manager-gnome -> network-manager-applet
# - fonts-font-awesome -> ttf-font-awesome
# - libglib2.0-bin -> glib2 (già nel sistema base)
# - pulseaudio-utils -> sostituito dall'ecosistema pipewire (default su CachyOS)

echo "    ⬇️  Installazione pacchetti..."
sudo pacman -S --needed --noconfirm \
  sway swaybg swayidle swaylock \
  waybar wofi mako \
  grim slurp wl-clipboard \
  pavucontrol pamixer \
  brightnessctl \
  network-manager-applet \
  wtype \
  ttf-font-awesome papirus-icon-theme \
  xdg-desktop-portal-wlr xdg-desktop-portal-gtk \
  polkit-gnome \
  qt5-wayland qt6-wayland \
  wlogout

# Nota: 'polkit-gnome' è CRUCIALE su Arch/Sway per avere i popup di autenticazione (sudo GUI).
# Nota: 'qt5/6-wayland' servono per far funzionare bene le app non-GTK.

# 3. Creazione Cartelle Config
echo "    📂 Preparazione cartelle..."
mkdir -p "$HOME/.config/sway"
mkdir -p "$HOME/.config/waybar"
mkdir -p "$HOME/.config/wofi"
mkdir -p "$HOME/.config/mako"
mkdir -p "$HOME/Pictures/Wallpapers"

# 4. Scaricamento Sfondo
WALLPAPER="$HOME/Pictures/Wallpapers/ultimate_purple.jpg"
if [ ! -f "$WALLPAPER" ]; then
  echo "    🖼️  Scaricamento wallpaper..."
  curl -L -o "$WALLPAPER" "https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?q=80&w=1964&auto=format&fit=crop"
fi

echo "    ✅ Installazione completata."
