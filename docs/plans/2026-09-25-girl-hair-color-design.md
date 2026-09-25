# Girl hair color design

## Goal

Split the girl avatar's current single hair choice into a hairstyle and a
separate, reusable hair-color choice. Start with girls only.

## User experience

The avatar editor remains ordered by presentation, skin, hairstyle, hair
color, then facial features. The hair-color step offers six fixed swatches:
black, dark brown, chestnut, light brown, dark auburn, and silver gray.
Deep brown remains the default.

The large preview and hairstyle option thumbnails must render the same
configuration, so a chosen color is visible consistently in both places.

## Rendering and persistence

Existing transparent hairstyle PNGs remain the source of silhouette, alpha,
strand detail, and highlights. A centralized runtime color treatment maps the
source hair luminance to the selected color while preserving transparency and
light/dark detail. Both front and back hairstyle layers receive the same
treatment.

`AvatarConfiguration` gains a `hairColorId`. Legacy saved configurations that
lack it resolve to deep brown. The property persists alongside the other
avatar settings. The girl-only rendering path uses it; boys retain their
current assets and editor flow.

## Verification

Tests cover default migration, all six color IDs, color application to front
and back hair layers, and equality between the option thumbnail and the large
preview. Existing transparent-canvas and eye-clearance checks continue to run.
Finally, build MathSpringReviewer Release and inspect the paper-doll editor.
