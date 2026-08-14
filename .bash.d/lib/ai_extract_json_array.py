import ast
import contextlib
import json
import re
import sys

text = sys.stdin.read().strip()


def try_parse(val):
    if isinstance(val, list):
        return val
    if isinstance(val, str):
        val_clean = val.strip()
        with contextlib.suppress(ValueError, TypeError):
            res = json.loads(val_clean)
            if isinstance(res, list):
                return res
        with contextlib.suppress(ValueError, TypeError, SyntaxError):
            res = ast.literal_eval(val_clean)
            if isinstance(res, list):
                return res
    return None


with contextlib.suppress(ValueError, TypeError):
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

match = re.search(r"(\[.*\])", text, re.DOTALL)
if match:
    extracted = match.group(1)
    with contextlib.suppress(ValueError, TypeError):
        res = json.loads(extracted)
        if isinstance(res, list):
            print(json.dumps(res))
            sys.exit(0)
    with contextlib.suppress(ValueError, TypeError, SyntaxError):
        res = ast.literal_eval(extracted)
        if isinstance(res, list):
            print(json.dumps(res))
            sys.exit(0)

print("[]")
