#!/bin/bash

# Couleurs pour le suivi
CYAN='\033[0;36m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}=== 1. PRÉPARATION DU CLUSTER ===${NC}"
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
k3d cluster delete lab 2>/dev/null
k3d cluster create lab --servers 1 --agents 2

echo -e "${CYAN}=== 2. DÉPLOIEMENT MARIO (SÉQUENCE 2) ===${NC}"
kubectl create deployment mario --image=sevenajay/mario
kubectl expose deployment mario --type=NodePort --port=80

echo -e "${BLUE}=== 3. INSTALLATION TOOLS & BUILD PACKER (SÉQUENCE 3) ===${NC}"
chmod +x install_tools.sh
./install_tools.sh
packer init image.pkr.hcl
packer build image.pkr.hcl

echo -e "${BLUE}=== 4. IMPORT IMAGE ET DÉPLOIEMENT ANSIBLE ===${NC}"
k3d image import mon-nginx-custom:v1 -c lab
ansible-playbook deploy-nginx.yml

echo -e "${CYAN}=== 5. ATTENTE DU DÉMARRAGE DES PODS (CRITIQUE) ===${NC}"
echo "Vérification de l'état des Pods..."
# On attend que le pod Nginx soit prêt avant de forwarder
kubectl wait --for=condition=Ready pod -l app=nginx-custom --timeout=60s

echo -e "${GREEN}=== 6. ACTIVATION DES TUNNELS RÉSEAU ===${NC}"
# Nettoyage des anciens tunnels
killall kubectl 2>/dev/null

# Lancement des tunnels vers le background
kubectl port-forward svc/mario 8080:80 >/tmp/mario.log 2>&1 &
kubectl port-forward svc/nginx-service 8081:80 >/tmp/maison.log 2>&1 &

sleep 2 # Petit temps pour laisser les tunnels s'établir

echo -e "${GREEN}==================================================${NC}"
echo -e "${GREEN}   MISSION TERMINÉE AVEC SUCCÈS !${NC}"
echo -e "${GREEN}==================================================${NC}"
echo -e "Vérification des accès :"
echo -e "- Mario (Port 8080)  : $(curl -Is localhost:8080 | head -n 1 || echo 'Pas encore prêt')"
echo -e "- Maison (Port 8081) : $(curl -Is localhost:8081 | head -n 1 || echo 'Pas encore prêt')"
echo -e ""
echo -e "Si les ports n'apparaissent pas dans l'onglet PORTS :"
echo -e "Cliquez sur 'Forward a Port' et ajoutez manuellement 8080 et 8081."