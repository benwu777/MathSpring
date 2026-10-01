# Boy hairstyle fit redesign

## Goal

Make each boy hairstyle look like it naturally belongs to every available boy
head shape.  Eliminate crown gaps, floating temples, disproportionate width,
and forehead/eyebrow collisions before expanding the hairstyle catalog.

## Scope

- Keep all girl assets and behavior unchanged.
- Keep the five existing boy face choices.
- First deliver three representative boy hairstyles: short hair, natural
  medium-short hair, and loose curls.
- Expand to the remaining seven only after visual acceptance.

## Fit model

Each hairstyle retains a common visual identity, but every `boy_face_01` to
`boy_face_05` pairing owns a fit record.  A record may set horizontal and
vertical offset, width and height scale, plus an asset variant when the
hairline, crown, or temple silhouette needs a small face-specific adjustment.

The preview resolver selects this record from both the active face ID and hair
ID.  The editor thumbnail continues to use the same `AvatarPreview` renderer,
so thumbnail and large preview always apply identical fitting rules.

## Visual acceptance

Create a 5 × 3 reviewer matrix showing every selected face paired with each
sample hairstyle at both thumbnail and main-preview sizes.  Every cell must
meet these conditions:

1. No empty gap at the crown or beside either temple.
2. The hairline is above the eyebrows and follows the forehead naturally.
3. Hair width and height are proportionate to the active head.
4. A hairstyle remains recognizably the same style across face variants.
5. Hair stays transparent outside the intended silhouette and leaves eyes
   unobstructed.

Automated tests protect assets, fit-record coverage, canonical transparency,
and use of the shared renderer.  Reviewer inspection is the acceptance gate
for natural visual fit; passing structural tests alone is not acceptance.
