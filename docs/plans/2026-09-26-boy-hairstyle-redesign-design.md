# Boy hairstyle redesign

## Goal

Replace the current boy hairstyle set with ten visibly distinct, natural
everyday hairstyles for the paper-doll avatar.

## Direction

The set mixes approachable school-age cuts with a small amount of clean,
modern styling. It deliberately excludes dyed two-tone hair, braids, and
novelty styling. The ten silhouettes are: buzz cut, short textured crop,
side-parted short hair, short loose curls, fluffy curls, fringe crop, short
pompadour, natural medium-short hair, tapered side cut, and a low-key bun.

## Asset contract

Each option keeps its stable `boy_hair_01` through `boy_hair_10` identifier,
uses a 1254×1254 transparent PNG canvas, contains hair only, and leaves the
eyes visible. Assets must be differentiated by silhouette, parting, length,
texture, or volume rather than small changes to the same haircut. Where a
style needs hair behind the face, it must use the existing front/back layer
convention.

## Verification

Inspect each asset individually and composited with the boy face. Run the
avatar catalog, preview, editor, and visual-matrix tests; check thumbnail and
large preview consistency in MathSpringReviewer Release.
