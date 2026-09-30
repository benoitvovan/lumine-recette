# Conventions d'équipe — agents de code (Codex)

Ce fichier est la **source de vérité d'équipe** pour Codex, distribuée dans chaque
dépôt projet. Il est le pendant de `CLAUDE.md` (Claude Code) : mêmes conventions,
chargées nativement par Codex. Les règles (TypeScript, Python, sécurité, archi) sont
**fondues ici** — pas de dossier `rules/` séparé.

L'`AGENTS.md` d'un projet peut compléter ou surcharger ce fichier ; en cas de
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
- **TypeScript strict** : typer les frontières (props, retours publics, API).
  Éviter `any` ; préférer `unknown` + narrowing. Réutiliser les types partagés.
- **React** : composants purs et composables ; state minimal et colocalisé ;
  effets seulement pour la synchronisation externe. Respecter les règles des hooks.
- **Next.js** : Server Components par défaut, `"use client"` seulement si nécessaire ;
  pas de secret côté client ; data fetching côté serveur ; frontière server/client nette.
- **Style** : réutiliser design system / tokens / Tailwind existants avant d'inventer.
  Accessibilité de base (sémantique, focus, contraste, labels).

## Node.js / Prisma
- Routes/handlers fins, logique métier isolée, accès données via Prisma dans une couche dédiée.
- **Prisma** : migrations versionnées ; pas de requête brute non paramétrée ;
  `select` explicite ; attention aux N+1 ; transactions pour les writes multi-tables.
- Valider les entrées à la frontière avant la couche métier.
- Gérer les erreurs explicitement ; pas d'erreur avalée silencieusement.

## Python
- Type hints aux frontières ; fonctions courtes à responsabilité unique.
- Pas de valeur d'environnement en dur ; config centralisée + `.env` optionnel.
- Un cas nominal, un cas d'erreur, un cas limite couverts.

## Sécurité (base, non négociable)
- **Zéro secret dans le repo.** Secrets dans un `.env` local (gitignoré) ; ne versionner
  qu'un **`.env.example`** avec des placeholders.
- Valider/échapper toute entrée non fiable ; requêtes paramétrées ; pas d'exécution
  de commande avec une entrée utilisateur.
- Vérifier authentification **et** autorisation sur chaque route/mutation sensible.
- Pas de secret ni de PII dans les logs ou les réponses d'erreur.

## Architecture (principes génériques)
- Responsabilité unique ; modules courts ; dépendances vers le stable.
- Config-driven : pas de magic value.
- Dépendances minimales et justifiées.
- Robustesse : chemins d'erreur pensés, pas seulement le chemin nominal.

## Skills & hooks Codex
- Skills Codex : `.codex/skills/` (miroir des skills Claude Code).
- Hooks Codex : `.codex/hooks/` — scripts fournis mais **non câblés automatiquement**
  (le câblage est propre à la config locale). Voir l'en-tête de chaque script.
  - `auto-check.sh` : relance typecheck + tests si du code a changé.

## Serveur MCP d'équipe
Le fichier `.mcp.json` déclare le serveur MCP de l'équipe. **Le jeton reste par dev**
(`${LUMINE_AGENT_TOKEN}`) — jamais de token dans le repo.
