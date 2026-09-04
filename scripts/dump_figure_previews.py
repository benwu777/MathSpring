#!/usr/bin/env python3
"""把題庫裡的圖渲染成 PNG，讓人真的看一眼。

驗證器只能檢查 params 的形狀對不對，看不出畫出來好不好看、標籤有沒有疊在一起、
輔助線是不是跑到框外。這支腳本從真實題包挑題、寫出 figspec.json，
再驅動 test/figure_preview_test.dart 用 app 自己的 buildFigureRenderSpec 畫圖。

用法:
  python3 scripts/dump_figure_previews.py --kind composite_grid_shape
  python3 scripts/dump_figure_previews.py --id geometry_grade9_foundation_009 --id ...
  python3 scripts/dump_figure_previews.py --grade grade9 --out /tmp/figs
  python3 scripts/dump_figure_previews.py --all           # 全部有圖的題

不給 --out 就寫到 tmp 目錄，路徑會印在最後一行。
"""
import argparse
import glob
import json
import os
import subprocess
import sys
import tempfile

WITH_FIGURE = lambda q: (q.get('figure') or {}).get('kind') not in (None, 'none')


def load_questions():
    out = []
    for path in sorted(glob.glob('assets/questions/*/*.json')):
        with open(path) as fh:
            out.extend(json.load(fh)['questions'])
    return out


def select(questions, ids, kinds, grades, take_all):
    picked = []
    for q in questions:
        if not WITH_FIGURE(q):
            continue
        if take_all:
            picked.append(q)
        elif ids and q['id'] in ids:
            picked.append(q)
        elif kinds and q['figure']['kind'] in kinds:
            picked.append(q)
        elif grades and q.get('levelStage') in grades:
            picked.append(q)
    return picked


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('--id', action='append', default=[], help='題號，可重複')
    ap.add_argument('--kind', action='append', default=[], help='figure kind，可重複')
    ap.add_argument('--grade', action='append', default=[], help='levelStage，可重複')
    ap.add_argument('--all', action='store_true', help='全部有圖的題')
    ap.add_argument('--out', help='輸出資料夾（預設開一個 tmp 目錄）')
    args = ap.parse_args()

    if not (args.id or args.kind or args.grade or args.all):
        ap.error('至少要給 --id / --kind / --grade / --all 其中一個')

    picked = select(load_questions(), set(args.id), set(args.kind),
                    set(args.grade), args.all)
    if not picked:
        print('沒有符合條件的題目', file=sys.stderr)
        return 1

    out = args.out or tempfile.mkdtemp(prefix='mathspring-figs-')
    os.makedirs(out, exist_ok=True)
    spec = [{'id': q['id'], 'kind': q['figure']['kind'],
             'params': q['figure']['params']} for q in picked]
    with open(os.path.join(out, 'figspec.json'), 'w') as fh:
        json.dump(spec, fh, ensure_ascii=False, indent=2)

    # 一併寫一份題號對照，看圖時才知道每張圖在問什麼
    with open(os.path.join(out, 'index.txt'), 'w') as fh:
        for q in picked:
            fh.write('%s  [%s]  %s\n' % (q['id'], q['figure']['kind'],
                                         q['prompt']['zh-Hant']))

    env = dict(os.environ, FIG_DIR=out)
    r = subprocess.run(['flutter', 'test', 'test/figure_preview_test.dart'],
                       env=env, capture_output=True, text=True)
    if r.returncode != 0:
        sys.stdout.write(r.stdout)
        sys.stderr.write(r.stderr)
        return r.returncode
    print('%d 張圖 -> %s' % (len(picked), out))
    return 0


if __name__ == '__main__':
    sys.exit(main())
