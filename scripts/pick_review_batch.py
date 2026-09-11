import json, glob, sys
# 用法：pick_review_batch.py <N> <輸出檔> [年級,年級,...]
# 年級省略時預設 grade7~12（第二層）；第三層請傳 grade1,...,grade6
N=int(sys.argv[1]); OUT=sys.argv[2]
GRADES=sys.argv[3].split(",") if len(sys.argv)>3 else ["grade7","grade8","grade9","grade10","grade11","grade12"]
pool={g:[] for g in GRADES}
for path in sorted(glob.glob("assets/questions/*/*.json")):
    d=json.load(open(path,encoding="utf-8"))
    for q in d["questions"]:
        g=q.get("levelStage")
        if g not in pool or q.get("reviewStatus")=="ok": continue
        pool[g].append(q)
total=sum(len(v) for v in pool.values())
print("remaining", GRADES[0]+"-"+GRADES[-1]+":", total, {g:len(v) for g,v in pool.items()})
# 先審長題幹，每個年級各取 N/len(GRADES)，同年級內取最長的
picked=[]
per=max(1, N//len(GRADES))
for g in GRADES:
    v=sorted(pool[g], key=lambda q: -len(q["prompt"]["zh-Hant"]))
    picked += v[:per]
with open(OUT,"w",encoding="utf-8") as f:
    for i,q in enumerate(picked,1):
        f.write(f"[{i}] {q['id']} | {q['levelStage']}\n")
        f.write("題： "+q["prompt"]["zh-Hant"]+"\n")
        f.write("答： "+q["answer"]["zh-Hant"]+"\n")
        for s in q["solutionSteps"]["zh-Hant"]:
            f.write("  - "+s+"\n")
        f.write("="*28+"\n")
print("picked", len(picked), "->", OUT)
