#!/bin/bash
# scripts_bin/05-fonts.sh
set -e

echo "🔤 [5/5] Installazione Nerd Fonts su CachyOS..."

# 1. Installazione tramite Pacman
# Vantaggio: Il font verrà aggiornato automaticamente con il sistema.
# ttf-jetbrains-mono-nerd: Il font che hai richiesto
# ttf-font-awesome: Spesso essenziale per le icone di Waybar (Sway)
# noto-fonts-emoji: Per vedere le emoji colorate nel terminale e nelle app
echo "    ⬇️  Installazione pacchetti font dai repository..."
sudo pacman -S --needed --noconfirm \
  ttf-jetbrains-mono-nerd \
  ttf-font-awesome \
  noto-fonts-emoji

# 2. Rigenerazione Cache
# Pacman esegue degli "hook" automatici, ma forzare la cache assicura
# che le applicazioni (come Alacritty/Kitty) vedano i font istantaneamente.
echo "    🔄 Aggiornamento cache font di sistema..."
fc-cache -fv >/dev/null

# 3. Verifica
echo "    ✅ Verifica installazione JetBrainsMono:"
if fc-list | grep -qi "JetBrainsMono Nerd Font"; then
  echo "       SUCCESS: JetBrainsMono Nerd Font rilevato correttamente."
else
  echo "       WARNING: Potrebbe essere necessario riavviare la sessione."
fi
