import ast
import json
import re
import sys

text = sys.stdin.read().strip()


def try_parse(val):
    if isinstance(val, list):
        return val
    if isinstance(val, str):
        val_clean = val.strip()
        try:
            res = json.loads(val_clean)
            if isinstance(res, list):
                return res
        except:
            pass
        try:
            res = ast.literal_eval(val_clean)
            if isinstance(res, list):
                return res
        except:
            pass
    return None


try:
    data = json.loads(text)
    if isinstance(data, dict):
        if "message" in data:
            parsed = try_parse(data["message"])
            if parsed is not None:
                print(json.dumps(parsed))
                sys.exit(0)
        if "code" in data:
            parsed = try_parse(data["code"])
            if parsed is not None:
                print(json.dumps(parsed))
                sys.exit(0)
    elif isinstance(data, list):
        print(json.dumps(data))
        sys.exit(0)
except:
    pass

match = re.search(r"(\[.*?\])", text, re.DOTALL)
if match:
    try:
        res = json.loads(match.group(1))
        if isinstance(res, list):
            print(json.dumps(res))
            sys.exit(0)
    except:
        pass
    try:
        res = ast.literal_eval(match.group(1))
        if isinstance(res, list):
            print(json.dumps(res))
            sys.exit(0)
    except:
        pass

print("[]")
