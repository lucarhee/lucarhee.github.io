#!/usr/bin/env python3
"""
generate_posts_index.py
=======================
assets/posts/*.md 파일을 스캔해 YAML 프론트매터를 읽고
assets/posts/index.json 을 자동으로 갱신합니다.

사용법:
  python scripts/generate_posts_index.py

새 글을 추가할 때:
  1. assets/posts/YYYY-MM-DD-slug.md 파일 생성 (프론트매터 포함)
  2. python scripts/generate_posts_index.py 실행
  3. git add assets/posts/ && git commit && git push
"""

import os
import json
import re
import math
from pathlib import Path
from datetime import datetime


POSTS_DIR = Path(__file__).parent.parent / "assets" / "posts"
INDEX_FILE = POSTS_DIR / "index.json"

# 평균 읽기 속도 (단어/분)
WORDS_PER_MINUTE = 200


def parse_frontmatter(content: str) -> tuple[dict, str]:
    """YAML 프론트매터를 파싱해 (메타데이터, 본문) 튜플 반환."""
    content = content.strip()
    if not content.startswith("---"):
        return {}, content

    end = content.find("\n---", 3)
    if end == -1:
        return {}, content

    frontmatter_str = content[3:end].strip()
    body = content[end + 4:].strip()

    meta = {}
    for line in frontmatter_str.splitlines():
        line = line.strip()
        if ":" not in line:
            continue
        key, _, value = line.partition(":")
        key = key.strip()
        value = value.strip()

        # 리스트 파싱: [a, b, c] 또는 a, b, c
        if value.startswith("[") and value.endswith("]"):
            items = value[1:-1].split(",")
            meta[key] = [item.strip().strip('"').strip("'") for item in items if item.strip()]
        else:
            # 숫자 변환
            try:
                meta[key] = int(value)
            except ValueError:
                try:
                    meta[key] = float(value)
                except ValueError:
                    meta[key] = value.strip('"').strip("'")

    return meta, body


def estimate_read_time(text: str) -> int:
    """본문 단어 수를 기반으로 읽기 시간(분) 추정."""
    word_count = len(re.findall(r'\w+', text))
    minutes = math.ceil(word_count / WORDS_PER_MINUTE)
    return max(1, minutes)


def slug_from_filename(filename: str) -> str:
    """파일명에서 slug 추출 (확장자 제거)."""
    return Path(filename).stem


def process_post(md_file: Path) -> dict | None:
    """단일 .md 파일을 처리해 포스트 메타데이터 딕셔너리 반환."""
    try:
        content = md_file.read_text(encoding="utf-8")
    except Exception as e:
        print(f"  ⚠️  {md_file.name} 읽기 실패: {e}")
        return None

    meta, body = parse_frontmatter(content)
    slug = slug_from_filename(md_file.name)

    # 필수 필드 검증
    if not meta.get("title"):
        print(f"  ⚠️  {md_file.name}: 'title' 필드가 없습니다. 파일명을 제목으로 사용합니다.")
        meta["title"] = slug.replace("-", " ").title()

    if not meta.get("date"):
        # 파일명에서 날짜 추출 (YYYY-MM-DD-slug 형식)
        date_match = re.match(r"(\d{4}-\d{2}-\d{2})", md_file.name)
        meta["date"] = date_match.group(1) if date_match else datetime.now().strftime("%Y-%m-%d")
        print(f"  ℹ️  {md_file.name}: 날짜를 파일명에서 추출했습니다: {meta['date']}")

    # 읽기 시간 추정 (프론트매터에 없으면 자동 계산)
    if not meta.get("readTime"):
        meta["readTime"] = estimate_read_time(body)

    # tags 기본값
    if not meta.get("tags"):
        meta["tags"] = []

    # description 기본값
    if not meta.get("description"):
        # 첫 번째 단락에서 추출
        first_para = re.search(r'^[^#\n].+', body, re.MULTILINE)
        if first_para:
            desc = first_para.group(0)[:150]
            meta["description"] = desc + ("..." if len(first_para.group(0)) > 150 else "")
        else:
            meta["description"] = ""

    return {
        "slug": slug,
        "title": meta["title"],
        "date": str(meta["date"]),
        "description": meta["description"],
        "tags": meta["tags"] if isinstance(meta["tags"], list) else [meta["tags"]],
        "readTime": int(meta["readTime"]),
    }


def main():
    print("🔍 포스트 인덱스 생성 중...")
    print(f"   경로: {POSTS_DIR}\n")

    if not POSTS_DIR.exists():
        print(f"❌ 디렉토리를 찾을 수 없습니다: {POSTS_DIR}")
        return

    # .md 파일 스캔 (index.json 제외)
    md_files = sorted(
        [f for f in POSTS_DIR.glob("*.md") if f.name != "README.md"],
        reverse=True,  # 최신 순
    )

    if not md_files:
        print("📭 마크다운 파일이 없습니다.")
        posts = []
    else:
        posts = []
        for md_file in md_files:
            print(f"  📄 처리중: {md_file.name}")
            post = process_post(md_file)
            if post:
                posts.append(post)
                print(f"     ✅ '{post['title']}' (태그: {', '.join(post['tags'])}, {post['readTime']}분)")

    # 날짜 기준 내림차순 정렬
    posts.sort(key=lambda p: p["date"], reverse=True)

    # index.json 저장
    index_data = {"posts": posts}
    INDEX_FILE.write_text(
        json.dumps(index_data, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )

    print(f"\n✨ 완료! 총 {len(posts)}개 포스트 → {INDEX_FILE.name}")


if __name__ == "__main__":
    main()
