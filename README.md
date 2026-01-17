
# Blok Africa - Système de Favoris (Prototype UX)
Ce projet est une extension de l'application Blok Africa, réalisée dans le cadre d'une mission de conception et de prototypage mobile. L'objectif principal est d'améliorer l'engagement utilisateur en intégrant une fonctionnalité de gestion des favoris.

# Objectifs de la Mission
* Concevoir une fonctionnalité à forte valeur ajoutée (Favoris).

* Prototyper une interface fluide avec au moins 3 écrans fonctionnels.

* Optimiser l'UX (Expérience Utilisateur) via des micro-interactions.

* Développer un code propre et maintenable en Flutter.

# Fonctionnalités implémentées
* Parcours fluide : Navigation intuitive entre l'accueil, les détails et les favoris.

* Gestion dynamique des Favoris : Ajout et retrait de produits en temps réel (State Management).

* Micro-interactions : Changement d'état visuel du bouton cœur (feedback immédiat).

* UI/UX Fidèle : Respect scrupuleux de la charte graphique (Bleu institutionnel & Orange d'action).

# Structure du Prototype (3 Écrans)
* Home Page : Grille de produits avec accès rapide aux catégories et marquage des favoris.

* Details Page : Informations complètes sur le produit avec possibilité de toggle favori.

* Favorites Page : Liste récapitulative des produits sauvegardés par l'utilisateur.

# Stack Technique
* Framework : Flutter 

* Langage : Dart

* Composants : Widgets Material Design personnalisés.

* Gestion d'état : StatefulWidget & setState pour une interactivité fluide.

* Stockage (Simulation) : Liste globale persistante durant la session.

# Installation et Lancement

Pour tester le prototype localement :

* Cloner le dépôt :
git clone git@github.com:francisyao8/blokafrica_mobile.git

* Installer les dépendances :
flutter pub get

* Lancer l'application :
 flutter run

# Organisation des fichiers

lib/
├── main.dart                 # Point d'entrée et configuration de la navigation
├── models/
│   └── product.dart          # Structure de données (Classe Product)
├── pages/
│   ├── home_page.dart        # Interface d'accueil (Grille dynamique)
│   ├── details_page.dart     # Vue détaillée et gestion des interactions
│   └── favorites_page.dart   # Gestionnaire visuel des coups de cœur
├── services/
│   └── database_helper.dart  # Logique de persistance (SQLite/Local Storage)
└── utils/
    ├── constants.dart        # Charte graphique (Couleurs Blok Africa)
    └── data_manager.dart     # Gestionnaire de flux de données (Logique métier)