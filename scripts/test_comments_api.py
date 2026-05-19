#!/usr/bin/env python3
"""
测试 /api/v2/group/topic/{topic_id}/comments 的各种参数组合，
验证 order_by / nested 的实际行为。
"""

import base64
import hashlib
import hmac
import time
import urllib.parse
import requests

# ── 凭证（来自 constants.dart）──────────────────────────────────────────────
BEARER      = '4ec348a0f4e651b8ec49d9e2deb2f528'
API_KEY     = '0dad551ec0f84ed02907ff5c42e8ec70'
SIGN_SECRET = 'bf7dddc7c9cfe6f7'
USER_AGENT  = (
    'api-client/1 com.douban.frodo/7.124.0(352) Android/30 '
    'udid/c397dcb9b23e3c07f63fbd5a195cee0cce6d39c2 '
    'douban_udid/3c1c9aab63a92380275149aac80cd3d3504031ae '
    'model/Pixel 5 brand/Google rom/android network/wifi '
    'platform/mobile foldable/0 nd/1 product/motion_phone_arm64 vendor/Genymobile'
)
BASE_URL    = 'https://frodo.douban.com'
TOPIC_ID    = '481732791'

def sign(method: str, path: str) -> tuple[str, str]:
    """复现 auth_interceptor.dart 的 HMAC-SHA1 签名。"""
    decoded = urllib.parse.unquote(path)
    if len(decoded) > 1 and decoded.endswith('/'):
        decoded = decoded[:-1]
    encoded_path = urllib.parse.quote(decoded, safe='')
    ts = str(int(time.time()))
    message = '&'.join([method.upper(), encoded_path, BEARER, ts])
    sig = base64.b64encode(
        hmac.new(SIGN_SECRET.encode(), message.encode(), hashlib.sha1).digest()
    ).decode()
    return sig, ts


def fetch(extra_params: dict, label: str) -> None:
    path = f'/api/v2/group/topic/{TOPIC_ID}/comments'
    sig, ts = sign('GET', path)

    params = {
        'apikey': API_KEY,
        'start': 0,
        'count': 3,
        '_ts': ts,
        '_sig': sig,
        **extra_params,
    }
    headers = {
        'Authorization': f'Bearer {BEARER}',
        'User-Agent': USER_AGENT,
    }

    url = BASE_URL + path
    r = requests.get(url, params=params, headers=headers, timeout=10)

    print(f'\n{"─"*60}')
    print(f'[{label}]')
    print(f'  params (sans auth): { {k:v for k,v in params.items() if k not in ("apikey","_ts","_sig")} }')
    print(f'  status: {r.status_code}')

    if r.status_code != 200:
        print(f'  error: {r.text[:200]}')
        return

    data = r.json()
    items = data.get('comments') or data.get('items') or []
    print(f'  total: {data.get("total")}  returned: {len(items)}')

    for i, c in enumerate(items[:3]):
        author = (c.get('author') or {}).get('name', '?')
        create_time = c.get('create_time', '')
        text = (c.get('text') or '')[:40].replace('\n', ' ')
        replies = c.get('replies') or []
        nested_count = len(replies) if isinstance(replies, list) else 0
        print(f'  [{i}] {author} | {create_time} | {text!r}  nested_replies={nested_count}')


if __name__ == '__main__':
    cases = [
        # label,  extra params
        ('①  order_by=time_asc  + nested=1  (旧代码行为)',    {'order_by': 'time_asc', 'nested': 1}),
        ('②  order_by=time_desc + nested=1  (旧代码倒序尝试)', {'order_by': 'time_desc', 'nested': 1}),
        ('③  无 order_by        + nested=1  (应为正序+楼中楼)', {'nested': 1}),
        ('④  无 order_by        + 无 nested  (应为默认正序)',   {}),
        ('⑤  order_by=time_desc + 无 nested  (spec 说的倒序)', {'order_by': 'time_desc'}),
        ('⑥  无 order_by        + 无 nested  (新代码倒序)',     {}),  # 同④，看正序
    ]

    for label, extra in cases:
        fetch(extra, label)
