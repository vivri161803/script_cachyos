# 🚀 CachyOS x Sway: Lenovo T490 Edition

![OS](https://img.shields.io/badge/OS-CachyOS-00C9FF?style=for-the-badge&logo=archlinux)
![WM](https://img.shields.io/badge/Window_Manager-Sway-green?style=for-the-badge)
![Backup DE](https://img.shields.io/badge/Backup_DE-XFCE-blue?style=for-the-badge)
![Editor](https://img.shields.io/badge/Editor-Neovim-57A143?style=for-the-badge&logo=neovim)

Una suite di automazione Bash completa per trasformare un'installazione pulita di **CachyOS** in una workstation da sviluppo ad alte prestazioni, ottimizzata specificamente per il **Lenovo ThinkPad T490**.

Il progetto configura un ambiente ibrido robusto:
1.  **Sway (Wayland):** Daily driver leggero, veloce e ottimizzato per il tiling.
2.  **XFCE (X11):** Ambiente di backup stabile e leggero per le emergenze.

---

## 💻 Hardware Target

Sebbene gli script funzionino sulla maggior parte dei sistemi x86_64, le configurazioni sono ottimizzate per:

* **Machine:** Lenovo ThinkPad T490
* **CPU:** Intel Core i5/i7 (8th Gen - x86-64-v3 support)
* **GPU:** Intel UHD 620
* **Input:** TrackPoint & Touchpad (Gesture abilitate)

## 🛠️ Lo Stack Tecnologico

| Componente | Scelta | Note |
| :--- | :--- | :--- |
| **Distro** | CachyOS (Arch Based) | Repository ottimizzati V3/V4, Kernel BORE |
| **WM** | Sway | Configurazione "Vim-like" |
| **Backup DE** | XFCE4 | Senza bloatware, solo l'essenziale |
| **Bar** | Waybar | Stile Catppuccin, moduli custom |
| **Terminal** | Kitty | GPU accelerated |
| **Shell** | Bash + Starship | Prompt reattivo e moderno |
| **Editor** | Neovim | Configurazione LazyVim pre-caricata |
| **Launcher** | Wofi | App menu rapido |
| **Notifications** | Mako | Minimalista e leggero |
| **Login Manager** | SDDM | Supporto Wayland/X11 |

---

## 📂 Struttura del Progetto

```text
.
├── config/
│   └── packages.conf      # Lista centralizzata dei pacchetti (Sys, Dev, Sway, XFCE)
├── scripts_bin/
│   ├── 01-system.sh       # Aggiornamento CachyOS e installazione pacchetti base/XFCE
│   ├── 02-nvim.sh         # Setup Neovim & LazyVim
│   ├── 04-docker.sh       # Docker engine (senza root)
│   ├── 05-fonts.sh        # Installazione NerdFonts (JetBrainsMono)
│   ├── 06-starship.sh     # Setup prompt shell
│   ├── 07-sway-install.sh # Dipendenze specifiche Sway (Polkit, Qt Wayland)
│   └── 08-sway-config.sh  # Generazione automatica dotfiles (Config, Waybar, Wofi)
├── setup.sh               # Orchestrator principale
└── README.md

```

---

## ⚡ Installazione

### 1. Prerequisiti

Installa **CachyOS** (versione Desktop o Online Installer).

* Durante l'installazione, crea il tuo utente.
* Puoi installare senza DE (solo terminale) o con un DE minimale. Gli script installeranno tutto il necessario.

### 2. Setup Rapido

Apri il terminale, clona la repo ed esegui l'installer:

```bash
# 1. Clona la repository
git clone [https://github.com/TUO_USERNAME/cachyos-t490-setup.git](https://github.com/TUO_USERNAME/cachyos-t490-setup.git)
cd cachyos-t490-setup

# 2. Rendi eseguibile lo script principale
chmod +x setup.sh

# 3. Lancia il setup
./setup.sh

```

### 3. Post-Installazione

1. Riavvia il sistema: `sudo reboot`
2. Alla schermata di login (SDDM), seleziona **Sway** in basso a sinistra (o *XFCE Session* se necessario).

---

## 🎹 Comandi Rapidi (Cheat Sheet)

La configurazione di Sway è mappata per essere intuitiva sul T490.

* **Tasto Mod:** `Super` (Tasto Windows)

| Azione | Shortcut |
| --- | --- |
| **Apri Terminale** | `Mod` + `Enter` |
| **Launcher App** | `Mod` + `d` |
| **Chiudi Finestra** | `Mod` + `q` |
| **Menu Uscita/Spegni** | `Mod` + `Shift` + `e` |
| **Ricarica Sway** | `Mod` + `Shift` + `r` |
| **Screenshot (Area)** | `Mod` + `Shift` + `s` |
| **File Manager (Term)** | `Mod` + `Enter` -> digita `mc` o `yazi` |

### Tasti Funzione T490

* `F1` / `F2` / `F3`: Volume (Mute/Down/Up)
* `F5` / `F6`: Luminosità Schermo

---

## ⚠️ Note Importanti

* **Configurazioni:** Lo script `08-sway-config.sh` sovrascrive i file in `~/.config/sway`, `waybar`, ecc. Fai un backup se hai configurazioni esistenti.
* **XFCE:** Viene installato come rete di sicurezza. Se Sway dovesse rompersi dopo un aggiornamento aggressivo di Arch, puoi fare logout e rientrare in XFCE per risolvere il problema.

## 📜 Crediti

Creato per massimizzare la produttività su hardware "Real Metal".
