# Conventions d'équipe — agents de code (Claude Code)

Ce fichier est la **source de vérité d'équipe** distribuée dans chaque dépôt projet.
Il définit comment les agents (Claude Code) travaillent chez nous. Les conventions
(TypeScript, Python, sécurité, archi) sont **fondues ici** — il n'y a pas de dossier
`rules/` séparé.

Le `CLAUDE.md` d'un projet peut compléter ou surcharger ce fichier ; en cas de
conflit, le fichier du projet gagne pour ce qui lui est spécifique.

## Langue & communication
- Répondre et commenter en **français**.
- Réponses courtes et directes ; développer seulement si la tâche le demande.
- Expliquer le *pourquoi* d'un choix non trivial, pas seulement le *quoi*.

## Exigences qualité (avant de livrer)
- Lancer les vérifications les plus étroites et utiles : **lint, typecheck, tests, build**.
- Ne pas déclarer une tâche finie si un check est red : le dire et montrer la sortie.
- Faire les changements les plus petits et défendables ; éviter les refactors non demandés.
- Respecter les conventions du code alentour (nommage, style, densité de commentaires).
- Couvrir le comportement changé par un test quand c'est pertinent.

## TypeScript / React / Next.js
- **TypeScript strict** : typer les frontières (props, retours de fonctions publiques,
  API). Éviter `any` ; préférer `unknown` + narrowing. Réutiliser les types partagés.
- **React** : composants purs et composables ; state minimal et colocalisé ;
  effets seulement pour la synchronisation externe (pas pour dériver du state).
  Respecter les règles des hooks. Clés de liste stables.
- **Next.js** : Server Components par défaut, `"use client"` seulement si nécessaire ;
  pas de secret côté client ; data fetching côté serveur ; respecter la frontière
  server/client. Ne pas mettre de logique métier dans les composants.
- **Style** : réutiliser les primitives du design system / tokens CSS / Tailwind
  existants avant d'inventer. Accessibilité de base (sémantique, focus, contraste,
  labels). Voir les skills `frontend-design` et `frontend-polish`.

## Node.js / Prisma
- Séparer les couches : routes/handlers fins, logique métier isolée, accès données
  via Prisma dans une couche dédiée.
- **Prisma** : migrations versionnées ; pas de requête brute non paramétrée ;
  sélectionner explicitement les champs (`select`) plutôt que tout remonter ;
  attention aux N+1 (utiliser `include`/batching). Transactions pour les writes
  multi-tables.
- Valider les entrées à la frontière (ex. schéma de validation) avant la couche métier.
- Gérer les erreurs explicitement ; ne pas avaler une erreur silencieusement.

## Python
- Type hints aux frontières ; fonctions courtes à responsabilité unique.
- Pas de valeur d'environnement en dur ; config centralisée + `.env` optionnel.
- Un cas nominal, un cas d'erreur, un cas limite couverts.
- Commentaires pédagogiques sur la logique non évidente.

## Sécurité (base, non négociable)
- **Zéro secret dans le repo.** Clés, tokens, mots de passe restent dans un `.env`
  local (gitignoré) ; ne versionner qu'un **`.env.example`** avec des placeholders.
- Valider et échapper toute entrée non fiable ; requêtes paramétrées ;
  pas d'`eval`/exécution de commande avec une entrée utilisateur.
- Vérifier authentification **et** autorisation sur chaque route/mutation sensible
  (pas d'IDOR). Pas de contrôle d'accès uniquement côté client.
- Pas de secret ni de PII dans les logs ou les réponses d'erreur.
- Un hook `anti-secret` est fourni (`.claude/hooks/anti-secret.mjs`) — voir « Hooks ».

## Architecture (principes génériques)
- Responsabilité unique ; modules courts ; dépendances qui pointent vers le stable.
- Config-driven : pas de magic value ; la configuration est explicite.
- Dépendances minimales et justifiées ; préférer la plateforme/lib déjà présente.
- Robustesse : chemins d'erreur pensés, pas seulement le chemin nominal.

## Rôles de revue (avant livraison)
Deux agents de revue **read-only** sont fournis dans `.claude/agents/` :
- **`qualite-code`** : lisibilité, typage, complexité, duplication, config-driven.
- **`securite`** : injection, validation, authz, désérialisation, secrets, fuites.

Les lancer avant de livrer une tâche non triviale. Un finding **BLOQUANT** doit
être levé avant la livraison.

## Hooks (fournis, non activés automatiquement)
Les scripts de hooks vivent dans `.claude/hooks/` mais **ne s'activent pas seuls** :
le câblage vit dans `.claude/settings.json` (non distribué). Pour les activer dans
un projet, ajouter le câblage indiqué en tête de chaque script :
- **`anti-secret.mjs`** (PreToolUse `Write|Edit`) : bloque l'écriture d'un secret
  ou d'un `.env` réel dans un fichier versionné.
- **`auto-check.sh`** (Stop) : relance typecheck + tests si du code a changé.
  Adapter `WATCHED_PATHS`, `TYPECHECK_CMD`, `TEST_CMD` à la stack du projet.

## Serveur MCP d'équipe
Le fichier `.mcp.json` déclare le serveur MCP de l'équipe. **Le jeton reste par dev**
(variable d'environnement `${LUMINE_AGENT_TOKEN}`) — jamais de token dans le repo.
