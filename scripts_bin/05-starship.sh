#!/bin/bash
# scripts_bin/06-starship.sh
set -e

echo "🚀 [6/7] Installazione Starship Prompt su CachyOS..."

# 1. Installazione da Repository Ufficiali
# Starship è nei repository 'extra' di Arch Linux.
# Usare pacman garantisce aggiornamenti automatici e sicurezza.
echo "    ⬇️  Installazione pacchetto starship..."
sudo pacman -S --needed --noconfirm starship

# 2. Configurazione Shell (Hook)
# CachyOS potrebbe usare ZSH o BASH di default.
# Questo script configura entrambi per sicurezza.

# --- Configurazione BASH ---
BASH_RC="$HOME/.bashrc"
if [ -f "$BASH_RC" ]; then
  if ! grep -q "starship init bash" "$BASH_RC"; then
    echo "    📝 Attivazione Starship in .bashrc..."
    echo "" >>"$BASH_RC"
    echo "# Starship Prompt" >>"$BASH_RC"
    echo 'eval "$(starship init bash)"' >>"$BASH_RC"
  else
    echo "    ✅ Hook già presente in .bashrc."
  fi
fi

# --- Configurazione ZSH (Molto comune su CachyOS/Arch) ---
# Se in futuro decidi di usare Zsh (consigliato su Arch), sei già pronto.
ZSH_RC="$HOME/.zshrc"
if [ -f "$ZSH_RC" ]; then
  if ! grep -q "starship init zsh" "$ZSH_RC"; then
    echo "    📝 Attivazione Starship in .zshrc..."
    echo "" >>"$ZSH_RC"
    echo 'eval "$(starship init zsh)"' >>"$ZSH_RC"
  fi
fi

# 3. Creazione file config (Opzionale ma utile)
# Crea il file di configurazione di default se non esiste, così puoi personalizzarlo subito.
CONFIG_DIR="$HOME/.config"
mkdir -p "$CONFIG_DIR"
if [ ! -f "$CONFIG_DIR/starship.toml" ]; then
  echo "    ⚙️  Creazione config default ~/.config/starship.toml"
  starship preset nerd-font-symbols -o "$CONFIG_DIR/starship.toml"
fi

echo "✅ Starship installato e configurato!"
echo "   (Riavvia il terminale o digita 'source ~/.bashrc' per vederlo)"
