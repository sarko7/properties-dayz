# 🏠 Exercice Complet – Système de Propriétés pour FiveM

## 🎯 Objectif global

Créer un système complet de gestion de propriétés dans FiveM (backend et client) avec les fonctionnalités suivantes :

- Création de propriétés dynamiques avec UUID
- Choix d’intérieur (shell)
- Configuration de points (stockage, panneau de vente)
- Système d’achat ou de location
- Classe `Property` et instanciation des propriétés
- Instanciation des joueurs entrant dans une propriété
- Freecam restreinte à l’intérieur du shell pour le housing
- Optimisation (performance, stockage, sécurité)

---

## 📋 Plan de travail

### 1. ✨ Création de propriété

- [ ] Génération d’un identifiant **unique** (UUIDv4)
- [ ] Numéro d’habitation (ex: "25")
- [ ] Nom d’affichage = **nom de la rue**
- [ ] Choix de l’**intérieur** (`shell`) parmi une liste définie
- [ ] Position personnalisée pour le **stockage**
  - ❗ *Tu dois seulement émettre un `TriggerEvent("property:storageAccess")` pour simuler l'accès*
- [ ] Position du **panneau "à vendre / à louer"**
  - Il doit **disparaître une fois la maison vendue ou louée**
- [ ] Propriété peut être **vendue ou louée**

### 2. 📦 Classe `Property`

Crée une classe orientée objet côté serveur pour représenter une propriété.

> 🧠 **Réflexion à avoir :**
> - Comment représenter différents types de propriété ?
> - Comment créer une méthode propre pour instancier une propriété à partir de données DB ?
> - Que doivent faire les méthodes `Enter()` ou `Exit()` côté serveur et client ?

### 🔧 Voie d’amélioration future :

- Créer une **classe parent `Property`**, et des **classes enfants** :
  - `HouseProperty`, `ApartmentProperty`, etc.  
  Ces classes auront des méthodes spécifiques.

---

### 3. 🚪 Entrée dans la propriété (instanciation joueur)

- [ ] Quand un joueur ent
- [ ] Gérer la téléportation dans le shell

---

### 4. 🎥 Housing - Freecam (client)

- [ ] Activer une freecam limitée dans les murs du shell
- [ ] Empêcher la caméra de **sortir de la propriété**
- [ ] Utiliser une **liste prédéfinie de props** pour les tests (pas besoin de faire une liste de 10k props)
- [ ] Réfléchir à la persistence des données

---

### 5. 💳 Achat / Location

- [ ] Permettre à un joueur d’acheter ou louer une propriété
- [ ] Supprimer le panneau une fois l’achat effectué

---

## 📦 Stockage & Base de Données (à concevoir)

> ❗ C’est ici que tu réfléchis.  
> Ne code rien tant que tu n’as pas répondu à ces questions :

### 🤔 Questions à te poser

- Quelles données dois-je stocker ? (propriétés, type, position, owner, etc.)
  - UUID : id de la propriété (clé unique)
  - type : Appartement, garage, maison, entrepôt (pour gérer les spécificités en fonction du type)
  - owner : licence du joueur
  - position : point d'entrée (extérieur), panneau d'information (le reste est géré en config)
  - shellName : nom du shell qui permet d'aller rechercher des informations en configuration (position de sortie, poids du coffre, position de gestion, position du coffre)
  - statut : owned (acheté), rental (un locataire y réside), vacant (libre à l'achat et à la visite)
  - rentalDeadline : la date au quelle le logement sera remis a la vente ou a la location 
  - address : l'adresse où se trouve la propriété
- Comment représenter les shells ? (nom, enums ?)
  - Je représenterais personnellement les shells sous forme de string (leur nom)
- Est-ce que chaque propriété est chargée au démarrage du serveur ?
  - Oui, les propriétés sont chargées quand le côté serveur démarre, il fetch toutes les données et les met sous forme d'instances d'une classe (appelée Property)
- Est-ce que je stocke des données côté joueur ? Si oui, où ?
  - Oui, après le fetch côté serveur, les données nécessaires (les coords, le statut, l'adresse)
- Quand est-ce que je sauve les changements (achat, entrée, etc.) ?
  - Pour sauvegarder les informations, cela dépend : l'achat, je le fais directement via une requête SQL, et tout ce qui dépend de la propriété elle-même. Pour les actions comme entrer/sortir, je get les données via un callback, pour éviter les exploits

> ✍️ _Écris tes structures de données en Lua ici ou dans `/docs/db_structure.md`_
---

## 🔒 Sécurité

Tout événement entre client et serveur doit être :
- Validé côté serveur (ownership, permissions)
- Sanitisé (pas de coordonnées modifiables par client sans vérif)
- Résistant aux exploits (tentatives d’entrer sans payer, etc.)

---

## 🔧 Voies d’amélioration (niveau avancé)

- [ ] Ajouter un système d’immeubles avec **propriétés enfants** (appartements)
- [ ] Possibilité d’avoir plusieurs locataires / colocs
- [ ] Système de gestion via menu

---

## ✅ Livrables attendus

- Code modulaire et commenté
- Structure des classes propre (`Property`, etc.)
- Pas de dépendance à ESX/QBCore (standalone)
- Performance mesurée (indicateur si possible)

---
