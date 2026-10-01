# Boy short-hair fixed-template design

## Goal

Validate a fixed face-template approach with one natural short hairstyle before
redesigning the rest of the boy hairstyle catalog.

## Scope

Only `boy_hair_01` and the five boy face shapes are in scope.  Girl assets and
all other boy hairstyles remain unchanged until this sample is accepted.

## Asset approach

Create one short-hair layer for each `boy_face_01` through `boy_face_05`.
Each layer uses the face's fixed crown arc, forehead hairline, temple width,
and ear-side termination.  The five layers retain the same natural-short-hair
identity; only the silhouette required for head fit may differ.

No placement tuning is used to hide an incorrect silhouette.  The shared
renderer selects the correct layer by the active face ID and hair ID, so the
option tile and main preview use the exact same result.

## Acceptance

At main-preview and tile sizes, every face pairing must have continuous crown
coverage, naturally connected temple sides, a hairline above the eyebrows,
proportionate width and height, and no eye obstruction.  The user accepts all
five pairings before another hairstyle is redesigned.
