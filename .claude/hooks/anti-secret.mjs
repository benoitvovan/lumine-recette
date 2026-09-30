#!/usr/bin/env node
// Hook PreToolUse (Write|Edit) — garde-fou anti-secret d'équipe.
// Bloque l'écriture d'un secret, ou d'un fichier d'environnement réel, dans un emplacement versionné.
// Protocole : lit le JSON du hook sur stdin ; exit 2 = bloquer (raison sur stderr) ; exit 0 = autoriser.
// Fail-open en cas d'erreur de parsing (ne casse jamais un edit légitime).
//
// Activation (non distribuée automatiquement) — à câbler dans .claude/settings.json du projet :
//   "hooks": { "PreToolUse": [ { "matcher": "Write|Edit",
//     "hooks": [ { "type": "command", "command": "node .claude/hooks/anti-secret.mjs" } ] } ] }

import { readFileSync } from "node:fs";

function lireStdin() {
  try {
    return readFileSync(0, "utf8");
  } catch {
    return "";
  }
}

let data;
try {
  data = JSON.parse(lireStdin() || "{}");
} catch {
  process.exit(0); // fail-open
}

const input = data.tool_input ?? data.toolInput ?? {};
const chemin = String(input.file_path ?? input.path ?? "").replace(/\\/g, "/");
const contenu = String(input.content ?? input.new_string ?? input.new_str ?? "");

function bloque(raison) {
  process.stderr.write(`⛔ anti-secret : ${raison}\n`);
  process.exit(2);
}

// 1) Fichier .env réel (pas .env.example) : pas d'édition via l'agent.
if (/(^|\/)\.env(\.[A-Za-z0-9]+)?$/.test(chemin) && !/\.env\.example$/.test(chemin)) {
  bloque(`édition d'un fichier d'environnement (${chemin}). Les secrets restent locaux ; ne versionne que .env.example avec des placeholders.`);
}

// 2) Motifs de secret dans le contenu écrit.
const motifs = [
  /sk-[A-Za-z0-9]{16,}/,            // clés type OpenAI
  /AKIA[0-9A-Z]{16}/,               // AWS access key id
  /ghp_[A-Za-z0-9]{36}/,            // GitHub personal access token
  /-----BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY-----/, // clé privée
  /(api[_-]?key|secret|token|bearer|password)\s*[:=]\s*['"][A-Za-z0-9_\-\.]{16,}['"]/i,
];
for (const m of motifs) {
  if (m.test(contenu)) {
    bloque(`un secret potentiel a été détecté dans le contenu. Mets-le dans un .env local, jamais dans un fichier versionné.`);
  }
}

process.exit(0);
