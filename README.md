## Blok Africa - Système de Produits & Favoris 

Ce projet est une application mobile avancée réalisée pour Blok Africa. Il ne s'agit plus seulement d'un prototype UX, mais d'une application fonctionnelle intégrant une persistence de données locale et une communication avec un serveur distant (API).

## Objectifs de la Mission 

* Architecture Data-Driven : Connecter l'interface à une API réelle pour récupérer dynamiquement les produits et catégories.

* Persistance Locale : Implémenter SQLite pour sauvegarder les favoris de manière permanente, même après fermeture de l'application.

* Optimisation de la Performance : Utilisation de "Skeleton Loaders" pour améliorer la perception de vitesse durant les appels réseau.

* UX Avancée : Gestion des états vides (Empty States) avec des designs personnalisés pour une expérience utilisateur sans friction.

## Fonctionnalités implémentées

* Consommation d'API : Récupération asynchrone des données produits et détails via un service dédié.

* Recherche & Filtrage : Filtrage dynamique par nom, prix et catégories directement sur la page produit.

* Système de Favoris SQLite : CRUD complet (Create, Read, Delete) sur une base de données locale.

* Interface Réactive : Mise à jour instantanée des icônes de favoris sur tous les écrans grâce à la synchronisation des états.

* Feedback Visuel : SnackBars personnalisées pour confirmer les actions utilisateur.

## Structure de l'Application (4 Écrans)

* Page d'acceuil : Tableau de bord principal avec accès aux modules.

* pages des produits : Catalogue complet avec recherche intelligente, filtres par catégories et skeleton loading.

* page de details du produit : Vue immersive avec gestion de la description (gestion du cas "description vide") et toggle favori.

* Page des favoris : Gestionnaire de sauvegarde avec un état vide illustré.

## Stack Technique

* Framework : Flutter 

* Base de données : SQLite pour la persistance locale.

* Réseau : http pour les appels API asynchrones.

* Animations : AnimationController pour les effets de chargement (shimmer/fade).

* UI : Custom Material Design respectant les codes couleurs blokBlue (#1D264F) et blokOrange (#FF8C00).

## Explications Techniques

# Architecture logicielle
Le projet suit une architecture Layered Architecture (Architecture en couches), permettant une séparation nette des responsabilités :

* Couche Vue (UI) : Définie dans pages/. Les widgets sont "dumb" ou gèrent leur état local via setState. Ils ne connaissent pas l'origine des données.

* Couche Service (Data) :

api_service.dart : Gère la communication distante (entrée/sortie des données via API).

database_helper.dart : Gère la persistance locale via le pattern Singleton.

* Couche Modèle : product.dart définit la structure de l'objet métier, incluant des méthodes de sérialisation (fromMap, toMap) pour convertir les données entre l'API (JSON), la base de données (Map) et l'interface (Objet).

# Gestion des appels API et Asynchronisme
L'application utilise le modèle Future-based asynchrony :

* Performance : Utilisation de Future.wait([...]) pour lancer plusieurs appels (Catégories + Produits + Favoris) en parallèle au démarrage. Cela réduit le temps de chargement total par rapport à des appels séquentiels.

* UX : Durant l'attente des données, des Skeleton Loaders (ou Shimmer effect) animés via un AnimationController sont affichés pour éviter les écrans vides brusques et améliorer la patience perçue de l'utilisateur.

# Choix Techniques & Persistance
* SQLite (sqflite) : Choisi pour le système de favoris car il permet une persistance robuste et des requêtes complexes. Contrairement à shared_preferences, il permet de stocker des objets entiers et de garantir l'intégrité des données après redémarrage du téléphone.

* State Management local : L'utilisation de setState a été privilégiée pour ce prototype afin de garder un code léger et rapide à exécuter, tout en garantissant une réactivité immédiate lors du clic sur le bouton "Favoris".

* Filtrage côté client : Pour garantir une fluidité maximale, le filtrage par nom ou par prix s'effectue directement sur la liste chargée en mémoire, offrant une réponse instantanée à l'utilisateur sans latence réseau supplémentaire.

## Organisation des fichiers (Nouvelle structure)

lib/
├── main.dart                 # Configuration du thème et de la navigation
├── models/
│   └── product.dart          # Modèle de données avec mapping JSON/Map
├── pages/
│   ├── home_page.dart        # Accueil et navigation principale
│   ├── product_page.dart     # Catalogue dynamique (API + Filtres)
│   ├── details_page.dart     # Fiche produit détaillée
│   └── favorites_page.dart   # Liste des produits sauvegardés (SQLite)
├── services/
│   ├── api_service.dart      # Communication avec le serveur distant
│   └── database_helper.dart  # Gestionnaire de la base de données SQLite
└── utils/
    └── constants.dart        # Variables globales et charte graphique

## Installation et Lancement

# Cloner le dépôt :
* git clone git@github.com:francisyao8/blokafrica_mobile.git

# Installer les dépendances :
* flutter pub get

# Lancer l'application :
* flutter run -d chrome #pour lancher sur chrome
