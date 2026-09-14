# MathSpring Visual System Design

## Direction

MathSpring will use a compact, light learning-workspace style. It should feel
calm and dependable rather than playful: warm off-white backgrounds, near-black
text, and a restrained teal-blue accent. The interface should make the current
question, progress, and next action obvious before decorative elements.

## Foundations

- **Canvas:** warm off-white with very light cool-gray surfaces.
- **Accent:** teal-blue, reserved for the primary action, selected navigation,
  progress, focus, and positive status.
- **Semantic feedback:** muted red for errors and muted amber for warnings;
  neither competes with the primary accent.
- **Type:** clear hierarchy with strong headings, compact supporting text, and
  tabular figures for scores and counts.
- **Surfaces:** 12--14 px rounded corners, a fine border, and one faint shadow.
  Large pill shapes, heavy borders, gradients, and decorative glows are removed.
- **Icons:** rounded, outline Material icons in a single visual language.
  Selected states use accent colour, not filled icon variants.

## Screen Rules

- The home page centres the learner summary and a single continuation action.
  Secondary destinations use quiet, compact section surfaces.
- Practice and quiz screens prioritise account identity, progress, prompt,
  answer choices, and the favourite control. Feedback is concise and uses a
  narrow semantic treatment rather than a large coloured block.
- Profile, analysis, and favourites share one page-header hierarchy: back,
  title, then contextual actions. On iPhone, favourite collections are chosen
  with a dropdown; wider layouts may use a sidebar.
- Avatar editing keeps the preview above direct part tabs. The selection grid
  keeps stable cell sizing and visible asset identifiers.

## Interaction and Responsiveness

- Content is compact but every interactive target remains at least 48 px on a
  phone and 56 px on wider layouts.
- The visual system must work at compact, medium, and expanded width classes.
  It must never cause bottom actions to be obscured.
- Loading, empty, locked, and error states use the same icon, short message,
  and one optional action. Transitions are limited to brief fades or small
  position changes (150--200 ms).

## Acceptance

- No hard-coded legacy blue remains in common components or primary flows.
- Cards, buttons, fields, navigation, and icon buttons use shared theme rules.
- Practice, quiz, profile editing, analysis, and favourites remain legible on
  small iPhones and do not overflow on iPad.
- Widget tests cover theme semantics and key layout states; manual simulator
  review covers all three width classes.
