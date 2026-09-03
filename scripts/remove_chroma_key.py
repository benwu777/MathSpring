import sys
from PIL import Image

src, dst = sys.argv[1], sys.argv[2]
soft = 70          # spill width that fades to transparent
img = Image.open(src).convert('RGB')
px = list(img.getdata())
out = []
for r, g, b in px:
    m = max(r, b)
    spill = g - m
    if spill <= 0:
        out.append((r, g, b, 255))
    elif spill >= soft:
        out.append((0, 0, 0, 0))
    else:
        a = int(255 * (1 - spill / soft))
        out.append((r, m, b, a))   # despill: green pulled down to red/blue level
res = Image.new('RGBA', img.size)
res.putdata(out)
res.save(dst)
print('wrote', dst)
