import sys, re

text = sys.stdin.read()
match = re.search(r"\{.*\}", text, re.DOTALL)
if match:
    print(match.group(0))
else:
    print(text)
