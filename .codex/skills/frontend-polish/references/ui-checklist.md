# UI Polish Checklist

Use this as a final pass for web apps.

## Layout

- No horizontal overflow at mobile width.
- Text wraps without clipping.
- Fixed-format UI elements have stable dimensions.
- Empty, loading, error, and success states are present when the flow needs them.
- Dense tools stay scannable; avoid oversized marketing composition inside operational screens.

## Interaction

- Buttons, links, tabs, toggles, and menus have clear hover/focus/disabled states.
- Forms show validation errors near the field.
- Keyboard focus does not disappear.
- Destructive actions are clear and reversible or confirmed.

## Visual System

- Reuse existing tokens, spacing, typography, and components.
- Use icons from the existing icon library.
- Avoid one-note palettes and decorative effects unrelated to the product.
- Cards are used for repeated items, modals, or framed tools only.

## Verification

- Check at least one desktop viewport and one mobile viewport.
- Run the narrowest useful automated check.
- Keep screenshots or notes when the change is visual.
