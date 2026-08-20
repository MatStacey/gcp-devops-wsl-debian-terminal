import sys, re
with open(sys.argv[1], "r", encoding="utf-8") as f: c = f.read()
updates = "## 🚀 Recent Updates & Enhancements\n\n" + sys.argv[2] + "\n\n---"
c_new = re.sub(r"## 🚀 Recent Updates & Enhancements.*?---", updates, c, flags=re.DOTALL)
with open(sys.argv[1], "w", encoding="utf-8") as f: f.write(c_new)
