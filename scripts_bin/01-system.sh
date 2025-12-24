#!/bin/bash
# scripts_bin/01-system.sh

# Verifica che il file di configurazione esista prima di caricarlo
if [ -f "config/packages.conf" ]; then
  source config/packages.conf
else
  echo "❌ Errore: config/packages.conf non trovato!"
  exit 1
fi

echo "🛠️  [1/4] Aggiornamento Sistema CachyOS..."
# Aggiorna database e sistema. --noconfirm evita di chiedere "sì" a ogni passaggio
sudo pacman -Syu --noconfirm

# Uniamo le liste dai tuoi array in packages.conf
# Nota: Ho aggiunto sway_packages perché è il tuo obiettivo principale
all_packages=("${sys_packages[@]}" "${dev_packages[@]}" "${app_packages[@]}" "${sway_packages[@]}" "${font_packages[@]}")
echo "⬇️  Installazione pacchetti..."

# Invece del ciclo 'for', passiamo l'intera lista a pacman.
# --needed: Installa SOLO se il pacchetto manca o è obsoleto (sostituisce il tuo check dpkg)
# --noconfirm: Non chiedere conferma per procedere
if [ ${#all_packages[@]} -gt 0 ]; then
  sudo pacman -S --needed --noconfirm "${all_packages[@]}"
else
  echo "⚠️  Nessun pacchetto da installare nella lista."
fi

echo "✅  Operazioni di sistema completate."
