---
name: frontend-polish
description: Audit and polish React, Next.js, Vue, Angular, or web UI screens. Use when the user says "polish cette page", "verifie l'UI", "audit responsive", "rends ca propre", "frontend polish", "check mobile/desktop", or asks for final UI quality before delivery.
---

# Frontend Polish

Use this skill to turn an implemented screen into a shippable interface. Focus on real UI behavior, responsiveness, accessibility basics, and consistency with the existing app.

## Workflow

1. Understand the target screen.
   - Find routes, components, data flow, styling system, and tests.
   - Reuse existing design conventions before inventing new UI.
   - If the user gave a Figma node, screenshot, or URL, compare against it.

2. Run or inspect the app.
   - Prefer existing scripts from `package.json`.
   - Start the dev server when needed.
   - Use Browser tooling for local pages when available.

3. Check desktop and mobile.
   - Inspect at least one desktop viewport and one mobile viewport.
   - Look for overflow, clipped text, bad wrapping, layout jumps, broken hover/focus states, empty states, loading states, and contrast issues.

4. Fix narrowly.
   - Make the smallest defensible changes.
   - Preserve component boundaries.
   - Avoid unrelated refactors.
   - Do not create marketing-style layouts for operational tools.

5. Validate.
   - Run the narrowest useful checks: lint, typecheck, unit tests, build, or browser verification.
   - Capture screenshots when visual evidence matters.

6. Report.
   - Mention changed files.
   - Mention validations run.
   - Mention anything not verified.

## Design Bias

- React/Next projects: prefer existing components, CSS variables, Tailwind tokens, or design-system primitives.
- SaaS/admin/CRM tools: keep layouts dense, calm, and scannable.
- Cards: use only for repeated items, modals, or framed tools.
- Text: ensure it fits on mobile and desktop.
- Icons: use the app's icon library, often `lucide-react`, when present.

## Reference

Read `references/ui-checklist.md` when the task is broad or before final delivery.
