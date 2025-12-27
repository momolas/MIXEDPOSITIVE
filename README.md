# MIXEDPOSITIVE

MIXEDPOSITIVE est un assistant de jardinage biodynamique et d'astronomie pour iOS. L'application utilise des calculs astronomiques précis pour fournir des conseils de jardinage basés sur les cycles lunaires et les signes du zodiaque.

## Fonctionnalités

*   **Phases Lunaires** : Visualisation précise de la phase actuelle de la lune (Nouvelle lune, Premier quartier, Pleine lune, etc.).
*   **Guide de Jardinage** : Indication du type de jour pour le jardinage (Racine, Feuille, Fleur, Fruit) selon le calendrier biodynamique.
*   **Données Astronomiques** :
    *   Tendance lunaire (Croissante / Décroissante)
    *   Trajectoire (Montante / Descendante)
    *   Nœuds lunaires (Ascendant / Descendant)
    *   Signe du zodiaque lunaire
*   **Calendrier** : Vue mensuelle pour planifier vos activités de jardinage.
*   **Notifications** : Rappels pour les événements importants comme la Pleine Lune.

## Technologies

*   **Langage** : Swift 6.2+
*   **Interface** : SwiftUI
*   **Architecture** : MVVM avec `@Observable` et Concurrence Swift stricte (`@MainActor`).
*   **Bibliothèque Astronomique** : [SwiftAA](https://github.com/onekiloparsec/SwiftAA) pour les calculs d'éphémérides.

## Prérequis

*   iOS 26.0 ou version ultérieure.
*   Xcode avec support du SDK iOS 26.

## Installation

1.  Clonez ce dépôt.
2.  Ouvrez `MIXEDPOSITIVE.xcodeproj` dans Xcode.
3.  Laissez Xcode résoudre les dépendances (SwiftAA via Swift Package Manager).
4.  Compilez et lancez sur votre simulateur ou appareil.
