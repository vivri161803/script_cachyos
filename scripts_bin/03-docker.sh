#!/bin/bash
# scripts_bin/04-docker.sh

echo "🐳 [4/4] Installazione Docker su CachyOS..."

# 1. Installazione pacchetti
# Su Arch 'docker' è nei repo ufficiali. Non servono chiavi GPG o repo esterni.
# docker-compose: il plugin moderno (v2)
# docker-buildx: per build multi-architettura (spesso richiesto da script moderni)
echo "    ⬇️  Installazione pacchetti Docker..."
sudo pacman -S --needed --noconfirm docker docker-compose docker-buildx

# 2. Attivazione Servizio (DIFFERENZA CRUCIALE DA UBUNTU)
# Su Ubuntu il demone parte da solo. Su Arch devi abilitarlo esplicitamente.
# --now: avvia il servizio immediatamente E lo abilita al boot.
echo "    🔌 Abilitazione docker.service..."
sudo systemctl enable --now docker.service

# 3. Configurazione Gruppo Utente
# Permette di usare docker senza 'sudo'
echo "    👤 Aggiunta utente al gruppo docker..."
# Il gruppo 'docker' viene creato automaticamente dall'installazione del pacchetto
sudo usermod -aG docker "$USER"

echo "✅ Installazione completata."
echo "⚠️  NOTA: Devi effettuare il LOGOUT e LOGIN (o riavviare) affinché il gruppo docker funzioni!"
