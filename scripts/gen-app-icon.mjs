#!/usr/bin/env node
// 用 codex 產 App 圖示候選。提示詞唯一來源：docs/app-icon-prompts.md。
//
// 用法：
//   node scripts/gen-app-icon.mjs --out <資料夾>           # 產全部缺的候選
//   node scripts/gen-app-icon.mjs --out <資料夾> --only sprout
//   node scripts/gen-app-icon.mjs --out <資料夾> --force   # 已有檔案也重產
//
// 驗收（全域 CLAUDE.md 的產圖規則）：比對 mtime 確認真的有寫檔、尺寸必須 1024×1024、
// 四個角必須完全不透明（iOS 圖示不能有透明像素）。失敗的列在最後的「要重做」清單。
import { execFileSync } from 'node:child_process';
import { existsSync, mkdirSync, readFileSync, statSync } from 'node:fs';
import path from 'node:path';

const repo = path.resolve(path.dirname(new URL(import.meta.url).pathname), '..');
const args = process.argv.slice(2);
const outDir = path.resolve(args[args.indexOf('--out') + 1]);
const only = args.includes('--only') ? args[args.indexOf('--only') + 1] : null;
const force = args.includes('--force');

const doc = readFileSync(path.join(repo, 'docs/app-icon-prompts.md'), 'utf8');
const common = doc.split('## 共同要求')[1].trim();
const candidates = [...doc.matchAll(/## 候選 (\w+)\n\n([\s\S]*?)(?=\n## )/g)]
  .map(([, id, body]) => ({ id, body: body.trim() }))
  .filter(({ id }) => !only || id === only);

mkdirSync(outDir, { recursive: true });
const redo = [];

function inspect(file) {
  // sips 量尺寸；magick 讀四角 alpha（先轉 8-bit RGBA 再讀）。
  const dims = execFileSync('sips', ['-g', 'pixelWidth', '-g', 'pixelHeight', file]).toString();
  const w = Number(/pixelWidth: (\d+)/.exec(dims)[1]);
  const h = Number(/pixelHeight: (\d+)/.exec(dims)[1]);
  const corners = [[0, 0], [w - 1, 0], [0, h - 1], [w - 1, h - 1]].map(([x, y]) =>
    Number(execFileSync('magick', [file, '-depth', '8', '-alpha', 'on', '-format',
      `%[fx:int(255*p{${x},${y}}.a)]`, 'info:']).toString()));
  return { w, h, corners };
}

for (const { id, body } of candidates) {
  const file = path.join(outDir, `${id}.png`);
  if (existsSync(file) && !force) {
    console.log(`skip ${id}（已存在）`);
    continue;
  }
  const before = existsSync(file) ? statSync(file).mtimeMs : 0;
  const prompt = [
    '不要反問，直接執行。遇到任何選擇自行採用最合理的做法。',
    `請產生一張圖片並存成 ${file}（覆寫既有檔案）。`,
    '產好後用 sips -z 1024 1024 調成 1024×1024，並確保整張圖完全不透明。',
    '',
    body,
    '',
    common,
  ].join('\n');
  console.log(`gen ${id} …`);
  try {
    // 輸出資料夾通常不是 git 專案，不加 --skip-git-repo-check 會被 codex 直接拒絕。
    execFileSync('codex', ['exec', '--cd', outDir, '--skip-git-repo-check', '-s', 'workspace-write', '-'], {
      input: prompt, stdio: ['pipe', 'ignore', 'pipe'],
      maxBuffer: 64 * 1024 * 1024, timeout: 30 * 60 * 1000,
    });
  } catch (e) {
    const tail = String(e.stderr || '').trim().split('\n').slice(-3).join(' / ');
    redo.push(`${id}: codex 失敗 ${tail || e.message.split('\n')[0]}`);
    continue;
  }
  if (!existsSync(file) || statSync(file).mtimeMs === before) {
    redo.push(`${id}: 回報成功但檔案沒有更新`);
    continue;
  }
  const { w, h, corners } = inspect(file);
  if (w !== 1024 || h !== 1024) redo.push(`${id}: 尺寸 ${w}×${h}，不是 1024×1024`);
  else if (corners.some((a) => a < 255)) redo.push(`${id}: 四角 alpha ${corners.join('/')}，不是完全不透明`);
  else console.log(`ok ${id}`);
}

console.log(redo.length ? `\n要重做：\n- ${redo.join('\n- ')}` : '\n全部通過');
