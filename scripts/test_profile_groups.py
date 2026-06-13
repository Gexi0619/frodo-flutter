#!/usr/bin/env python3
"""快速验证 profile_group_info 的翻页行为。

复刻 app 里 frodo 的鉴权（lib/src/api/auth_interceptor.dart）：
  Bearer + apikey + HMAC-SHA1 签名（query 里的 _sig / _ts）。

用法：
    python3 scripts/test_profile_groups.py [user_id] [count]
默认 user_id=1712199, count=20，会一直翻到底并打印每页的 start/total/返回条数。
"""
import base64
import hashlib
import hmac
import ssl
import sys
import time
import urllib.parse
import urllib.request
import json

# Homebrew 版 Python 常缺系统 CA，测试脚本直接跳过证书校验。
_SSL_CTX = ssl.create_default_context()
_SSL_CTX.check_hostname = False
_SSL_CTX.verify_mode = ssl.CERT_NONE

# —— 凭证：取自 lib/src/constants.dart（MVP 内置样例）——
BASE_URL = "https://frodo.douban.com"
BEARER = "4ec348a0f4e651b8ec49d9e2deb2f528"
API_KEY = "0dad551ec0f84ed02907ff5c42e8ec70"
SIGN_SECRET = "bf7dddc7c9cfe6f7"
USER_AGENT = (
    "api-client/1 com.douban.frodo/7.124.0(352) Android/30 "
    "udid/c397dcb9b23e3c07f63fbd5a195cee0cce6d39c2 "
    "douban_udid/3c1c9aab63a92380275149aac80cd3d3504031ae "
    "model/Pixel 5 brand/Google rom/android network/wifi "
    "platform/mobile foldable/0 nd/1 product/motion_phone_arm64 vendor/Genymobile"
)


def sign(method: str, path: str, bearer: str) -> tuple[str, str]:
    """复刻 _signFrodo：
    1. path 先 url-decode，长度>1 且以 / 结尾则去掉末尾 /
    2. encodedPath = url-encode(path)（'/' 也编码成 %2F）
    3. message = METHOD & encodedPath & bearer & ts
    4. sig = base64(HMAC-SHA1(secret, message))
    """
    decoded = urllib.parse.unquote(path)
    if len(decoded) > 1 and decoded.endswith("/"):
        decoded = decoded[:-1]
    encoded_path = urllib.parse.quote(decoded, safe="")
    ts = str(int(time.time()))
    message = "&".join([method.upper(), encoded_path, bearer, ts])
    digest = hmac.new(SIGN_SECRET.encode(), message.encode(), hashlib.sha1).digest()
    return base64.b64encode(digest).decode(), ts


def fetch(path: str, params: dict) -> dict:
    sig, ts = sign("GET", path, BEARER)
    query = dict(params)
    query.update({"apikey": API_KEY, "_ts": ts, "_sig": sig})
    url = f"{BASE_URL}{path}?{urllib.parse.urlencode(query)}"
    req = urllib.request.Request(
        url,
        headers={
            "User-Agent": USER_AGENT,
            "Authorization": f"Bearer {BEARER}",
        },
    )
    with urllib.request.urlopen(req, timeout=30, context=_SSL_CTX) as resp:
        return json.loads(resp.read().decode())


def main() -> None:
    user_id = sys.argv[1] if len(sys.argv) > 1 else "1712199"
    count = int(sys.argv[2]) if len(sys.argv) > 2 else 20
    path = f"/api/v2/group/user/{user_id}/profile_group_info"

    print(f"== user {user_id}, count={count} ==")
    start = 0
    fetched = 0
    page_no = 0
    while True:
        page_no += 1
        data = fetch(path, {"start": start, "count": count})
        groups = data.get("groups", [])
        # total 字段不统一：首页 groups_total，翻页后 total
        total = data.get("total", data.get("groups_total"))
        print(
            f"[page {page_no}] start={start} 返回={len(groups)} "
            f"total={total} groups_total={data.get('groups_total')} "
            f"resp.start={data.get('start')} resp.count={data.get('count')}"
        )
        for g in groups:
            print(f"    - {g.get('id'):>8}  {g.get('name')}")
        fetched += len(groups)

        # 到底判定：空页 或 不足一页
        if not groups or len(groups) < count:
            break
        start += len(groups)

    print(f"\n累计拉到 {fetched} 个小组（接口报 total={total}）")


if __name__ == "__main__":
    main()
