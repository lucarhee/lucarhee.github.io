# 💙 Flutter Blog — GitHub Pages

Flutter Web으로 만든 포트폴리오 + 블로그 사이트입니다.
마크다운 파일을 커밋하면 GitHub Actions가 자동으로 빌드·배포합니다.

## ✨ 기능

- 포트폴리오 홈 (Hero, Skills, 최근 글)
- 블로그 목록 (태그 필터, 검색)
- 마크다운 포스트 뷰어 (코드 복사 버튼, 구문 하이라이트)
- 라이트 / 다크 모드 토글
- 반응형 (모바일 + 데스크탑)
- GitHub Actions 자동 배포

---

## 🚀 빠른 시작

### 1. 저장소 설정

```bash
git clone https://github.com/YOUR_USERNAME/YOUR_REPO.git
cd YOUR_REPO
flutter pub get
```

### 2. 로컬 개발 서버

```bash
flutter run -d chrome
```

### 3. 로컬 빌드 테스트

```bash
flutter build web --release --base-href "/YOUR_REPO_NAME/"
```

---

## ✍️ 새 글 쓰기 (워크플로우)

### 방법 1: 자동 (권장)

1. `assets/posts/` 폴더에 마크다운 파일 생성

```
assets/posts/YYYY-MM-DD-글-제목.md
```

2. 파일 상단에 **YAML 프론트매터** 작성:

```yaml
---
title: 내 글 제목
date: 2026-03-17
description: 글에 대한 한 줄 요약
tags: [flutter, dart, tutorial]
readTime: 5
---

# 본문 시작...
```

3. 커밋 & 푸시

```bash
git add assets/posts/
git push origin main
```

GitHub Actions가 자동으로:
- 포스트 인덱스 갱신 (`index.json`)
- Flutter Web 빌드
- GitHub Pages 배포

### 방법 2: 수동 인덱스 업데이트

```bash
python scripts/generate_posts_index.py
git add assets/posts/index.json
git commit -m "add: new post"
git push
```

---

## 🏗️ 프로젝트 구조

```
flutter_blog/
├── lib/
│   ├── main.dart              # 앱 진입점
│   ├── router.dart            # 라우팅 (go_router)
│   ├── theme/
│   │   └── app_theme.dart     # 라이트/다크 테마
│   ├── models/
│   │   └── post.dart          # 포스트 데이터 모델
│   ├── providers/
│   │   ├── theme_provider.dart  # 테마 상태
│   │   └── posts_provider.dart  # 포스트 로드/검색
│   ├── screens/
│   │   ├── home_screen.dart   # 포트폴리오 홈
│   │   ├── blog_screen.dart   # 블로그 목록
│   │   └── post_screen.dart   # 포스트 상세
│   └── widgets/
│       ├── navbar.dart        # 상단 네비게이션
│       ├── post_card.dart     # 블로그 카드
│       └── tag_chip.dart      # 태그 칩
│
├── assets/
│   └── posts/
│       ├── index.json         # ⚡ 자동 생성 — 직접 수정 금지
│       └── *.md               # 여기에 글 추가!
│
├── scripts/
│   └── generate_posts_index.py  # 인덱스 자동 생성 스크립트
│
├── .github/
│   └── workflows/
│       └── deploy.yml         # GitHub Actions 자동 배포
│
└── web/
    └── index.html             # 로딩 스크린
```

---

## ⚙️ GitHub Pages 초기 설정

1. GitHub 저장소 → **Settings** → **Pages**
2. Source: `Deploy from a branch`
3. Branch: `gh-pages` / `/ (root)` → **Save**
4. 첫 번째 푸시 후 약 2~3분 뒤 배포 완료

배포 URL: `https://YOUR_USERNAME.github.io/YOUR_REPO_NAME/`

---

## 🎨 커스터마이징

### 프로필 수정

`lib/screens/home_screen.dart` 의 `_HeroText` 위젯에서:

```dart
Text('Hello, I\'m\nYour Name.', ...)  // ← 이름 변경
Text('Flutter Developer & Technical Writer.\n...') // ← 소개 변경
```

### 스킬 수정

같은 파일의 `_SkillsSection._skills` 리스트:

```dart
static const _skills = [
  ('Flutter', '🐦', AppTheme.primary),
  ('Dart', '🎯', AppTheme.secondary),
  // 원하는 스킬 추가/수정
];
```

### 색상 테마 수정

`lib/theme/app_theme.dart`:

```dart
static const Color primary = Color(0xFF8B5CF6);    // 메인 색상
static const Color secondary = Color(0xFF06B6D4);  // 보조 색상
```

---

## 📦 사용 패키지

| 패키지 | 용도 |
|--------|------|
| `go_router` | 라우팅 |
| `flutter_markdown` | 마크다운 렌더링 |
| `google_fonts` | Inter, Poppins 폰트 |
| `provider` | 상태관리 |
| `flutter_animate` | 애니메이션 |
| `url_launcher` | 외부 링크 열기 |
