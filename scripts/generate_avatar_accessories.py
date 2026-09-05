#!/usr/bin/env python3
"""Draw the eyewear layers on the shared avatar canvas.

Eyewear is the one part that is better drawn than derived: it is a geometric
object (two lens outlines, a bridge, two temples), so a generated layer looks
cleaner than any warp of hand-drawn art and lands exactly on the eye centres
recorded in `assets/avatars/girl/reference/portrait-01.landmarks.json`.

Every layer uses the same 1254x1254 transparent canvas as the face layers, so
the widget stacks it without any offset.

Usage: python3 scripts/generate_avatar_accessories.py
"""
import os
from PIL import Image, ImageDraw

CANVAS = 1254
OUT = os.path.join(
    os.path.dirname(os.path.abspath(__file__)), os.pardir,
    'assets', 'avatars', 'shared', 'accessory')

# 來自參考畫布的臉部座標（比例）
LEFT_EYE = (0.41, 0.51)
RIGHT_EYE = (0.59, 0.51)
FACE_LEFT = 0.27
FACE_RIGHT = 0.73

FRAME = (0x2B, 0x2B, 0x33, 255)      # 鏡框深灰
FRAME_LIGHT = (0x6B, 0x5A, 0x46, 255)  # 眼鏡用的暖褐色框
LENS_CLEAR = (0xE8, 0xF2, 0xF8, 46)  # 透明鏡片的微反光
LENS_DARK = (0x1C, 0x24, 0x30, 214)  # 墨鏡


def px(v):
    return v * CANVAS


def draw_eyewear(name, *, shape, frame_colour, lens_fill, lens_w=0.088,
                 lens_h=0.076, thickness=0.011):
    img = Image.new('RGBA', (CANVAS, CANVAS), (0, 0, 0, 0))
    # 4 倍超取樣再縮回來，邊緣才不會有鋸齒
    ss = 4
    big = Image.new('RGBA', (CANVAS * ss, CANVAS * ss), (0, 0, 0, 0))
    d = ImageDraw.Draw(big)
    t = max(1, int(px(thickness) * ss))

    boxes = []
    for cx, cy in (LEFT_EYE, RIGHT_EYE):
        x0 = (cx - lens_w) * CANVAS * ss
        y0 = (cy - lens_h) * CANVAS * ss
        x1 = (cx + lens_w) * CANVAS * ss
        y1 = (cy + lens_h) * CANVAS * ss
        boxes.append((x0, y0, x1, y1))
        if shape == 'round':
            d.ellipse((x0, y0, x1, y1), fill=lens_fill, outline=frame_colour,
                      width=t)
        else:
            r = int((x1 - x0) * 0.18)
            d.rounded_rectangle((x0, y0, x1, y1), radius=r, fill=lens_fill,
                                outline=frame_colour, width=t)

    # 鼻樑：只連接兩個鏡片的內側，畫在鏡片中心高度。
    # 第一版畫在 lens_h*0.35 的高度，結果和鏡腳連成一條貫穿的橫線。
    bridge_y = LEFT_EYE[1] * CANVAS * ss
    d.line((boxes[0][2], bridge_y, boxes[1][0], bridge_y), fill=frame_colour,
           width=t)

    # 鏡腳：從鏡片外側往臉緣延伸。畫在鏡片中心高度，略微上揚；
    # 因為配件圖層在瀏海之前繪製，鏡腳多半會被頭髮蓋掉，這是正確的遮擋關係。
    for box, edge in ((boxes[0], FACE_LEFT), (boxes[1], FACE_RIGHT)):
        outer_x = box[0] if edge == FACE_LEFT else box[2]
        y = LEFT_EYE[1] * CANVAS * ss
        d.line((outer_x, y, edge * CANVAS * ss, y - px(0.018) * ss),
               fill=frame_colour, width=t)

    img = big.resize((CANVAS, CANVAS), Image.LANCZOS)
    path = os.path.join(OUT, name)
    img.save(path)
    print('%-28s %dx%d' % (os.path.basename(path), img.width, img.height))


def main():
    os.makedirs(OUT, exist_ok=True)
    draw_eyewear('glasses-round.png', shape='round',
                 frame_colour=FRAME_LIGHT, lens_fill=LENS_CLEAR)
    draw_eyewear('glasses-square.png', shape='square',
                 frame_colour=FRAME, lens_fill=LENS_CLEAR)
    # 墨鏡壓低一點：第一版 lens_h=0.070 會蓋到眉毛，看起來像護目鏡。
    draw_eyewear('sunglasses.png', shape='square',
                 frame_colour=FRAME, lens_fill=LENS_DARK,
                 lens_w=0.090, lens_h=0.058, thickness=0.011)


if __name__ == '__main__':
    main()
