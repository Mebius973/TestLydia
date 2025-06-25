[![codecov](https://codecov.io/gh/Mebius973/TestLydia/graph/badge.svg?token=HzloxhFipy)](https://codecov.io/gh/Mebius973/TestLydia)

# TestLydia

Ce projet est une proposition de réponse au test technique de Lydia.

Il propose une implémentation répondant au sujet, avec une architecture MVVM-C, en clean architecture, avec un cache local pour gérer les problèmes de connectivités ainsi que l'usage d'un NSCache pour les images.

Au-délà du sujet, ce projet contient également toutes une série de tests automatisés: Test UI et Unit Test.
Il contient également une CI.

La seule dépendance de ce projet est Factory, un injecteur de dépendance pratique et lisible.

# Test UI
Les test UI s'appuient sur mockserver, un serveur de mocks. Son usage permet d'effectuer des tests automatisés de haut niveau tout en conservant une prédictabilité des résultats.

Il faut le démarrer avant de lancer les tests UI, via le script launch_mockserver.sh.
Ce script démarre le serveur et charge les stubs présents dans TestStubs.
Il ne peut pas être intégré dans une build phase en raison du mode sandbox dans lequel s'exécute les tests.

# Mutations Testing

Ce projet est paramétré pour fonctionner avec [muter](https://github.com/muter-mutation-testing/muter).

Muter ne fait pas parti de la CI en raison du temps important de l'analyse mais pour l'utiliser localement, il suffit de

```
brew install muter-mutation-testing/formulae/muter
muter
```

Rapport:

| File                      | # of Introduced Mutants | Mutation Score |
|---------------------------|-------------------------|----------------|
| Coordinator.swift         | 2                       | 100            |
| CacheManager.swift        | 3                       | 100            |
| UserRepositoryImpl.swift  | 2                       | 100            |
| UserDetailCoordinator.swift | 2                     | 100            |
| UserListCoordinator.swift | 2                       | 100            |
| UserListViewModel.swift   | 5                       | 100            |
| UserEntity+Equatable.swift | 3                      | 100            |
| Helpers.swift             | 1                       | 100            |


Les vues sont volontairement exlues, l'idée étant surtout de tester la robustesse des tests qui concernent des composants contenant de la logique

# Pistes d'évolutions

Cette application utilise les UserDefaults pour gérer son cache.
En fonction de la volumétrie de cache, on pourrait soit utiliser CoreData pour composer avec un cache important ou choisir au contraire de limiter le cache.

En effectuant un travail spécifique sur la concurrence, on pourrait gagner du temps au niveau de l'exécution des tests.

On pourrait introduire tuist pour faciliter le travail colaboratif.

Côté fonctionnalité, on pourrait par exemple rajouter des filtres sur la liste déroulante.

Enfin, afin de rendre la CI portable et de gérer simplement la publication sur l'app store, on pourrait passer sur du fastlane.
