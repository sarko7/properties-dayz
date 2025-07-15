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
- Comment représenter les shells ? (nom, enums ?)
- Est-ce que chaque propriété est chargée au démarrage du serveur ?
- Est-ce que je stocke des données côté joueur ? Si oui, où ?
- Quand est-ce que je sauve les changements (achat, entrée, etc.) ?

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
