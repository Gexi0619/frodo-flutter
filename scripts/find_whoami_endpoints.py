#!/usr/bin/env python3
"""
扫描 frodo.openapi.json，找出"只用 token 就能识别当前用户"的候选接口。

判定逻辑：
  1) 必须是 GET（POST 副作用太大，不能拿来探测）
  2) 路径不能含具体 user_id 字面量（如 /user/147652575/...），也不能含 user_id 占位符
  3) 必须需要 bearer（params/body 里出现 authorization / bearer_cookie）
  4) response 的 example 或 schema 中出现已知 demo user_id "147652575"
     —— 如果路径本身不带这个 id，但响应里出现了，说明服务端是从 token 反查出来的

输出：按"出现次数"降序排列的候选接口列表。
"""
from __future__ import annotations

import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OPENAPI = ROOT / "frodo.openapi.json"
DEMO_USER_ID = "147652575"   # constants.dart 里硬编码的 demo 用户
DEMO_USER_NAME = "Cicero"     # /service/auth2/token 的 example 中出现的用户名
# 路径中带具体豆瓣 user_id 字面量（如 /user/1712199/...）的也算 user-scoped，排除
NUMERIC_USER_PATH = re.compile(r"/(?:user|users)/(?:user_id|\d{4,})(?:/|$)")
PLACEHOLDER_USER = re.compile(r"\{?user_id\}?|/user_id(?:/|$)")


def needs_bearer(op: dict) -> bool:
    """粗略判定 op 是否需要 frodo Bearer token。"""
    blob = json.dumps(op, ensure_ascii=False).lower()
    return ("authorization" in blob and "bearer" in blob) or "bearer_cookie" in blob


def extract_examples(op: dict) -> list[str]:
    """把 op.responses[*].content.*.example / schema 都序列化成字符串，用于 grep。"""
    out: list[str] = []
    for resp in (op.get("responses") or {}).values():
        if not isinstance(resp, dict):
            continue
        for ct in (resp.get("content") or {}).values():
            if not isinstance(ct, dict):
                continue
            if "example" in ct:
                out.append(json.dumps(ct["example"], ensure_ascii=False))
            if "schema" in ct:
                out.append(json.dumps(ct["schema"], ensure_ascii=False))
            if "examples" in ct and isinstance(ct["examples"], dict):
                for ex in ct["examples"].values():
                    out.append(json.dumps(ex, ensure_ascii=False))
    return out


def path_is_user_scoped(path: str) -> bool:
    return bool(NUMERIC_USER_PATH.search(path) or PLACEHOLDER_USER.search(path))


def score_path(path: str, op: dict) -> tuple[int, int, list[str]]:
    """返回 (demo_user_id 命中数, demo_user_name 命中数, 关键字段命中列表)。"""
    blobs = extract_examples(op)
    text = "\n".join(blobs)
    id_hits = text.count(DEMO_USER_ID)
    name_hits = text.count(DEMO_USER_NAME)

    # 提取响应中含 user_id 的具体上下文片段，方便人工判断
    snippets: list[str] = []
    for blob in blobs:
        for m in re.finditer(re.escape(DEMO_USER_ID), blob):
            start = max(0, m.start() - 40)
            end = min(len(blob), m.end() + 20)
            snippet = blob[start:end].replace("\n", " ")
            snippets.append(snippet)
            if len(snippets) >= 3:
                break
        if len(snippets) >= 3:
            break

    return id_hits, name_hits, snippets


def main() -> int:
    data = json.loads(OPENAPI.read_text(encoding="utf-8"))
    paths = data.get("paths") or {}

    candidates: list[tuple[int, int, str, str, list[str]]] = []
    for path, methods in paths.items():
        if not isinstance(methods, dict):
            continue
        for method, op in methods.items():
            if method.lower() != "get":
                continue
            if path_is_user_scoped(path):
                continue
            if not needs_bearer(op):
                continue
            id_hits, name_hits, snippets = score_path(path, op)
            if id_hits == 0:
                continue
            summary = (op.get("summary") or "").strip()
            candidates.append((id_hits, name_hits, path, summary, snippets))

    candidates.sort(key=lambda r: (r[0], r[1]), reverse=True)

    if not candidates:
        print("没有命中：可能 openapi 中没有保留响应 example。", file=sys.stderr)
        return 1

    print(f"# 共 {len(candidates)} 个候选 — 路径不含 user_id 但响应 example 出现 {DEMO_USER_ID}\n")
    for id_hits, name_hits, path, summary, snippets in candidates:
        print(f"## {path}")
        print(f"  summary : {summary}")
        print(f"  hits    : user_id × {id_hits}, name × {name_hits}")
        for s in snippets:
            print(f"  example : …{s}…")
        print()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
