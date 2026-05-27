# old/ — 버전 아카이브

이 폴더는 이전 버전 스킬의 참조용 아카이브입니다.

## 구조

```
old/
  ├── v0.1.0/    ← 최초 릴리스 (2026-05-27)
  │   └── skills/
  ├── v0.2.0/    ← (추후)
  │   └── skills/
  └── README.md  ← 이 파일
```

## 규칙

- `old/` 폴더는 설치 스크립트(install.sh / install.ps1)에서 **제외**됩니다
- 새 버전 릴리스 시: 현재 `skills/`를 `old/v{현재버전}/`에 복사 후 업그레이드
- git 태그도 동시에 생성 (예: `git tag v0.2.0`)
- 되돌리려면: `old/v{원하는버전}/skills/` → 설치 대상 프로젝트의 `.claude/skills/`에 복사

## 버전 이력

| 버전 | 날짜 | 주요 변경 |
|------|------|---------|
| v0.1.0 | 2026-05-27 | 최초 릴리스. 스킬 4종 (create-contracts / orchestrate / score-review / auto-upgrade) |
