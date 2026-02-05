------------------------------------------------------------------------------------------------------
ATELIER FROM IMAGE TO CLUSTER
------------------------------------------------------------------------------------------------------
L’idée en 30 secondes : Cet atelier consiste à **industrialiser le cycle de vie d’une application** simple en construisant une **image applicative Nginx** personnalisée avec **Packer**, puis en déployant automatiquement cette application sur un **cluster Kubernetes** léger (K3d) à l’aide d’**Ansible**, le tout dans un environnement reproductible via **GitHub Codespaces**.
L’objectif est de comprendre comment des outils d’Infrastructure as Code permettent de passer d’un artefact applicatif maîtrisé à un déploiement cohérent et automatisé sur une plateforme d’exécution.
  
-------------------------------------------------------------------------------------------------------
Séquence 1 : Codespace de Github
-------------------------------------------------------------------------------------------------------
Objectif : Création d'un Codespace Github  
Difficulté : Très facile (~5 minutes)
-------------------------------------------------------------------------------------------------------
**Faites un Fork de ce projet**. Si besion, voici une vidéo d'accompagnement pour vous aider dans les "Forks" : [Forker ce projet](https://youtu.be/p33-7XQ29zQ) 
  
Ensuite depuis l'onglet [CODE] de votre nouveau Repository, **ouvrez un Codespace Github**.
  
---------------------------------------------------
Séquence 2 : Création du cluster Kubernetes K3d
---------------------------------------------------
Objectif : Créer votre cluster Kubernetes K3d  
Difficulté : Simple (~5 minutes)
---------------------------------------------------
Vous allez dans cette séquence mettre en place un cluster Kubernetes K3d contenant un master et 2 workers.  
Dans le terminal du Codespace copier/coller les codes ci-dessous etape par étape :  

**Création du cluster K3d**  
```
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
```
```
k3d cluster create lab \
  --servers 1 \
  --agents 2
```
**vérification du cluster**  
```
kubectl get nodes
```
**Déploiement d'une application (Docker Mario)**  
```
kubectl create deployment mario --image=sevenajay/mario
kubectl expose deployment mario --type=NodePort --port=80
kubectl get svc
```
**Forward du port 80**  
```
kubectl port-forward svc/mario 8080:80 >/tmp/mario.log 2>&1 &
```
**Réccupération de l'URL de l'application Mario** 
Votre application Mario est déployée sur le cluster K3d. Pour obtenir votre URL cliquez sur l'onglet **[PORTS]** dans votre Codespace et rendez public votre port **8080** (Visibilité du port).
Ouvrez l'URL dans votre navigateur et jouer !

---------------------------------------------------
Séquence 3 : Exercice
---------------------------------------------------
Objectif : Customisez un image Docker avec Packer et déploiement sur K3d via Ansible
Difficulté : Moyen/Difficile (~2h)
---------------------------------------------------  
Votre mission (si vous l'acceptez) : Créez une **image applicative customisée à l'aide de Packer** (Image de base Nginx embarquant le fichier index.html présent à la racine de ce Repository), puis déployer cette image customisée sur votre **cluster K3d** via **Ansible**, le tout toujours dans **GitHub Codespace**.  

**Architecture cible :** Ci-dessous, l'architecture cible souhaitée.   
  
![Screenshot Actions](Architecture_cible.png)   
  
---------------------------------------------------  
## Processus de travail (résumé)

1. Installation du cluster Kubernetes K3d (Séquence 1)
2. Installation de Packer et Ansible
3. Build de l'image customisée (Nginx + index.html)
4. Import de l'image dans K3d
5. Déploiement du service dans K3d via Ansible
6. Ouverture des ports et vérification du fonctionnement

---------------------------------------------------
Séquence 4 : Documentation  
Difficulté : Facile (~30 minutes)
---------------------------------------------------
**Complétez et documentez ce fichier README.md** pour nous expliquer comment utiliser votre solution.  
Faites preuve de pédagogie et soyez clair dans vos expliquations et processus de travail.  
   
---------------------------------------------------
Evaluation
---------------------------------------------------
Cet atelier, **noté sur 20 points**, est évalué sur la base du barème suivant :  
- Repository exécutable sans erreur majeure (4 points)
- Fonctionnement conforme au scénario annoncé (4 points)
- Degré d'automatisation du projet (utilisation de Makefile ? script ? ...) (4 points)
- Qualité du Readme (lisibilité, erreur, ...) (4 points)
- Processus travail (quantité de commits, cohérence globale, interventions externes, ...) (4 points) 

----------------------------------------------------
### ***Documentation pour la séquence 3 ***
### Partie sans automatisation pour comprendre :
## L'étape 1 : Installation du cluster Kubernetes K3d (Séquence 1)
C'est expliqué dans la séquence 1 & 2. 

## L'étape 2 : Installation de Packer et Ansible
On commence par installer les outils. Pour cela un fichier bash a été crée pour faciliter les installations : install_tools.sh.
On lance juste le fichier bash avec la commande suivante : ```./install_tools.sh".```

## L'étape 3 : Build de l'image customisée (Nginx + index.html)
Avec builder Docker de Packer on va built l'image. Pour cela, un fichier "image.pkr.hcl" a été créé. Il suffit de l'exécuter maintenant avec les commandes suivantes pour built : 
```
packer init image.pkr.hcl
packer build image.pkr.hcl
```

## L'étape 4 : Import de l'image dans K3d
Avant qu'Ansible ne puisse déployer, le cluster doit connaître l'image. On fait donc l'import avec la commande suivante : 
``` k3d image import mon-nginx-custom:v1 -c lab ```

## L'étape 5 : Déploiement du service dans K3d via Ansible
Un fichier YAML "deploy-nginx.yml" a été créé pour le déploiement du service. 
Pour lancer le déploiement il suffit de lancer la commande suivante : 
``` ansible-playbook deploy-nginx.yml" ```

## L'étape 6 : Portforward
On lance la commande suivante : 
``` kubectl port-forward svc/nginx-service 8081:80 >/tmp/maison.log 2>&1 & ```

## L'étape 7 : 
Pour obtenir votre URL cliquez sur l'onglet **[PORTS]** dans votre Codespace et rendez public votre port **8081** (Visibilité du port).
Ouvrez l'URL dans votre navigateur. 

### Partie avec automatisation pour tester :
Un fichier cleanEnv.sh a été créé pour nettoyer l'environnement afin de tester le fichier qui répond à l'exercice.
Un fichier missionComplete.sh a été créé pour faire toutes les séquences afin de répondre à l'exercice. 
Pour effectuer les deux fichiers il faut exécuter sur le terminal les deux commandes suivantes : 
```
./cleanEnv.sh
./missionComplete.sh".
```



