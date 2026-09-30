#!/usr/bin/env bash
# .claude/hooks/auto-check.sh
#
# Stop hook : à la fin d'un turn Claude Code, si des fichiers de code ont été
# modifiés, lance automatiquement typecheck + tests. Évite d'oublier de vérifier
# avant de livrer.
#
# Conventions Claude Code :
#   - stdin reçoit du JSON sur le contexte du Stop ; on y lit `stop_hook_active`
#     pour casser la boucle (cf. garde anti-loop ci-dessous).
#   - stdout n'est renvoyé au modèle que si exit != 0 + stdout non vide.
#       - exit 0 silencieux si tout va bien
#       - exit 2 + message stdout si un check est red, pour signaler à l'agent
#
# Détails : https://docs.claude.com/claude-code/hooks
#
# Activation (non distribuée automatiquement) — à câbler dans .claude/settings.json :
#   "hooks": { "Stop": [ { "hooks": [ { "type": "command",
#     "command": "bash .claude/hooks/auto-check.sh" } ] } ] }
#
# Toggle off : `export SKIP_AUTO_CHECK=1` dans la session, ou retirer la clé
# `hooks` de .claude/settings.json.
#
# Adapter par projet : WATCHED_PATHS (zones de code surveillées) et les
# commandes de check (TYPECHECK_CMD / TEST_CMD) selon la stack.

set -u

# Garde anti-boucle : Claude Code passe `"stop_hook_active": true` quand ce hook
# s'exécute suite à un Stop hook précédent. Sans cette garde, un check red
# relancerait le hook à chaque fin de tour → boucle sans fin.
STOP_CTX=$(cat 2>/dev/null || true)
case "$STOP_CTX" in
  *'"stop_hook_active":true'* | *'"stop_hook_active": true'*)
    exit 0
    ;;
esac

# Skip explicite (utile quand on debug le hook lui-même).
if [ "${SKIP_AUTO_CHECK:-0}" = "1" ]; then
  exit 0
fi

# Skip si on n'est pas dans un repo git.
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  exit 0
fi

# Zones de code surveillées (adapter selon le projet).
WATCHED_PATHS="src app lib"
if git diff --quiet HEAD -- $WATCHED_PATHS 2>/dev/null \
  && [ -z "$(git ls-files --others --exclude-standard $WATCHED_PATHS 2>/dev/null)" ]; then
  exit 0
fi

# Il y a des modifs dans le code surveillé : on lance les checks.
cd "$(git rev-parse --show-toplevel)" || exit 0

# Commandes de check (surchargeable par projet via l'environnement).
TYPECHECK_CMD="${TYPECHECK_CMD:-pnpm tsc --noEmit}"
TEST_CMD="${TEST_CMD:-pnpm test}"

# Typecheck d'abord. Si red, on report et on stoppe avant les tests.
TSC_OUT=$($TYPECHECK_CMD 2>&1)
if [ $? -ne 0 ]; then
  echo "[auto-check] ❌ typecheck red — corrige les erreurs ci-dessous avant de continuer."
  echo "$TSC_OUT" | tail -40
  exit 2
fi

# Tests.
TEST_OUT=$($TEST_CMD 2>&1)
if [ $? -ne 0 ]; then
  echo "[auto-check] ❌ tests red — corrige les erreurs ci-dessous avant de continuer."
  echo "$TEST_OUT" | tail -40
  exit 2
fi

exit 0
