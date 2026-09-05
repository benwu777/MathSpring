#!/usr/bin/env python3
"""Split a painted hairstyle into a behind-the-face layer and a front layer.

Long styles (pigtails, long falls) were shipped as a single layer drawn on top
of everything, so the strands that should hang *behind* the cheeks covered them
instead.  Rather than repaint anything, this splits the existing artwork:

* back  = strands that sit outside the face-safe oval and below the fringe band
* front = everything else (crown, fringe, the strands that frame the face)

Both halves keep the original 1254x1254 canvas, so the widget stacks them with
no offset and the brush style is untouched.

Usage: python3 scripts/split_avatar_hair_layers.py girl/hair/hair-05 06
"""
import os
import sys
from PIL import Image, ImageChops, ImageDraw, ImageFilter

CANVAS = 1254
ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), os.pardir)

# 參考畫布上的臉部安全橢圓與瀏海帶（portrait-01.landmarks.json）
FACE = {'cx': .5, 'cy': .52, 'w': .46, 'h': .58}
# 只有明顯低於臉頰、且離臉夠遠的髮量才算「垂在臉後面」。
# 第一版用瀏海帶（.42）與臉緣（1.0 倍橢圓）當界線，結果把框住臉的髮絲
# 一起切進後層，太陽穴與臉頰旁出現缺口——那些髮絲本來就該在前面。
BACK_TOP = .60
FACE_PAD = 1.18


def _oval(pad):
    m = Image.new('L', (CANVAS, CANVAS), 0)
    x0 = (FACE['cx'] - FACE['w'] / 2 * pad) * CANVAS
    y0 = (FACE['cy'] - FACE['h'] / 2 * pad) * CANVAS
    x1 = (FACE['cx'] + FACE['w'] / 2 * pad) * CANVAS
    y1 = (FACE['cy'] + FACE['h'] / 2 * pad) * CANVAS
    ImageDraw.Draw(m).ellipse((x0, y0, x1, y1), fill=255)
    return m


def build_masks():
    """回傳（後層遮罩, 前層遮罩）。

    關鍵不變量：**任何蓋在臉上的頭髮像素都必須完整留在前層**。
    羽化過的邊界如果跨過臉緣，過渡帶上前後層各只有一半不透明度，
    而後層被臉擋住，淨結果就是頭髮在額頭變成半透明——第一版就是這樣壞的。

    所以前層遮罩最後要和「臉部橢圓內部」取聯集，把臉上的頭髮補回全不透明。
    """
    back = Image.new('L', (CANVAS, CANVAS), 0)
    ImageDraw.Draw(back).rectangle(
        (0, int(BACK_TOP * CANVAS), CANVAS, CANVAS), fill=255)
    back = Image.composite(Image.new('L', back.size, 0), back, _oval(FACE_PAD))
    back = back.filter(ImageFilter.GaussianBlur(10))

    front = back.point(lambda v: 255 - v)
    # 補回：臉上的頭髮一律全不透明地留在前層
    front = ImageChops.lighter(front, _oval(FACE_PAD + .04))
    return back, front


def split(rel_src, index):
    src = os.path.join(ROOT, 'assets', 'avatars', rel_src + '.png')
    img = Image.open(src).convert('RGBA')
    assert img.size == (CANVAS, CANVAS), '%s 不是 %d 見方' % (src, CANVAS)

    back_mask, front_mask = build_masks()
    alpha = img.getchannel('A')
    blank = Image.new('L', img.size, 0)

    back = img.copy()
    back.putalpha(Image.composite(alpha, blank, back_mask))
    front = img.copy()
    front.putalpha(Image.composite(alpha, blank, front_mask))

    part_dir = os.path.dirname(os.path.join(ROOT, 'assets', 'avatars', rel_src))
    back_path = os.path.join(part_dir, 'hair-%s-back.png' % index)
    front_path = os.path.join(part_dir, 'hair-%s.png' % index)
    back.save(back_path)
    front.save(front_path)
    for p in (front_path, back_path):
        print('%-46s %s' % (os.path.relpath(p, ROOT),
                            Image.open(p).getbbox()))


def main(argv):
    if len(argv) != 2:
        print(__doc__)
        return 1
    split(argv[0], argv[1])
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
