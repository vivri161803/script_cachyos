#!/bin/bash
# setup.sh - Orchestrator per CachyOS Setup

# Interrompe l'esecuzione se un comando fallisce
set -e

# --- Colori per l'output ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# --- Funzione di utilità per lanciare gli script ---
run_script() {
  script_path="$1"
  if [ -f "$script_path" ]; then
    echo -e "${BLUE}▶ Esecuzione: $script_path...${NC}"
    # Rendiamo eseguibile per sicurezza
    chmod +x "$script_path"
    ./"$script_path"
    echo -e "${GREEN}✔ Completato: $script_path${NC}\n"
  else
    echo -e "${RED}⚠️  Attenzione: Script $script_path non trovato. Salto.${NC}\n"
  fi
}

# --- HEADER ---
clear
echo -e "${BLUE}=================================================${NC}"
echo -e "${BLUE}     CACHYOS & SWAY SETUP - LENOVO T490         ${NC}"
echo -e "${BLUE}=================================================${NC}"
echo -e "${YELLOW}Nota: Verrà richiesta la password di sudo.${NC}\n"

# Richiedi sudo subito per aggiornare il timeout
sudo -v
# Mantieni sudo vivo in background
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

# --- 1. SETTING PERMISSIONS ---
echo -e "${GREEN}[*] Impostazione permessi di esecuzione...${NC}"
chmod +x scripts_bin/*.sh

# --- 2. ESECUZIONE SEQUENZIALE ---

# 1. Sistema e Pacchetti (Include XFCE come backup)
run_script "scripts_bin/01-system.sh"

# 2. Neovim & LazyVim
run_script "scripts_bin/02-nvim.sh"

# 3. GNOME/Backup DE
# Nota: Dato che abbiamo scelto XFCE nel file packages.conf,
# saltiamo esplicitamente script vecchi di gnome se presenti.

# 4. Docker
run_script "scripts_bin/04-docker.sh"

# 5. Fonts (NerdFonts)
run_script "scripts_bin/05-fonts.sh"

# 6. Starship Prompt
run_script "scripts_bin/06-starship.sh"

# 7. Sway Install (Cartelle e Wallpaper)
# run_script "scripts_bin/07-sway-install.sh"

# 8. Sway Config (Dotfiles e Tweak T490)
# run_script "scripts_bin/08-sway-config.sh"

# --- 3. CONFIGURAZIONE FINALE SISTEMA ---

echo -e "${BLUE}▶ Configurazione Display Manager (SDDM)...${NC}"
# Assicuriamoci che SDDM sia il gestore di login attivo
if systemctl list-unit-files | grep -q sddm.service; then
  sudo systemctl enable sddm --force
  echo -e "${GREEN}✔ SDDM abilitato all'avvio.${NC}"
else
  echo -e "${RED}❌ Errore: SDDM non trovato. Assicurati che sia in sys_packages.${NC}"
fi

# Cambio shell di default in Bash (se non lo è già, utile se Cachy usa Zsh/Fish di default)
# Se preferisci Zsh, cambia /bin/bash con /bin/zsh
if [ "$SHELL" != "/bin/bash" ]; then
  echo -e "${BLUE}▶ Imposto Bash come shell di default...${NC}"
  chsh -s /bin/bash
fi

# --- FINE ---
echo -e "${BLUE}=================================================${NC}"
echo -e "${GREEN}   ✅ INSTALLAZIONE COMPLETATA CON SUCCESSO!     ${NC}"
echo -e "${BLUE}=================================================${NC}"
echo -e "Cosa fare adesso:"
echo -e "1. ${YELLOW}Riavvia il sistema${NC} (sudo reboot)"
echo -e "2. Al login screen (SDDM), in basso a sinistra:"
echo -e "   - Seleziona ${GREEN}Sway${NC} per il daily driver."
echo -e "   - Seleziona ${YELLOW}Xfce Session${NC} in caso di emergenza."
echo -e "================================================="
