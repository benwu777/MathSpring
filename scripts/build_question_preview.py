#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""產生單一 HTML 檔，用瀏覽器瀏覽整個題庫。

用途是人工複審：可以依年級／主題／作答方式／圖形種類篩選，切換四語系，
搜尋題幹與子分類，並展開看詳解與圖形參數。純靜態、不需要伺服器，
打開檔案就能用。

    python3 scripts/build_question_preview.py [輸出路徑]

產出的 HTML 會把整個題庫（約 10 MB）內嵌進去，所以刻意不放進 git，
預設輸出到系統暫存目錄。要重新產生就再跑一次這支程式。
"""
import glob
import html
import json
import os
import re
import subprocess
import sys

ROOT = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
                    'assets', 'questions')
LANGS = ['zh-Hant', 'zh-Hans', 'en', 'ja']


ID_LINE = re.compile(r'^\+\s*"id": "([a-z_]+_grade\d+_foundation_\d{3})"')


def parse_first_added(log_text):
    """從 `git log -p` 的輸出找出每個題號第一次被加進來的時間（unix 秒）。

    題號可能因為重排、重新格式化而在後來的 commit 再「新增」一次，所以取最早的。
    """
    added = {}
    ts = None
    for line in log_text.splitlines():
        if line.startswith('__C '):
            ts = int(line[4:])
            continue
        m = ID_LINE.match(line)
        if m and ts is not None:
            qid = m.group(1)
            added[qid] = min(ts, added.get(qid, ts))
    return added


def first_added_times():
    out = subprocess.run(
        ['git', 'log', '-p', '--format=__C %ct', '--', 'assets/questions'],
        cwd=os.path.dirname(os.path.dirname(ROOT)), capture_output=True, text=True,
    ).stdout
    return parse_first_added(out)


def load():
    added = first_added_times()
    rows = []
    for path in sorted(glob.glob(os.path.join(ROOT, '*', '*.json'))):
        if os.path.basename(path) == 'manifest.json':
            continue
        pack = json.load(open(path, encoding='utf-8'))
        for q in pack['questions']:
            m = re.search(r'grade(\d+)', q.get('levelStage', ''))
            fig = q.get('figure') or {}
            rows.append({
                'id': q['id'],
                'g': int(m.group(1)) if m else 0,
                't': q['topic'],
                's': q['subtopic'],
                'm': q['answerMode'],
                'v': q['correctAnswer']['value'],
                'f': fig.get('kind', 'none'),
                'fp': fig.get('params') if fig.get('kind', 'none') != 'none' else None,
                'p': q['prompt'],
                'a': q['answer'],
                'st': q['solutionSteps'],
                'o': q.get('options'),
                'src': (q.get('source') or {}).get('notes', ''),
                'ad': added.get(q['id'], 0),
            })
    # 新題在前；同一批再依年級、主題、題號排
    rows.sort(key=lambda r: (-r['ad'], r['g'], r['t'], r['id']))
    return rows


TEMPLATE = r"""<!doctype html>
<html lang="zh-Hant"><head>
<meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>MathSpring 題庫瀏覽</title>
<style>
:root{--bg:#fbfbfa;--fg:#1a1a19;--mut:#6b6b68;--line:#e3e3e0;--card:#fff;--acc:#2f6f4e;--warn:#8a4b2a}
@media (prefers-color-scheme:dark){:root{--bg:#191918;--fg:#eeeeec;--mut:#9a9a96;--line:#333331;--card:#212120;--acc:#7fbf9a;--warn:#d99b6a}}
*{box-sizing:border-box}
body{margin:0;background:var(--bg);color:var(--fg);font:15px/1.65 -apple-system,"Noto Sans TC","PingFang TC",sans-serif}
header{position:sticky;top:0;z-index:9;background:var(--bg);border-bottom:1px solid var(--line);padding:14px 20px}
h1{margin:0 0 4px;font-size:18px;font-weight:650}
.sub{color:var(--mut);font-size:13px}
.bar{display:flex;flex-wrap:wrap;gap:8px;margin-top:12px;align-items:center}
select,input[type=search]{font:inherit;font-size:13px;padding:6px 9px;border:1px solid var(--line);border-radius:7px;background:var(--card);color:var(--fg)}
input[type=search]{min-width:230px;flex:1}
.langs{display:flex;gap:0;border:1px solid var(--line);border-radius:7px;overflow:hidden}
.langs button{font:inherit;font-size:13px;padding:6px 11px;border:0;background:var(--card);color:var(--mut);cursor:pointer}
.langs button.on{background:var(--acc);color:#fff}
main{padding:16px 20px 60px;max-width:960px;margin:0 auto}
.count{color:var(--mut);font-size:13px;margin-bottom:12px}
.q{background:var(--card);border:1px solid var(--line);border-radius:10px;padding:14px 16px;margin-bottom:10px}
.meta{display:flex;flex-wrap:wrap;gap:6px;align-items:center;margin-bottom:8px}
.chip{font-size:11px;padding:2px 7px;border-radius:20px;background:var(--bg);border:1px solid var(--line);color:var(--mut)}
.chip.g{color:var(--acc);border-color:var(--acc)}
.qid{font-family:ui-monospace,SFMono-Regular,Menlo,monospace;font-size:11px;color:var(--mut);margin-left:auto}
.prompt{margin:0 0 10px;white-space:pre-wrap}
.opts{margin:0 0 10px;padding-left:0;list-style:none;font-size:14px}
.opts li{padding:2px 0;color:var(--mut)}
.opts li.ok{color:var(--acc);font-weight:600}
.ans{font-size:14px}
.ans b{color:var(--acc)}
details{margin-top:9px;border-top:1px dashed var(--line);padding-top:8px}
summary{cursor:pointer;color:var(--mut);font-size:13px;user-select:none}
ol{margin:8px 0 0;padding-left:22px}
ol li{margin:4px 0}
pre{background:var(--bg);border:1px solid var(--line);border-radius:7px;padding:9px;overflow:auto;font-size:11.5px;margin:8px 0 0}
.note{color:var(--mut);font-size:12px;margin-top:8px;font-style:italic}
.figwrap{margin:0 0 10px}
svg.fig{display:block;background:#fff;border:1px solid var(--line);border-radius:8px;max-width:100%;height:auto}
.figjson{margin-top:6px;border-top:0;padding-top:0}
.figjson summary{font-size:12px}
.figerr{color:var(--warn);font-size:13px;padding:8px;border:1px dashed var(--warn);border-radius:8px}
.more{display:block;width:100%;padding:11px;margin-top:8px;font:inherit;background:var(--card);border:1px solid var(--line);border-radius:9px;color:var(--acc);cursor:pointer}
.empty{color:var(--mut);padding:40px 0;text-align:center}
</style></head><body>
<header>
  <h1>MathSpring 題庫瀏覽</h1>
  <div class="sub" id="sub"></div>
  <div class="bar">
    <select id="fg"></select><select id="ft"></select><select id="fm"></select><select id="ff"></select>
    <div class="langs" id="langs"></div>
    <input type="search" id="q" placeholder="搜尋題幹、子分類、id、答案…">
  </div>
</header>
<main><div class="count" id="count"></div><div id="list"></div></main>
<script type="application/json" id="data">__DATA__</script>
<script>
const DATA = JSON.parse(document.getElementById('data').textContent);
/* ── 圖形渲染：移植自 lib/src/question_figures.dart 與 lib/src/diagram_painters.dart 的 CustomPainter ──
   數值（padding、比例、半徑、顏色）都對齊 Dart 原始實作，
   讓這裡看到的和 app 裡畫出來的一致。                        */
const AR = {shape_diagram:1.25, coordinate_plane:1.35, composite_grid_shape:1.1,
            circle_quadrants_point:1.15};
const FW = 380;
const C = {ink:'#111827', fill:'#E0E7FF', grid:'#CBD5E1', empty:'#F8FAFC',
           gInk:'#1F2937', acc:'#2B5FA6', shF:'rgba(228,120,85,0.122)', shS:'#C65B3C',
           cgrid:'#E5E7EB', axis:'#334155', pt:'#1D4ED8', hi:'#DC2626', path:'#0F766E',
           conn:'#334155'};
const SUP={'0':'⁰','1':'¹','2':'²','3':'³','4':'⁴','5':'⁵','6':'⁶','7':'⁷','8':'⁸','9':'⁹','+':'⁺','-':'⁻','n':'ⁿ','x':'ˣ'};
function mathText(t){
  return String(t??'').replace(/([A-Za-z0-9.π)\]]+)\^(-?\d+|[nx])/g,
    (m,b,e)=> b + [...e].map(ch=>SUP[ch]??('^'+ch)).join(''));
}
const A = (s)=>String(s).replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
function T(x,y,t,o){
  o=o||{};
  if(t===undefined||t===null||t==='') return '';
  return `<text x="${x.toFixed(1)}" y="${y.toFixed(1)}" text-anchor="middle" dominant-baseline="central" `
   +`font-size="${o.s||13}" fill="${o.c||C.ink}" font-weight="${o.b?700:500}" `
   +`font-family="-apple-system,'Noto Sans TC',sans-serif">${A(mathText(t))}</text>`;
}
const num = (v,d)=> (typeof v==='number'&&isFinite(v))?v:(v!=null&&isFinite(+v)?+v:d);

function figSVG(kind, P){
  P = P || {};
  let ar = AR[kind];
  if (kind==='geometry_scene'){
    const b=P.bounds||{}, sx=num(b.maxX,1)-num(b.minX,0), sy=num(b.maxY,1)-num(b.minY,0);
    ar = sy<=0 ? 1.2 : Math.min(1.7, Math.max(0.75, sx/sy));
  }
  if(!ar) ar = 1.55;
  const W=FW, H=Math.round(FW/ar);
  let body='';
  try{
    if(kind==='geometry_scene') body=gScene(P,W,H);
    else if(kind==='coordinate_plane') body=coordPlane(P,W,H);
    else if(kind==='composite_grid_shape') body=gridShape(P,W,H);
    else if(kind==='shape_diagram') body=shapeDiag(P,W,H);
    else if(kind==='circle_quadrants_point') body=circleQuad(P,W,H);
    else return '';
  }catch(e){ return `<div class="figerr">圖形繪製失敗：${A(e.message)}</div>`; }
  return `<svg class="fig" viewBox="0 0 ${W} ${H}" width="${W}" height="${H}" xmlns="http://www.w3.org/2000/svg">${body}</svg>`;
}

/* geometry_scene：數學座標 y 向上，等比縮放置中，padding 18 */
function gScene(P,W,H){
  const pad=18, b=P.bounds||{};
  const mnX=num(b.minX,0), mnY=num(b.minY,0), mxX=num(b.maxX,1), mxY=num(b.maxY,1);
  const aw=Math.max(W-2*pad,1), ah=Math.max(H-2*pad,1);
  const spX=Math.max(mxX-mnX,1e-9), spY=Math.max(mxY-mnY,1e-9);
  const sc=Math.min(aw/spX, ah/spY);
  const ox=pad+(aw-spX*sc)/2, oy=pad+(ah-spY*sc)/2;
  const M=(x,y)=>[ox+(x-mnX)*sc, oy+(mxY-y)*sc];
  const pts={}, lpos={}, vis={};
  (P.points||[]).forEach(p=>{ pts[p.name]=M(num(p.x,0),num(p.y,0)); lpos[p.name]=p.pos||'r'; vis[p.name]=p.visible!==false; });
  const p_=n=>pts[n]||[0,0];
  const unit=(a,b)=>{const d=Math.hypot(a,b); return d===0?[0,0]:[a/d,b/d];};
  let o='';
  (P.polygons||[]).forEach(pg=>{
    const d=(pg.vertices||[]).map(v=>p_(v).map(n=>n.toFixed(1)).join(',')).join(' ');
    if(d) o+=`<polygon points="${d}" fill="${C.shF}" stroke="${C.shS}" stroke-width="1.6" stroke-linejoin="round"/>`;
  });
  (P.arcs||[]).forEach(a=>{
    const cx=num(a.cx,0),cy=num(a.cy,0),r=num(a.r,1),f=num(a.from,0),t=num(a.to,0),N=48;
    let d='';
    for(let i=0;i<=N;i++){const rad=(f+(t-f)*i/N)*Math.PI/180;
      const [X,Y]=M(cx+r*Math.cos(rad), cy+r*Math.sin(rad)); d+=`${X.toFixed(1)},${Y.toFixed(1)} `;}
    o+=`<polyline points="${d.trim()}" fill="none" stroke="${C.gInk}" stroke-width="2.2" stroke-linecap="round"/>`;
  });
  (P.segments||[]).forEach(s=>{
    const [x1,y1]=p_(s.from), [x2,y2]=p_(s.to);
    const dash = s.style==='construction';
    o+=`<line x1="${x1.toFixed(1)}" y1="${y1.toFixed(1)}" x2="${x2.toFixed(1)}" y2="${y2.toFixed(1)}" `
      +`stroke="${dash?C.acc:C.gInk}" stroke-width="${dash?1.7:2.2}" stroke-linecap="round"${dash?' stroke-dasharray="6 5"':''}/>`;
  });
  (P.rightAngles||[]).forEach(ra=>{
    const v=p_(ra.at), d1=unit(p_(ra.from)[0]-v[0], p_(ra.from)[1]-v[1]), d2=unit(p_(ra.to)[0]-v[0], p_(ra.to)[1]-v[1]);
    const k=12;
    o+=`<polyline points="${(v[0]+d1[0]*k).toFixed(1)},${(v[1]+d1[1]*k).toFixed(1)} `
      +`${(v[0]+(d1[0]+d2[0])*k).toFixed(1)},${(v[1]+(d1[1]+d2[1])*k).toFixed(1)} `
      +`${(v[0]+d2[0]*k).toFixed(1)},${(v[1]+d2[1]*k).toFixed(1)}" fill="none" stroke="${C.acc}" stroke-width="1.7"/>`;
  });
  (P.angleMarks||[]).forEach(am=>{
    const v=p_(am.at), d1=unit(p_(am.from)[0]-v[0],p_(am.from)[1]-v[1]), d2=unit(p_(am.to)[0]-v[0],p_(am.to)[1]-v[1]);
    const a1=Math.atan2(d1[1],d1[0]); let sw=Math.atan2(d2[1],d2[0])-a1;
    while(sw<=-Math.PI) sw+=2*Math.PI; while(sw>Math.PI) sw-=2*Math.PI;
    const r=22, N=24; let d='';
    for(let i=0;i<=N;i++){const a=a1+sw*i/N; d+=`${(v[0]+r*Math.cos(a)).toFixed(1)},${(v[1]+r*Math.sin(a)).toFixed(1)} `;}
    o+=`<polyline points="${d.trim()}" fill="none" stroke="${C.acc}" stroke-width="1.7"/>`;
    if(am.label){const ma=a1+sw/2;
      o+=T(v[0]+Math.cos(ma)*(r+12), v[1]+Math.sin(ma)*(r+12), am.label, {c:C.acc,s:13});}
  });
  (P.equalTicks||[]).forEach(et=>{
    const n=num(et.count,1);
    (et.segments||[]).forEach(sg=>{
      if(!sg||sg.length<2) return;
      const a=p_(sg[0]), b=p_(sg[1]);
      const mid=[(a[0]+b[0])/2,(a[1]+b[1])/2], dir=unit(b[0]-a[0],b[1]-a[1]), pp=[-dir[1],dir[0]];
      for(let i=0;i<n;i++){
        const al=(i-(n-1)/2)*5, c=[mid[0]+dir[0]*al, mid[1]+dir[1]*al];
        o+=`<line x1="${(c[0]-pp[0]*6).toFixed(1)}" y1="${(c[1]-pp[1]*6).toFixed(1)}" `
          +`x2="${(c[0]+pp[0]*6).toFixed(1)}" y2="${(c[1]+pp[1]*6).toFixed(1)}" stroke="${C.gInk}" stroke-width="1.8"/>`;
      }
    });
  });
  const LD={t:[0,-1],b:[0,1],l:[-1,0],r:[1,0],tl:[-0.7,-0.7],tr:[0.7,-0.7],bl:[-0.7,0.7],br:[0.7,0.7]};
  Object.keys(pts).forEach(n=>{
    if(!vis[n]) return;
    const [x,y]=pts[n], d=LD[lpos[n]]||LD.r;
    o+=`<circle cx="${x.toFixed(1)}" cy="${y.toFixed(1)}" r="4.5" fill="#fff" stroke="${C.gInk}" stroke-width="2"/>`;
    o+=T(Math.min(Math.max(x+d[0]*15,10),W-10), Math.min(Math.max(y+d[1]*15,10),H-10), n, {c:C.gInk,s:14,b:1});
  });
  return o;
}

/* coordinate_plane：leftPad 42 / rightPad 22 / topPad 20 / bottomPad 34 */
function coordPlane(P,W,H){
  const L=42,R=22,Tp=20,B=34;
  const pl={l:L,t:Tp,r:W-R,b:H-B,w:W-L-R,h:H-Tp-B};
  const mnX=num(P.minX,0),mxX=num(P.maxX,6),mnY=num(P.minY,0),mxY=num(P.maxY,6);
  const sx=Math.max(mxX-mnX,1), sy=Math.max(mxY-mnY,1);
  const X=v=>pl.l+(v-mnX)/sx*pl.w, Y=v=>pl.b-(v-mnY)/sy*pl.h;
  let o='';
  if(P.showGrid!==false){
    for(let x=mnX;x<=mxX;x++){const dx=X(x);
      o+=`<line x1="${dx.toFixed(1)}" y1="${pl.t}" x2="${dx.toFixed(1)}" y2="${pl.b}" stroke="${C.cgrid}" stroke-width="1"/>`;
      o+=T(dx,pl.b+14,String(x),{s:11,c:C.axis});}
    for(let y=mnY;y<=mxY;y++){const dy=Y(y);
      o+=`<line x1="${pl.l}" y1="${dy.toFixed(1)}" x2="${pl.r}" y2="${dy.toFixed(1)}" stroke="${C.cgrid}" stroke-width="1"/>`;
      if(y!==0) o+=T(pl.l-14,dy,String(y),{s:11,c:C.axis});}
  }
  const ax=(mnX<=0&&0<=mxX)?X(0):pl.l, ay=(mnY<=0&&0<=mxY)?Y(0):pl.b;
  o+=`<line x1="${pl.l}" y1="${ay.toFixed(1)}" x2="${pl.r}" y2="${ay.toFixed(1)}" stroke="${C.axis}" stroke-width="1.6"/>`;
  o+=`<line x1="${ax.toFixed(1)}" y1="${pl.b}" x2="${ax.toFixed(1)}" y2="${pl.t}" stroke="${C.axis}" stroke-width="1.6"/>`;
  const pp=P.path||[];
  if(pp.length>=2){
    o+=`<polyline points="${pp.map(p=>`${X(num(p.x,0)).toFixed(1)},${Y(num(p.y,0)).toFixed(1)}`).join(' ')}" `
      +`fill="none" stroke="${C.path}" stroke-width="3"/>`;
  }
  const hp=P.highlightPoint;
  (P.points||[]).forEach(p=>{
    const x=X(num(p.x,0)), y=Y(num(p.y,0));
    const on = hp && num(hp.x,NaN)===num(p.x,0) && num(hp.y,NaN)===num(p.y,0);
    o+=`<circle cx="${x.toFixed(1)}" cy="${y.toFixed(1)}" r="5" fill="${on?C.hi:C.pt}"/>`;
    if(p.label) o+=T(x,y-16,p.label,{s:12,b:1,c:C.ink});
  });
  return o;
}

/* composite_grid_shape：格子邊長 min(W*0.72/cols, H*0.72/rows)，外露邊加粗描邊 */
function gridShape(P,W,H){
  const rows=num(P.rows,3), cols=num(P.cols,3);
  const filled=(P.filledCells||[]).filter(c=>Array.isArray(c)).map(c=>[num(c[0],0),num(c[1],0)]);
  const keys=new Set(filled.map(c=>c[0]+','+c[1]));
  const lab=P.cellLabels||{};
  const cs=Math.min(W*0.72/cols, H*0.72/rows);
  const sx=(W-cols*cs)/2, sy=(H-rows*cs)/2;
  let o='';
  for(let r=0;r<rows;r++) for(let c=0;c<cols;c++){
    const x=sx+c*cs, y=sy+r*cs, k=r+','+c;
    o+=`<rect x="${x.toFixed(1)}" y="${y.toFixed(1)}" width="${cs.toFixed(1)}" height="${cs.toFixed(1)}" `
      +`fill="${keys.has(k)?C.fill:C.empty}" stroke="${C.grid}" stroke-width="1.2"/>`;
    if(lab[k]) o+=T(x+cs/2, y+cs/2, lab[k], {s:12});
  }
  filled.forEach(([r,c])=>{
    const x=sx+c*cs, y=sy+r*cs;
    const E=(x1,y1,x2,y2)=>`<line x1="${x1.toFixed(1)}" y1="${y1.toFixed(1)}" x2="${x2.toFixed(1)}" y2="${y2.toFixed(1)}" stroke="${C.ink}" stroke-width="2.6" stroke-linecap="square"/>`;
    if(!keys.has((r-1)+','+c)) o+=E(x,y,x+cs,y);
    if(!keys.has((r+1)+','+c)) o+=E(x,y+cs,x+cs,y+cs);
    if(!keys.has(r+','+(c-1))) o+=E(x,y,x,y+cs);
    if(!keys.has(r+','+(c+1))) o+=E(x+cs,y,x+cs,y+cs);
  });
  return o;
}

/* shape_diagram：基準矩形 (0.18W, 0.18H, 0.64W, 0.48H) */
function shapeDiag(P,W,H){
  const L=P.labels||{}, sh=P.shape||'rectangle';
  const rx=W*0.18, ry=H*0.18, rw=W*0.64, rh=H*0.48;
  const cx=rx+rw/2, cy=ry+rh/2;
  const S=(d)=>`<path d="${d}" fill="${C.fill}" stroke="${C.ink}" stroke-width="3" stroke-linejoin="round"/>`;
  const poly=(pts)=>S('M'+pts.map(p=>p.map(n=>n.toFixed(1)).join(' ')).join('L')+'Z');
  const box=(x,y,w,h)=>`<rect x="${x.toFixed(1)}" y="${y.toFixed(1)}" width="${w.toFixed(1)}" height="${h.toFixed(1)}" fill="${C.fill}" stroke="${C.ink}" stroke-width="3"/>`;
  const rectLabels=(x,y,w,h)=> T(x+w/2,y-18,L.top)+T(x+w/2,y+h+18,L.bottom)+T(x-18,y+h/2,L.left)+T(x+w+18,y+h/2,L.right)+T(x+w/2,y+h/2,L.center);
  let o='';
  if(sh==='compass'){
    const arm=Math.min(W,H)*0.24, X=W/2, Y=H/2, ln=(x1,y1,x2,y2)=>`<line x1="${x1}" y1="${y1}" x2="${x2}" y2="${y2}" stroke="${C.ink}" stroke-width="3"/>`;
    o+=ln(X,Y-arm,X,Y+arm)+ln(X-arm,Y,X+arm,Y);
    o+=T(X,Y-arm-22,L.top||'N')+T(X+arm+22,Y,L.right||'E')+T(X,Y+arm+22,L.bottom||'S')+T(X-arm-22,Y,L.left||'W')+T(X,Y,L.center);
  } else if(sh==='square'){
    const side=Math.min(rw,rh), x=cx-side/2, y=cy-side/2;
    o+=box(x,y,side,side)+rectLabels(x,y,side,side);
  } else if(sh==='triangle'){
    o+=poly([[W*0.5,H*0.16],[W*0.22,H*0.7],[W*0.78,H*0.7]]);
    o+=T(W*0.5,H*0.1,L.top)+T(W*0.18,H*0.48,L.left)+T(W*0.82,H*0.48,L.right)+T(W*0.5,H*0.76,L.bottom);
  } else if(sh==='trapezoid'){
    o+=poly([[W*0.34,H*0.22],[W*0.66,H*0.22],[W*0.8,H*0.7],[W*0.2,H*0.7]]);
    o+=T(W*0.5,H*0.14,L.top)+T(W*0.5,H*0.78,L.bottom)+T(W*0.16,H*0.46,L.left)+T(W*0.84,H*0.46,L.right)+T(W*0.5,H*0.48,L.center);
  } else if(sh==='parallelogram'){
    o+=poly([[W*0.3,H*0.22],[W*0.76,H*0.22],[W*0.64,H*0.7],[W*0.18,H*0.7]]);
    o+=T(W*0.53,H*0.14,L.top)+T(W*0.41,H*0.78,L.bottom)+T(W*0.14,H*0.48,L.left)+T(W*0.8,H*0.48,L.right)+T(W*0.47,H*0.46,L.center);
  } else if(sh==='pentagon'){
    o+=poly([[W*0.5,H*0.14],[W*0.78,H*0.34],[W*0.68,H*0.7],[W*0.32,H*0.7],[W*0.22,H*0.34]]);
    o+=T(W*0.5,H*0.08,L.top)+T(W*0.16,H*0.44,L.left)+T(W*0.84,H*0.44,L.right)+T(W*0.5,H*0.78,L.bottom)+T(W*0.5,H*0.46,L.center);
  } else if(sh==='hexagon'){
    o+=poly([[W*0.34,H*0.18],[W*0.66,H*0.18],[W*0.82,H*0.44],[W*0.66,H*0.7],[W*0.34,H*0.7],[W*0.18,H*0.44]]);
    o+=T(W*0.5,H*0.1,L.top)+T(W*0.14,H*0.44,L.left)+T(W*0.86,H*0.44,L.right)+T(W*0.5,H*0.78,L.bottom)+T(W*0.5,H*0.44,L.center);
  } else if(sh==='circle'){
    const r=Math.min(W,H)*0.24;
    o+=`<circle cx="${W/2}" cy="${H/2}" r="${r.toFixed(1)}" fill="${C.fill}" stroke="${C.ink}" stroke-width="3"/>`;
    o+=T(W/2,H/2,L.center)+T(W/2,H/2-r-18,L.top)+T(W/2+r+18,H/2,L.right);
  } else if(sh==='oval'){
    const w=rw*0.92, h=rh*0.86;
    o+=`<ellipse cx="${cx.toFixed(1)}" cy="${cy.toFixed(1)}" rx="${(w/2).toFixed(1)}" ry="${(h/2).toFixed(1)}" fill="${C.fill}" stroke="${C.ink}" stroke-width="3"/>`;
    o+=rectLabels(cx-w/2,cy-h/2,w,h);
  } else {
    o+=box(rx,ry,rw,rh)+rectLabels(rx,ry,rw,rh);
  }
  return o;
}

/* circle_quadrants_point：半徑 min(W,H)*0.34，P 點偏心 */
function circleQuad(P,W,H){
  const RL=P.regionLabels||{}, pl=P.pointLabel||'P', shaded=P.shadedRegion||'topRight';
  const X=W/2, Y=H/2, r=Math.min(W,H)*0.34;
  const top=[X,Y-r], right=[X+r,Y], bot=[X,Y+r], left=[X-r,Y];
  const p=[X-r*0.18, Y+r*0.1];
  let o='';
  if(shaded==='topRight'){
    o+=`<path d="M${top[0]} ${top[1]} A${r} ${r} 0 0 1 ${right[0]} ${right[1]} L${p[0].toFixed(1)} ${p[1].toFixed(1)} Z" fill="${C.fill}"/>`;
  }
  o+=`<circle cx="${X}" cy="${Y}" r="${r.toFixed(1)}" fill="none" stroke="${C.ink}" stroke-width="2.5"/>`;
  [top,right,bot,left].forEach(q=>{
    o+=`<line x1="${q[0].toFixed(1)}" y1="${q[1].toFixed(1)}" x2="${p[0].toFixed(1)}" y2="${p[1].toFixed(1)}" stroke="${C.conn}" stroke-width="2"/>`;});
  o+=`<circle cx="${p[0].toFixed(1)}" cy="${p[1].toFixed(1)}" r="4.5" fill="${C.hi}"/>`;
  o+=T(top[0]-6,top[1]-24,'A')+T(right[0]+18,right[1]-8,'B')+T(bot[0]-6,bot[1]+12,'C')+T(left[0]-24,left[1]-8,'D');
  o+=T(p[0]-6,p[1]-22,pl);
  o+=T(X-r*0.34,Y-r*0.28,RL.topLeft)+T(X+r*0.28,Y-r*0.26,RL.topRight)
    +T(X-r*0.38,Y+r*0.3,RL.bottomLeft)+T(X+r*0.26,Y+r*0.3,RL.bottomRight);
  return o;
}
const LANGS = __LANGS__;
const LABEL = {'zh-Hant':'繁','zh-Hans':'简','en':'EN','ja':'日'};
let lang = 'zh-Hant', shown = 0, filtered = [];
const PAGE = 40;

const uniq = (k) => [...new Set(DATA.map(r => r[k]))].sort((a,b)=> (typeof a==='number')?a-b:String(a).localeCompare(String(b)));
function fill(sel, key, all){
  const el = document.getElementById(sel);
  el.innerHTML = `<option value="">${all}</option>` + uniq(key).map(v=>`<option value="${v}">${key==='g'?'grade'+v:v}</option>`).join('');
}
fill('fg','g','全部年級'); fill('ft','t','全部主題'); fill('fm','m','全部作答方式'); fill('ff','f','全部圖形');
document.getElementById('langs').innerHTML = LANGS.map(l=>`<button data-l="${l}" class="${l==='zh-Hant'?'on':''}">${LABEL[l]}</button>`).join('');
document.getElementById('sub').textContent = `共 ${DATA.length} 題　·　產生自 assets/questions　·　純靜態，可離線瀏覽`;

const esc = s => String(s??'').replace(/[&<>"]/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'}[c]));

function card(r){
  const opts = r.o ? `<ul class="opts">${Object.entries(r.o).map(([k,v])=>
      `<li class="${k===r.v?'ok':''}">${esc(k)}. ${esc(v[lang]??v['zh-Hant'])}${k===r.v?' ✓':''}</li>`).join('')}</ul>` : '';
  const steps = (r.st[lang]||[]).map(s=>`<li>${esc(s)}</li>`).join('');
  const fig = r.fp ? `<div class="figwrap">${figSVG(r.f, r.fp)}
      <details class="figjson"><summary>圖形參數 JSON（${esc(r.f)}）</summary><pre>${esc(JSON.stringify(r.fp,null,1))}</pre></details></div>` : '';
  const note = r.src ? `<div class="note">${esc(r.src)}</div>` : '';
  return `<div class="q">
    <div class="meta">
      <span class="chip g">grade${r.g}</span><span class="chip">${esc(r.t)}</span>
      <span class="chip">${esc(r.s)}</span><span class="chip">${r.m==='multiple_choice'?'選擇':'填答'}</span>
      ${r.f!=='none'?`<span class="chip">${esc(r.f)}</span>`:''}
      ${r.ad?`<span class="chip">新增 ${new Date(r.ad*1000).toISOString().slice(0,10)}</span>`:''}
      <span class="qid">${esc(r.id)}</span>
    </div>
    <p class="prompt">${esc(r.p[lang]??r.p['zh-Hant'])}</p>
    ${fig}
    ${opts}
    <div class="ans">${esc(r.a[lang]??r.a['zh-Hant'])}　<b>［${esc(r.v)}］</b></div>
    <details><summary>詳解（${(r.st[lang]||[]).length} 步）</summary><ol>${steps}</ol>${note}</details>
  </div>`;
}

function render(reset){
  const list = document.getElementById('list');
  if (reset){ list.innerHTML=''; shown=0; }
  const slice = filtered.slice(shown, shown+PAGE);
  list.insertAdjacentHTML('beforeend', slice.map(card).join(''));
  shown += slice.length;
  const btn = document.getElementById('more'); if (btn) btn.remove();
  if (shown < filtered.length){
    list.insertAdjacentHTML('beforeend',
      `<button class="more" id="more">再載入 ${Math.min(PAGE, filtered.length-shown)} 題（還有 ${filtered.length-shown} 題）</button>`);
    document.getElementById('more').onclick = () => render(false);
  }
  if (!filtered.length) list.innerHTML = '<div class="empty">沒有符合條件的題目</div>';
  document.getElementById('count').textContent = `顯示 ${Math.min(shown,filtered.length)} / ${filtered.length} 題`;
}

function apply(){
  const g=document.getElementById('fg').value, t=document.getElementById('ft').value,
        m=document.getElementById('fm').value, f=document.getElementById('ff').value,
        kw=document.getElementById('q').value.trim().toLowerCase();
  filtered = DATA.filter(r=>{
    if (g && String(r.g)!==g) return false;
    if (t && r.t!==t) return false;
    if (m && r.m!==m) return false;
    if (f && r.f!==f) return false;
    if (kw){
      const hay = (r.id+' '+r.s+' '+r.v+' '+LANGS.map(l=>r.p[l]||'').join(' ')).toLowerCase();
      if (!hay.includes(kw)) return false;
    }
    return true;
  });
  render(true);
}
['fg','ft','fm','ff'].forEach(i=>document.getElementById(i).onchange=apply);
let deb; document.getElementById('q').oninput = ()=>{clearTimeout(deb); deb=setTimeout(apply,180);};
document.getElementById('langs').onclick = e=>{
  const b=e.target.closest('button'); if(!b) return;
  lang=b.dataset.l;
  [...document.querySelectorAll('.langs button')].forEach(x=>x.classList.toggle('on',x===b));
  render(true);
};
apply();
</script></body></html>
"""


def main():
    out = sys.argv[1] if len(sys.argv) > 1 else os.path.join(
        os.environ.get('TMPDIR', '/tmp'), 'mathspring-question-preview.html')
    rows = load()
    blob = json.dumps(rows, ensure_ascii=False, separators=(',', ':'))
    # 內嵌在 <script> 裡，必須拆掉任何會提前關閉標籤的字串
    blob = blob.replace('</', '<\\/')
    page = TEMPLATE.replace('__DATA__', blob).replace('__LANGS__', json.dumps(LANGS))
    with open(out, 'w', encoding='utf-8') as f:
        f.write(page)
    size = os.path.getsize(out) / 1024 / 1024
    print('%d 題　→　%s（%.1f MB）' % (len(rows), out, size))
    return out


if __name__ == '__main__':
    main()
