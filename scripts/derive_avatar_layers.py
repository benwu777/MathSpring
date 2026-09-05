#!/usr/bin/env python3
"""Derive avatar layers by locally reshaping an existing, already aligned layer.

Every option in a part must own a real layer file.  New shapes are produced by
moving a handful of control points on an accepted layer instead of generating a
fresh illustration: the brush style stays identical and, because the source is
already registered against the reference canvas, the result cannot drift.

Rules the presets below obey:

* The canvas stays 1254x1254 and transparent.  Nothing is cropped or rescaled.
* Anchors pin the parts that must not move -- the crown, the eye band for a
  face reshape, the brow line for an eye reshape, and both eye centres so the
  left/right spacing never changes.
* Only one part moves per preset.  A face preset never touches the eyes; an eye
  preset never touches the brows.
* Movements are shape changes (jaw width, lid curve, nostril spread, lip
  corners), never a uniform scale -- a scale is what these layers replace.

Usage:
    python3 scripts/derive_avatar_layers.py          # regenerate every layer
    python3 scripts/derive_avatar_layers.py girl_face_02 ...
"""
import os
import subprocess
import sys

CANVAS = 1254
ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), os.pardir)


def asset(path):
    return os.path.normpath(os.path.join(ROOT, 'assets', 'avatars', path))


# Landmarks measured from the accepted reference layers.
GIRL_EYES = ((392, 641), (862, 641))
BOY_EYES = ((420, 624), (834, 624))
FACE_ANCHORS = [(627, 300), (627, 560), (320, 560), (935, 560)]
BROW_ANCHORS = [(300, 520), (627, 520), (954, 520)]


def eye_moves(centres, top, bottom, outer, inner, dy_top, dy_bottom,
              dy_outer=0, dy_inner=0):
    """Reshape both eyes symmetrically around their fixed centres."""
    moves = []
    for index, (cx, cy) in enumerate(centres):
        outward = -1 if index == 0 else 1
        moves.append((cx, top, 0, dy_top))
        moves.append((cx, bottom, 0, dy_bottom))
        if dy_outer:
            moves.append((cx + outward * outer, cy, 0, dy_outer))
        if dy_inner:
            moves.append((cx - outward * inner, cy, 0, dy_inner))
    return moves


def eye_anchors(centres):
    return BROW_ANCHORS + [(cx, cy) for cx, cy in centres]


PRESETS = {
    # ---- face shapes: reshape the jaw and cheeks, never the eye band -------
    'girl/base/face-02.png': dict(
        src='girl/base/face-01.png', anchors=FACE_ANCHORS,
        moves=[(272, 820, 42, 0), (982, 820, -42, 0),
               (300, 900, 40, 0), (955, 900, -40, 0), (627, 1025, 0, 30)]),
    'girl/base/face-03.png': dict(
        src='girl/base/face-01.png', anchors=FACE_ANCHORS,
        moves=[(264, 820, -38, 0), (990, 820, 38, 0),
               (300, 890, -30, 0), (955, 890, 30, 0), (627, 1020, 0, -30)]),
    'girl/base/face-04.png': dict(
        src='girl/base/face-01.png', anchors=FACE_ANCHORS,
        moves=[(300, 900, -45, 0), (955, 900, 45, 0),
               (430, 990, -25, 10), (825, 990, 25, 10), (627, 1020, 0, -8)]),
    'girl/base/face-05.png': dict(
        src='girl/base/face-01.png', anchors=FACE_ANCHORS,
        moves=[(300, 900, 55, 0), (955, 900, -55, 0),
               (430, 985, 45, 0), (825, 985, -45, 0), (627, 1025, 0, 18)]),
    'boy/base/base-02.png': dict(
        src='boy/base/base-01.png', anchors=FACE_ANCHORS,
        moves=[(232, 830, 46, 0), (1022, 830, -46, 0),
               (270, 900, 44, 0), (984, 900, -44, 0), (627, 1005, 0, 32)]),
    'boy/base/base-03.png': dict(
        src='boy/base/base-01.png', anchors=FACE_ANCHORS,
        moves=[(224, 830, -40, 0), (1030, 830, 40, 0),
               (270, 890, -32, 0), (984, 890, 32, 0), (627, 1000, 0, -30)]),
    'boy/base/base-04.png': dict(
        src='boy/base/base-01.png', anchors=FACE_ANCHORS,
        moves=[(270, 890, -48, 0), (984, 890, 48, 0),
               (430, 975, -28, 10), (825, 975, 28, 10), (627, 1000, 0, -8)]),
    'boy/base/base-05.png': dict(
        src='boy/base/base-01.png', anchors=FACE_ANCHORS,
        moves=[(270, 890, 58, 0), (984, 890, -58, 0),
               (430, 970, 48, 0), (825, 970, -48, 0), (627, 1005, 0, 20)]),

    # ---- eye shapes: lid curve and corner tilt, spacing untouched ----------
    'girl/eyes/eyes-03.png': dict(   # rounder, wider open
        src='girl/eyes/eyes-01.png', anchors=eye_anchors(GIRL_EYES),
        moves=eye_moves(GIRL_EYES, 598, 716, 118, 118, -20, 18)),
    'girl/eyes/eyes-04.png': dict(   # narrow almond
        src='girl/eyes/eyes-01.png', anchors=eye_anchors(GIRL_EYES),
        moves=eye_moves(GIRL_EYES, 598, 716, 118, 118, 22, -18)),
    'girl/eyes/eyes-05.png': dict(   # upturned outer corners
        src='girl/eyes/eyes-01.png', anchors=eye_anchors(GIRL_EYES),
        moves=eye_moves(GIRL_EYES, 598, 716, 118, 118, -6, 4, -24, 12)),
    'boy/eyes/eyes-02.png': dict(    # rounder, wider open
        src='boy/eyes/eyes-01.png', anchors=eye_anchors(BOY_EYES),
        moves=eye_moves(BOY_EYES, 588, 682, 126, 126, -18, 16)),
    'boy/eyes/eyes-03.png': dict(    # narrow almond
        src='boy/eyes/eyes-01.png', anchors=eye_anchors(BOY_EYES),
        moves=eye_moves(BOY_EYES, 588, 682, 126, 126, 18, -14)),
    'boy/eyes/eyes-04.png': dict(    # upturned outer corners
        src='boy/eyes/eyes-01.png', anchors=eye_anchors(BOY_EYES),
        moves=eye_moves(BOY_EYES, 588, 682, 126, 126, -5, 3, -22, 10)),
    'boy/eyes/eyes-05.png': dict(    # downturned outer corners
        src='boy/eyes/eyes-01.png', anchors=eye_anchors(BOY_EYES),
        moves=eye_moves(BOY_EYES, 588, 682, 126, 126, -5, 3, 22, -8)),

    # ---- nose shapes: bridge length and nostril spread ---------------------
    'girl/nose/nose-03.png': dict(   # wider nostrils
        src='girl/nose/nose-01.png', anchors=[(627, 630), (627, 680)],
        moves=[(588, 706, -13, 0), (666, 706, 13, 0), (627, 718, 0, 4)]),
    'girl/nose/nose-04.png': dict(   # longer, straighter bridge
        src='girl/nose/nose-01.png', anchors=[(627, 630)],
        moves=[(627, 645, 0, -14), (588, 706, 5, 6), (666, 706, -5, 6)]),
    'girl/nose/nose-05.png': dict(   # small upturned button
        src='girl/nose/nose-01.png', anchors=[(627, 630)],
        moves=[(627, 645, 0, 16), (588, 706, 8, -6), (666, 706, -8, -6),
               (627, 718, 0, -10)]),
    'boy/nose/nose-03.png': dict(    # wider nostrils
        src='boy/nose/nose-01.png', anchors=[(627, 580), (627, 640)],
        moves=[(570, 676, -16, 0), (684, 676, 16, 0), (627, 688, 0, 5)]),
    'boy/nose/nose-04.png': dict(    # longer, straighter bridge
        src='boy/nose/nose-01.png', anchors=[(627, 580)],
        moves=[(627, 600, 0, -16), (570, 676, 6, 8), (684, 676, -6, 8)]),
    'boy/nose/nose-05.png': dict(    # small upturned button
        src='boy/nose/nose-01.png', anchors=[(627, 580)],
        moves=[(627, 600, 0, 18), (570, 676, 10, -7), (684, 676, -10, -7),
               (627, 688, 0, -12)]),

    # ---- boy mouth shapes: lip corners and opening ------------------------
    'boy/mouth/mouth-03.png': dict(  # broad open smile
        src='boy/mouth/mouth-01.png', anchors=[(627, 620)],
        moves=[(516, 663, -22, -6), (738, 663, 22, -6), (627, 690, 0, 14)]),
    'boy/mouth/mouth-04.png': dict(  # small pressed lips
        src='boy/mouth/mouth-01.png', anchors=[(627, 620)],
        moves=[(516, 663, 34, 0), (738, 663, -34, 0), (627, 690, 0, -12),
               (627, 636, 0, 6)]),
    'boy/mouth/mouth-05.png': dict(  # gentle upturned smile
        src='boy/mouth/mouth-01.png', anchors=[(627, 620), (627, 663)],
        moves=[(516, 663, 6, -20), (738, 663, -6, -20), (627, 690, 0, -4)]),
}


def derive(name, preset):
    points = []
    for x, y, dx, dy in preset['moves']:
        points.append('%d,%d %d,%d' % (x, y, x + dx, y + dy))
    corners = [(0, 0), (CANVAS, 0), (0, CANVAS), (CANVAS, CANVAS)]
    for x, y in list(preset.get('anchors', ())) + corners:
        points.append('%d,%d %d,%d' % (x, y, x, y))

    subprocess.run([
        'magick', asset(preset['src']),
        '-alpha', 'set', '-virtual-pixel', 'transparent',
        '-define', 'shepards:power=%s' % preset.get('power', 3.0),
        '-distort', 'Shepards', ' '.join(points),
        asset(name),
    ], check=True)
    print('derived %s from %s' % (name, preset['src']))


def main(argv):
    wanted = argv or sorted(PRESETS)
    for name in wanted:
        key = name if name in PRESETS else None
        if key is None:
            matches = [k for k in PRESETS if name in k]
            if len(matches) != 1:
                raise SystemExit('unknown layer: %s' % name)
            key = matches[0]
        derive(key, PRESETS[key])


if __name__ == '__main__':
    main(sys.argv[1:])
