#!/bin/bash

# Couleurs pour le suivi
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${RED}=== NETTOYAGE COMPLET DE L'ENVIRONNEMENT ===${NC}"

# 1. Arrêt de tous les tunnels port-forward (libère les ports 8080 et 8081)
echo -e "${YELLOW}Arrêt des processus kubectl port-forward...${NC}"
killall kubectl 2>/dev/null

# 2. Suppression du cluster K3d
echo -e "${YELLOW}Suppression du cluster K3d 'lab'...${NC}"
k3d cluster delete lab 2>/dev/null

# 3. Suppression des images Docker locales (Packer)
echo -e "${YELLOW}Suppression des images Docker personnalisées...${NC}"
docker rmi mon-nginx-custom:v1 2>/dev/null
docker image prune -f 2>/dev/null

# 4. Désinstallation des outils (pour tester l'étape d'installation du script)
echo -e "${YELLOW}Désinstallation de Packer et Ansible...${NC}"
sudo apt-get remove -y packer ansible 2>/dev/null
sudo rm -f /etc/apt/sources.list.d/hashicorp.list

# 5. Nettoyage des logs temporaires
echo -e "${YELLOW}Nettoyage des fichiers logs...${NC}"
rm -f /tmp/mario.log /tmp/maison.log

echo -e "${RED}=== NETTOYAGE TERMINÉ ===${NC}"
echo -e "Vos fichiers sources (.html, .yml, .pkr.hcl) sont intacts."
echo -e "Vous pouvez maintenant lancer : ./mission_complete_finale.sh"
