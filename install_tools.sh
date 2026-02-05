#!/bin/bash

# Couleurs pour la lisibilité
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== Début de l'installation des outils (Packer & Ansible) ===${NC}"

# Mise à jour des certificats et outils de base
sudo apt-get update
sudo apt-get install -y gnupg software-properties-common curl wget

# --- INSTALLATION DE PACKER ---
echo -e "${GREEN}Configurant le dépôt Hashicorp pour Packer...${NC}"
if [ ! -f /usr/share/keyrings/hashicorp-archive-keyring.gpg ]; then
    wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
fi

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

# --- INSTALLATION D'ANSIBLE ---
echo -e "${GREEN}Ajout du PPA Ansible...${NC}"
sudo add-apt-repository --yes --update ppa:ansible/ansible

# --- MISE À JOUR ET INSTALLATION FINALE ---
echo -e "${GREEN}Installation des paquets...${NC}"
sudo apt-get update
sudo apt-get install -y packer ansible

# --- VÉRIFICATION ---
echo -e "${BLUE}=== Vérification des versions ===${NC}"
packer --version
ansible --version

echo -e "${GREEN}Terminé ! Tes outils sont prêts pour la mission.${NC}"
