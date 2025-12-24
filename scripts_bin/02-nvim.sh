#!/bin/bash
# scripts_bin/02-nvim.sh
set -e

echo "📝 [2/4] Setup Neovim & LazyVim su CachyOS..."

# 1. Installazione Neovim dai Repository Ufficiali (o CachyOS Repo)
# Su Arch/CachyOS, 'neovim' è sempre all'ultima versione stabile.
# Non serve scaricare tarball manuali come su Ubuntu.
echo "    ⬇️  Installazione Neovim tramite Pacman..."
sudo pacman -S --needed --noconfirm neovim

# 2. Installazione Dipendenze Obbligatorie per LazyVim
# LazyVim richiede: git, make, unzip, gcc, ripgrep, fd, clipboard tool
# Molti sono già nel tuo sys_packages, ma per sicurezza verifichiamo qui.
# Nota: Su Arch il pacchetto si chiama 'fd', non 'fd-find'.
echo "    📦 Verifica dipendenze LazyVim..."
deps=(
  "ripgrep"
  "fd"
  "lazygit"
  "base-devel"
  "unzip"
  "wl-clipboard" # Fondamentale per copia/incolla su Wayland (Sway)
)
sudo pacman -S --needed --noconfirm "${deps[@]}"

# 3. Gestione Configurazione (LazyVim)
NVIM_CONFIG="$HOME/.config/nvim"
NVIM_SHARE="$HOME/.local/share/nvim"
NVIM_STATE="$HOME/.local/state/nvim"
NVIM_CACHE="$HOME/.cache/nvim"

echo "    💤 Configurazione LazyVim..."

# Se esiste già una config, facciamo un backup completo
if [ -d "$NVIM_CONFIG" ]; then
  echo "    ⚠️  Configurazione rilevata. Eseguo backup..."
  TIMESTAMP=$(date +%Y%m%d_%H%M%S)
  mv "$NVIM_CONFIG" "${NVIM_CONFIG}.bak_$TIMESTAMP"

  # Rimuoviamo anche cache e plugin vecchi per evitare conflitti
  # (LazyVim scaricherà tutto fresco al primo avvio)
  rm -rf "$NVIM_SHARE" "$NVIM_STATE" "$NVIM_CACHE"
  echo "    ✅ Backup salvato in ${NVIM_CONFIG}.bak_$TIMESTAMP"
fi

# 4. Installazione LazyVim Starter
echo "    ⬇️  Clonazione LazyVim Starter..."
git clone https://github.com/LazyVim/starter "$NVIM_CONFIG"

# Rimuoviamo la cartella .git del template così puoi farne un tuo repo personale
rm -rf "$NVIM_CONFIG/.git"

echo "    ✅ Neovim installato: $(nvim --version | head -n 1)"
echo "    🚀 Al primo avvio, LazyVim installerà automaticamente i plugin."
