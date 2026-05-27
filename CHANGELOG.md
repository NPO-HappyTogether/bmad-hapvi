# CHANGELOG

## v0.1.0 (2026-05-27)

### 최초 릴리스

**추가된 스킬**
- `mao-create-contracts` — PRD → 계약서 생성 (타이트/러프/혼합 모드, 멀티에이전트 딥다이브)
- `mao-orchestrate` — 병렬 에이전트 배포, 브리핑 생성, 재브리핑
- `mao-score-review` — 3단계 품질 점수화 (L1 자동 / L2 요약 / L3 상세)
- `mao-auto-upgrade` — 반복 실패 패턴 감지 및 자동 개선 제안

**핵심 설계 원칙**
- PRD와 계약서 분리 (PRD = WHY, 계약서 = HOW TO CONNECT)
- 타이트/러프 실행 모드로 에이전트 자율도 조절
- 10점 만점 가중 평균 점수 시스템
- BMad Method 정신 계승 (사람이 결정, 에이전트가 실행)
