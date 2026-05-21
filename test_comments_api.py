#!/usr/bin/env python3
"""
测试豆瓣 frodo API 评论接口：对比正序 (nested=1) vs 倒序 (order_by=time_desc)
中 ref_comment / parent_comment_id 的结构，排查引用显示问题。
"""

import base64
import hashlib
import hmac
import json
import time
import urllib.parse

import requests

# ── 凭证（来自 constants.dart）──────────────────────────────────────────────
BEARER_TOKEN = '4ec348a0f4e651b8ec49d9e2deb2f528'
API_KEY      = '0dad551ec0f84ed02907ff5c42e8ec70'
SIGN_SECRET  = 'bf7dddc7c9cfe6f7'
BASE_URL     = 'https://frodo.douban.com'
USER_AGENT   = (
    'api-client/1 com.douban.frodo/7.124.0(352) Android/30 '
    'udid/c397dcb9b23e3c07f63fbd5a195cee0cce6d39c2 '
    'douban_udid/3c1c9aab63a92380275149aac80cd3d3504031ae '
    'model/Pixel 5 brand/Google rom/android network/wifi '
    'platform/mobile foldable/0 nd/1 product/motion_phone_arm64 vendor/Genymobile'
)

TOPIC_ID = '481732791'


def sign(method: str, path: str) -> dict:
    """复现 auth_interceptor.dart 的 HMAC-SHA1 签名算法。"""
    decoded = urllib.parse.unquote(path)
    if len(decoded) > 1 and decoded.endswith('/'):
        decoded = decoded[:-1]
    encoded_path = urllib.parse.quote(decoded, safe='')
    ts = str(int(time.time()))
    message = f'{method.upper()}&{encoded_path}&{BEARER_TOKEN}&{ts}'
    sig = base64.b64encode(
        hmac.new(SIGN_SECRET.encode(), message.encode(), hashlib.sha1).digest()
    ).decode()
    return {'_ts': ts, '_sig': sig}


def get(path: str, params: dict = None) -> dict:
    params = params or {}
    params['apikey'] = API_KEY
    params.update(sign('GET', path))
    r = requests.get(
        BASE_URL + path,
        params=params,
        headers={
            'User-Agent': USER_AGENT,
            'Authorization': f'Bearer {BEARER_TOKEN}',
        },
        timeout=15,
    )
    r.raise_for_status()
    return r.json()


def summarize_comment(c: dict, indent: int = 0) -> None:
    pad = '  ' * indent
    cid    = c.get('id', '?')
    author = (c.get('author') or {}).get('name', '?')
    text   = (c.get('text') or '')[:40].replace('\n', ' ')
    pid    = c.get('parent_comment_id')
    ref    = c.get('ref_comment')
    total  = c.get('total_replies', 0)

    print(f"{pad}[{cid}] {author}: {text!r}")
    if pid:
        print(f"{pad}  parent_comment_id = {pid}")
    if ref:
        ref_id     = ref.get('id', '?')
        ref_author = (ref.get('author') or {}).get('name', '?')
        ref_text   = (ref.get('text') or '')[:40].replace('\n', ' ')
        same_as_parent = (pid is not None and ref_id == pid)
        print(f"{pad}  ref_comment.id = {ref_id}  author={ref_author}  text={ref_text!r}  (id==parent? {same_as_parent})")
    else:
        print(f"{pad}  ref_comment = None")
    if total:
        print(f"{pad}  total_replies = {total}")


def test_comments(order: str) -> None:
    is_asc = order != 'time_desc'
    label  = '正序 (nested=1)' if is_asc else '倒序 (order_by=time_desc)'
    path   = f'/api/v2/group/topic/{TOPIC_ID}/comments'
    params = {'start': 0, 'count': 10}
    if is_asc:
        params['nested'] = 1
    else:
        params['order_by'] = 'time_desc'

    print(f'\n{"="*60}')
    print(f'  {label}')
    print(f'  GET {path}  params={params}')
    print('='*60)

    data = get(path, params)
    comments = data.get('comments') or data.get('items') or []
    print(f'返回 {len(comments)} 条评论  total={data.get("total")}')

    has_ref      = 0
    ref_eq_pid   = 0   # ref_comment.id == parent_comment_id  → 引用块会被隐藏
    ref_neq_pid  = 0   # ref_comment.id != parent_comment_id  → 引用块会显示

    for c in comments:
        summarize_comment(c)
        ref = c.get('ref_comment')
        pid = c.get('parent_comment_id')
        if ref:
            has_ref += 1
            if pid is not None and ref.get('id') == pid:
                ref_eq_pid += 1
            else:
                ref_neq_pid += 1

        # 也检查 nested replies
        for r in c.get('replies') or []:
            summarize_comment(r, indent=1)
            rref = r.get('ref_comment')
            rpid = r.get('parent_comment_id')
            if rref:
                has_ref += 1
                if rpid is not None and rref.get('id') == rpid:
                    ref_eq_pid += 1
                else:
                    ref_neq_pid += 1

    print(f'\n  有 ref_comment 的条目: {has_ref}')
    print(f'  ref.id == parent_comment_id (引用块被隐藏): {ref_eq_pid}')
    print(f'  ref.id != parent_comment_id (引用块正常显示): {ref_neq_pid}')


def test_replies(comment_id: str) -> None:
    """测试楼中楼接口，检查 ref_comment / parent_comment_id 结构。"""
    path   = f'/api/v2/group/topic/comment/{comment_id}/replies'
    params = {'start': 0, 'count': 20}

    print(f'\n{"="*60}')
    print(f'  楼中楼  comment_id={comment_id}')
    print(f'  GET {path}')
    print('='*60)

    data    = get(path, params)
    replies = data.get('replies') or []
    print(f'返回 {len(replies)} 条回复')

    ref_eq_pid  = 0
    ref_neq_pid = 0

    for r in replies:
        summarize_comment(r)
        rref = r.get('ref_comment')
        rpid = r.get('parent_comment_id')
        if rref:
            if rpid is not None and rref.get('id') == rpid:
                ref_eq_pid += 1
            else:
                ref_neq_pid += 1

    print(f'\n  ref.id == parent_comment_id (引用块被隐藏): {ref_eq_pid}')
    print(f'  ref.id != parent_comment_id (引用块正常显示): {ref_neq_pid}')


if __name__ == '__main__':
    # 1. 正序主评论列表
    test_comments('time_asc')

    # 2. 倒序主评论列表
    test_comments('time_desc')

    # 3. 找一条有 nested replies 的评论，再单独测楼中楼
    print('\n\n[寻找有回复的评论，测试楼中楼接口...]')
    data = get(f'/api/v2/group/topic/{TOPIC_ID}/comments', {'start': 0, 'count': 20, 'nested': 1})
    comments = data.get('comments') or data.get('items') or []
    for c in comments:
        if (c.get('total_replies') or 0) > 0:
            test_replies(c['id'])
            break
    else:
        print('未找到有回复的评论，跳过楼中楼测试。')
