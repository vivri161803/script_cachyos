#!/bin/bash
# scripts_bin/09-dotfiles.sh
set -e

# --- CONFIGURAZIONE UTENTE ---
# Sostituisci con il TUO url reale
REPO_URL="https://github.com/vivri161803/dotfiles.git"
DOTFILES_DIR="$HOME/dotfiles"

# Cartelle da attivare (nomi presi dal tuo tree.txt)
STOW_FOLDERS=(
  "bash"
  "kitty"
  "mako"
  "nvim"
  "starship"
  "sway"
  "swaylock"
  "tmux"
  "waybar"
  "wlogout"
  "wofi"
)

echo "----------------------------------------------------"
echo "🔗 [9/9] Gestione Dotfiles (Ubuntu -> CachyOS Porting)"
echo "----------------------------------------------------"

# 1. Installazione Stow
if ! command -v stow &>/dev/null; then
  echo "    ⬇️  Installazione GNU Stow..."
  sudo pacman -S --needed --noconfirm stow
fi

# 2. Clone/Pull Repository
if [ ! -d "$DOTFILES_DIR" ]; then
  echo "    ⬇️  Clonazione repository..."
  git clone "$REPO_URL" "$DOTFILES_DIR"
else
  echo "    🔄 Aggiornamento repository..."
  cd "$DOTFILES_DIR" && git pull
fi

# 3. Backup Preventivo (Safe Mode)
# Rimuove le config di default create dall'installazione del sistema
# per evitare conflitti con Stow.
BACKUP_DIR="$HOME/.config/backup_pre_stow_$(date +%Y%m%d_%H%M%S)"
echo "    🛡️  Backup configurazioni esistenti in $BACKUP_DIR..."
mkdir -p "$BACKUP_DIR"

clean_and_backup() {
  target="$1"
  # Se esiste ed è un file/cartella reale (non un link simbolico)
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    mv "$target" "$BACKUP_DIR/"
  elif [ -L "$target" ]; then
    # Se è un link (magari rotto), lo rimuoviamo e basta
    rm "$target"
  fi
}

# Elenco dei file che sicuramente andranno in conflitto
clean_and_backup "$HOME/.bashrc"
clean_and_backup "$HOME/.config/sway"
clean_and_backup "$HOME/.config/waybar"
clean_and_backup "$HOME/.config/nvim"
clean_and_backup "$HOME/.config/kitty"
clean_and_backup "$HOME/.config/mako"
clean_and_backup "$HOME/.config/wofi"
clean_and_backup "$HOME/.config/wlogout"
clean_and_backup "$HOME/.config/starship.toml"
clean_and_backup "$HOME/.tmux.conf"

# 4. Esecuzione STOW
echo "    🔗 Creazione Link Simbolici (Stow)..."
cd "$DOTFILES_DIR"
for folder in "${STOW_FOLDERS[@]}"; do
  # -R: Restow (utile se riesegui lo script), -v: Verbose
  stow -R "$folder"
done

# ==============================================================================
# 5. ARCH LINUX / CACHYOS FIXER (La parte magica)
# ==============================================================================
# Qui correggiamo i path che differiscono da Ubuntu SENZA rompere la logica git.
# Modifichiamo il file linkato. Git lo vedrà come "modificato", ma è necessario
# affinché il sistema parta.

SWAY_CONFIG="$HOME/.config/sway/config"

echo "    🔧 Applicazione patch per compatibilità Arch Linux..."

if [ -f "$SWAY_CONFIG" ]; then
  # --- FIX 1: Polkit Agent ---
  # Ubuntu: /usr/lib/policykit-1-gnome/...
  # Arch:   /usr/lib/polkit-gnome/...

  if grep -q "policykit-1-gnome" "$SWAY_CONFIG"; then
    echo "       🩹 Correggendo path Polkit Agent (Ubuntu -> Arch)..."
    sed -i 's|/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1|/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1|g' "$SWAY_CONFIG"
  else
    echo "       ✅ Path Polkit sembra già corretto o assente."
  fi

  # --- FIX 2: Terminal Emulator ---
  # Se nei dotfiles usi gnome-terminal, lo forziamo a Kitty su CachyOS
  if grep -q "gnome-terminal" "$SWAY_CONFIG"; then
    echo "       🩹 Sostituendo gnome-terminal con Kitty..."
    sed -i 's/gnome-terminal/kitty/g' "$SWAY_CONFIG"
  fi
fi

# --- FIX 3: Permessi Script ---
# Spesso perdono il bit di esecuzione git-clonando
if [ -d "$HOME/.config/sway/scripts" ]; then
  echo "       ⚡ Rendendo eseguibili gli script custom di Sway..."
  chmod +x "$HOME/.config/sway/scripts/"*
fi

echo "    ✅ Dotfiles installati e adattati a CachyOS!"
