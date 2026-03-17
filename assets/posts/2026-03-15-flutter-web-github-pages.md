---
title: Flutter Web을 GitHub Pages에 배포하는 완벽 가이드
date: 2026-03-15
description: Flutter Web 앱을 GitHub Pages에 배포하는 방법을 단계별로 알아봅니다.
tags: [flutter, web, github, deployment]
readTime: 8
---

# Flutter Web을 GitHub Pages에 배포하는 완벽 가이드

Flutter는 단 하나의 코드베이스로 iOS, Android, Web, Desktop을 모두 지원합니다. 이 글에서는 Flutter Web 앱을 **GitHub Pages**에 배포하는 전체 과정을 다룹니다.

## 사전 요구사항

- Flutter SDK 3.0 이상 설치
- GitHub 계정 및 저장소
- 기본적인 Git 사용법

## 1. Flutter Web 활성화

Flutter Web을 사용하려면 먼저 Web 지원을 활성화해야 합니다.

```bash
flutter config --enable-web
flutter devices
```

`Chrome (web-javascript)` 가 목록에 표시되면 준비 완료입니다.

## 2. Web 빌드 생성

프로젝트 루트에서 다음 명령어를 실행합니다.

```bash
flutter build web --release --base-href "/your-repo-name/"
```

> **중요**: `--base-href` 값은 반드시 GitHub 저장소 이름과 일치해야 합니다. 예를 들어 저장소 이름이 `my-blog`라면 `--base-href "/my-blog/"` 로 설정합니다.

빌드 결과물은 `build/web/` 폴더에 생성됩니다.

## 3. GitHub Actions 자동 배포 설정

매번 수동으로 빌드하고 배포하는 것은 번거롭습니다. GitHub Actions를 이용하면 `main` 브랜치에 푸시할 때마다 자동으로 배포됩니다.

`.github/workflows/deploy.yml` 파일을 생성하고 다음 내용을 입력합니다.

```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches: [main]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.x'
          channel: 'stable'

      - run: flutter pub get
      - run: python scripts/generate_posts_index.py
      - run: flutter build web --release --base-href "/${{ github.event.repository.name }}/"

      - uses: peaceiris/actions-gh-pages@v4
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./build/web
```

## 4. GitHub Pages 활성화

1. GitHub 저장소 → **Settings** → **Pages** 이동
2. **Source**: `Deploy from a branch`
3. **Branch**: `gh-pages` 선택
4. **Save** 클릭

## 5. 커스텀 도메인 설정 (선택사항)

개인 도메인이 있다면 `web/` 폴더에 `CNAME` 파일을 생성합니다.

```
yourdomain.com
```

그리고 DNS에서 CNAME 레코드를 `your-username.github.io`로 설정합니다.

## 마무리

이제 `main` 브랜치에 코드를 푸시할 때마다 GitHub Actions가 자동으로:

1. Flutter Web 빌드 실행
2. 포스트 인덱스 자동 업데이트
3. `gh-pages` 브랜치에 배포

약 2~3분 후 `https://your-username.github.io/your-repo-name/` 에서 사이트를 확인할 수 있습니다.

---

다음 글에서는 Flutter Web 성능 최적화 방법에 대해 다루겠습니다.
